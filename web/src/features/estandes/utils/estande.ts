import type { ErrosEstande, Estande, ValoresEstande } from '../types';

// Formato do ID do estande (contrato de dados e firestore.rules).
export const CODIGO_REGEX = /^[A-Z0-9]{2,12}$/;
export const CODIGO_MAX = 12;
export const DESCRICAO_MAX = 80;

export function normalizarCodigo(texto: string): string {
  return texto.toUpperCase().replace(/\s+/g, '');
}

// Próximo código livre no padrão E + 2 algarismos (E01, E02…).
export function sugerirCodigo(codigos: string[]): string {
  const numeros = codigos
    .map((c) => /^E(\d+)$/.exec(c)?.[1])
    .filter((n): n is string => n !== undefined)
    .map(Number);
  const proximo = (numeros.length ? Math.max(...numeros) : 0) + 1;
  return `E${String(proximo).padStart(2, '0')}`;
}

export function mensagemCodigoEmUso(codigos: string[]): string {
  return `Código já em uso. Use outro, como ${sugerirCodigo(codigos)}.`;
}

export function validarEstande(
  valores: ValoresEstande,
  opcoes: { criando: boolean; codigosExistentes: string[] },
): ErrosEstande {
  const erros: ErrosEstande = {};

  if (opcoes.criando) {
    if (!valores.codigo) {
      erros.codigo = 'Informe o código.';
    } else if (!CODIGO_REGEX.test(valores.codigo)) {
      erros.codigo = 'Use de 2 a 12 letras maiúsculas ou algarismos, sem espaços.';
    } else if (opcoes.codigosExistentes.includes(valores.codigo)) {
      erros.codigo = mensagemCodigoEmUso(opcoes.codigosExistentes);
    }
  }

  if (!valores.nome.trim()) erros.nome = 'Informe o nome do estande.';

  const descricao = valores.descricao.trim();
  if (!descricao) erros.descricao = 'Escreva uma frase sobre o projeto.';
  else if (descricao.length > DESCRICAO_MAX)
    erros.descricao = `Use no máximo ${DESCRICAO_MAX} caracteres.`;

  if (!valores.localizacao.trim()) erros.localizacao = 'Informe a localização.';

  return erros;
}

export function ordenarPorCodigo(estandes: Estande[]): Estande[] {
  return [...estandes].sort((a, b) => a.id.localeCompare(b.id, 'pt-BR', { numeric: true }));
}

export function resumoEstandes(total: number, ativos: number): string {
  if (total === 0) return 'Nenhum estande cadastrado ainda.';
  const cadastrados = total === 1 ? '1 estande cadastrado' : `${total} estandes cadastrados`;
  const noApp = ativos === 1 ? '1 ativo no app' : `${ativos} ativos no app`;
  return `${cadastrados}, ${noApp}.`;
}
