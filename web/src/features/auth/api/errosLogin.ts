import type { ErroLogin } from '../types';

// Código próprio para conta autenticada sem documento em admins/{uid}.
export const ACESSO_RESTRITO = 'acesso-restrito';

const CREDENCIAIS_INVALIDAS: ErroLogin = {
  titulo: 'E-mail ou senha incorretos.',
  detalhe: 'Confira os dados e tente de novo. A senha diferencia letras maiúsculas e minúsculas.',
};

const FALHA_DE_REDE: ErroLogin = {
  titulo: 'Sem conexão com o servidor.',
  detalhe: 'Verifique a internet e tente de novo.',
};

const MENSAGENS: Record<string, ErroLogin> = {
  'auth/invalid-credential': CREDENCIAIS_INVALIDAS,
  'auth/invalid-email': CREDENCIAIS_INVALIDAS,
  'auth/user-not-found': CREDENCIAIS_INVALIDAS,
  'auth/wrong-password': CREDENCIAIS_INVALIDAS,
  'auth/missing-password': CREDENCIAIS_INVALIDAS,
  'auth/network-request-failed': FALHA_DE_REDE,
  unavailable: FALHA_DE_REDE,
  'auth/too-many-requests': {
    titulo: 'Muitas tentativas seguidas.',
    detalhe: 'Aguarde alguns minutos e tente de novo.',
  },
  'auth/user-disabled': {
    titulo: 'Conta desativada.',
    detalhe: 'Fale com a coordenação do evento.',
  },
  [ACESSO_RESTRITO]: {
    titulo: 'Acesso restrito à organização.',
    detalhe: 'Esta conta não tem permissão para usar o painel.',
  },
};

const ERRO_DESCONHECIDO: ErroLogin = {
  titulo: 'Não foi possível entrar.',
  detalhe: 'Tente de novo em instantes.',
};

export function mensagemErroLogin(erro: unknown): ErroLogin {
  const codigo =
    typeof erro === 'object' && erro !== null && 'code' in erro ? String(erro.code) : '';
  return MENSAGENS[codigo] ?? ERRO_DESCONHECIDO;
}
