import { montarJsonMissao } from './jsonMissao';

// Campos do modal "Iniciar missão". inicio vem do <input type="datetime-local">
// (ex.: 2026-11-20T15:00) e duracao do campo numérico, ainda como texto.
export interface DadosMissao {
  ids: string[];
  semPrazo: boolean;
  inicio: string;
  duracao: string;
}

export interface ErrosMissao {
  estandes?: string;
  inicio?: string;
  duracao?: string;
}

export type TipoParametro = 'BOOLEAN' | 'JSON' | 'STRING' | 'NUMBER';

// Um parâmetro da missão como o Remote Config guarda (valor sempre em texto).
export interface ValorParametro {
  nome: string;
  tipo: TipoParametro;
  valor: string;
}

const CAMPO_LOCAL = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(:\d{2})?$/;
const MINUTO_MS = 60_000;

function doisDigitos(n: number): string {
  return String(n).padStart(2, '0');
}

// Valor inicial do campo de início: a data e a hora locais, sem segundos.
export function paraCampoLocal(data: Date): string {
  return (
    `${data.getFullYear()}-${doisDigitos(data.getMonth() + 1)}-${doisDigitos(data.getDate())}` +
    `T${doisDigitos(data.getHours())}:${doisDigitos(data.getMinutes())}`
  );
}

function inicioValido(local: string): boolean {
  return CAMPO_LOCAL.test(local) && !Number.isNaN(new Date(local).getTime());
}

function duracaoValida(duracao: string): number | null {
  const minutos = Number(duracao);
  return duracao.trim() !== '' && Number.isInteger(minutos) && minutos >= 1 ? minutos : null;
}

// ISO 8601 com o fuso do navegador, como pede missao_inicio
// (ex.: 2026-11-20T15:00 → 2026-11-20T15:00:00-03:00).
export function inicioIso(local: string): string {
  const offset = -new Date(local).getTimezoneOffset();
  const sinal = offset >= 0 ? '+' : '-';
  const abs = Math.abs(offset);
  const segundos = local.length === 16 ? ':00' : '';
  return `${local}${segundos}${sinal}${doisDigitos(Math.floor(abs / 60))}:${doisDigitos(abs % 60)}`;
}

export function validarMissao(dados: DadosMissao, agora: Date): ErrosMissao {
  const erros: ErrosMissao = {};
  if (dados.ids.length === 0) erros.estandes = 'Selecione ao menos um estande.';
  if (dados.semPrazo) return erros;

  const minutos = duracaoValida(dados.duracao);
  if (minutos === null) erros.duracao = 'Informe a duração em minutos inteiros, a partir de 1.';

  if (!inicioValido(dados.inicio)) {
    erros.inicio = 'Informe a data e a hora de início.';
  } else if (
    minutos !== null &&
    new Date(dados.inicio).getTime() + minutos * MINUTO_MS <= agora.getTime()
  ) {
    erros.inicio = 'Com esse início, a missão já terminou. Escolha um horário mais tarde.';
  }
  return erros;
}

// Os quatro parâmetros da missão (docs/contrato-de-dados.md). Sem prazo,
// início vazio e duração 0, que o app trata como missão sem contagem.
export function valoresMissao(dados: DadosMissao): ValorParametro[] {
  const comPrazo = !dados.semPrazo;
  const inicio = comPrazo && inicioValido(dados.inicio) ? inicioIso(dados.inicio) : '';
  const duracao = comPrazo ? (duracaoValida(dados.duracao) ?? 0) : 0;
  return [
    { nome: 'missao_ativa', tipo: 'BOOLEAN', valor: 'true' },
    { nome: 'missao_estandes_ids', tipo: 'JSON', valor: montarJsonMissao(dados.ids) },
    { nome: 'missao_inicio', tipo: 'STRING', valor: inicio },
    { nome: 'missao_duracao_min', tipo: 'NUMBER', valor: String(duracao) },
  ];
}

// Partes do template da API REST do Remote Config que o painel lê e devolve.
interface ParametroRc {
  defaultValue?: { value?: string; useInAppDefault?: boolean };
  valueType?: string;
  [campo: string]: unknown;
}

interface GrupoRc {
  parameters?: Record<string, ParametroRc>;
  [campo: string]: unknown;
}

export interface TemplateRc {
  conditions?: unknown[];
  parameters?: Record<string, ParametroRc>;
  parameterGroups?: Record<string, GrupoRc>;
  [campo: string]: unknown;
}

// Troca só o valor padrão dos parâmetros da missão e mantém o resto do
// template (outros parâmetros, grupos, condições e valores condicionais).
export function aplicarMissao(template: TemplateRc, valores: ValorParametro[]): TemplateRc {
  const parameters = structuredClone(template.parameters ?? {});
  const parameterGroups = structuredClone(template.parameterGroups ?? {});

  for (const { nome, tipo, valor } of valores) {
    const grupo = Object.values(parameterGroups).find((g) => g.parameters?.[nome]);
    const lista = grupo?.parameters ?? parameters;
    lista[nome] = { ...lista[nome], valueType: tipo, defaultValue: { value: valor } };
  }

  return {
    conditions: template.conditions ?? [],
    parameters,
    parameterGroups,
    version: { description: 'Missão publicada pelo painel' },
  };
}
