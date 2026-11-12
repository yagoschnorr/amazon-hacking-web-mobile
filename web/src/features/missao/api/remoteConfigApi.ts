import { FirebaseError, getApps, initializeApp } from 'firebase/app';
import {
  browserPopupRedirectResolver,
  getAuth,
  GoogleAuthProvider,
  inMemoryPersistence,
  initializeAuth,
  signInWithPopup,
  signOut,
  type Auth,
} from 'firebase/auth';
import { app } from '@/shared/lib/firebase';
import { aplicarMissao, type TemplateRc, type ValorParametro } from '../utils/publicacaoMissao';

// O SDK web do Remote Config só lê. Para publicar, o painel usa a API REST
// com um token OAuth da conta Google do projeto, pedido num pop-up. Esse login
// fica numa instância separada do Auth, em memória, e não mexe na sessão do
// administrador (e-mail e senha).
// A API aceita firebase.remoteconfig ou cloud-platform, mas o Google não
// mostra firebase.remoteconfig na tela de consentimento (erro invalid_scope).
// O token fica só em memória e não é salvo em lugar nenhum.
const ESCOPO = 'https://www.googleapis.com/auth/cloud-platform';
const NOME_APP = 'publicacao-missao';
const URL_TEMPLATE = `https://firebaseremoteconfig.googleapis.com/v1/projects/${app.options.projectId}/remoteConfig`;
// O token do Google vale 1 hora; reaproveita por 50 minutos.
const VALIDADE_TOKEN_MS = 50 * 60_000;

export class ErroPublicacao extends Error {
  readonly detalhe: string;

  constructor(titulo: string, detalhe: string) {
    super(titulo);
    this.detalhe = detalhe;
  }
}

let token: { valor: string; expira: number } | null = null;

function authGoogle(): Auth {
  const existente = getApps().find((a) => a.name === NOME_APP);
  if (existente) return getAuth(existente);
  return initializeAuth(initializeApp(app.options, NOME_APP), {
    persistence: inMemoryPersistence,
    popupRedirectResolver: browserPopupRedirectResolver,
  });
}

// Inicializa o Auth do pop-up antes do clique, para o navegador não bloquear a
// janela do Google por demora depois do gesto do usuário.
export function prepararPublicacao(): void {
  authGoogle();
}

function erroDoLogin(erro: unknown): ErroPublicacao {
  const codigo = erro instanceof FirebaseError ? erro.code : '';
  switch (codigo) {
    case 'auth/popup-closed-by-user':
    case 'auth/cancelled-popup-request':
    case 'auth/user-cancelled':
      return new ErroPublicacao(
        'Login com Google cancelado.',
        'Para publicar, entre com a conta Google que administra o projeto no Firebase.',
      );
    case 'auth/popup-blocked':
      return new ErroPublicacao(
        'O navegador bloqueou a janela do Google.',
        'Permita pop-ups para este endereço e tente de novo.',
      );
    case 'auth/operation-not-allowed':
      return new ErroPublicacao(
        'O login com Google não está ativado.',
        'Ative o provedor Google em Authentication no console do Firebase.',
      );
    case 'auth/unauthorized-domain':
      return new ErroPublicacao(
        'Este endereço não está autorizado no Firebase.',
        'Adicione o domínio em Authentication → Configurações → Domínios autorizados.',
      );
    default:
      return new ErroPublicacao(
        'Não foi possível entrar com o Google.',
        'Verifique a conexão e tente de novo.',
      );
  }
}

async function tokenDeAcesso(): Promise<string> {
  if (token && token.expira > Date.now()) return token.valor;

  const provedor = new GoogleAuthProvider();
  provedor.addScope(ESCOPO);
  provedor.setCustomParameters({ prompt: 'select_account' });

  const auth = authGoogle();
  let valor: string | undefined;
  try {
    const resultado = await signInWithPopup(auth, provedor);
    valor = GoogleAuthProvider.credentialFromResult(resultado)?.accessToken;
  } catch (erro) {
    throw erroDoLogin(erro);
  } finally {
    // Só o token interessa; a sessão Google não fica aberta.
    await signOut(auth).catch(() => undefined);
  }
  if (!valor) throw erroDoLogin(null);

  token = { valor, expira: Date.now() + VALIDADE_TOKEN_MS };
  return valor;
}

function erroDaApi(status: number): ErroPublicacao {
  if (status === 401) {
    token = null;
    return new ErroPublicacao('A autorização do Google expirou.', 'Tente de novo.');
  }
  if (status === 403) {
    token = null;
    return new ErroPublicacao(
      'Essa conta Google não pode publicar no Remote Config.',
      'Entre com uma conta proprietária ou editora do projeto e confira se a API do Remote Config está ativada.',
    );
  }
  if (status === 412 || status === 409) {
    return new ErroPublicacao(
      'O Remote Config mudou durante a publicação.',
      'Tente de novo para publicar sobre a versão mais recente.',
    );
  }
  return new ErroPublicacao(
    'Não foi possível publicar a missão.',
    'Tente de novo ou copie os valores e publique no console do Firebase.',
  );
}

async function chamar(init: RequestInit, acesso: string): Promise<Response> {
  let resposta: Response;
  try {
    resposta = await fetch(URL_TEMPLATE, {
      ...init,
      headers: { ...init.headers, Authorization: `Bearer ${acesso}` },
    });
  } catch {
    throw new ErroPublicacao(
      'Sem conexão com o Remote Config.',
      'Verifique a conexão e tente de novo.',
    );
  }
  if (!resposta.ok) throw erroDaApi(resposta.status);
  return resposta;
}

// Lê o template publicado, troca os parâmetros da missão e publica uma nova
// versão. O If-Match com o ETag lido evita sobrescrever uma publicação feita
// no console entre a leitura e a escrita.
export async function publicarMissao(valores: ValorParametro[]): Promise<void> {
  const acesso = await tokenDeAcesso();

  const leitura = await chamar({ method: 'GET' }, acesso);
  const etag = leitura.headers.get('ETag') ?? '*';
  const template = (await leitura.json()) as TemplateRc;

  await chamar(
    {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json; UTF-8', 'If-Match': etag },
      body: JSON.stringify(aplicarMissao(template, valores)),
    },
    acesso,
  );
}
