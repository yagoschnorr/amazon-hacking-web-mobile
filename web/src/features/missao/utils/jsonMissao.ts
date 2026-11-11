// Valor do parâmetro missao_estandes_ids do Remote Config, por exemplo ["E02","E03"].
// Sem repetidos e em ordem de código, para o admin conferir com a tabela.
export function montarJsonMissao(ids: Iterable<string>): string {
  const unicos = [...new Set(ids)].filter((id) => id.trim() !== '');
  unicos.sort((a, b) => a.localeCompare(b, 'pt-BR', { numeric: true }));
  return JSON.stringify(unicos);
}

export function textoSelecao(selecionados: number): string {
  if (selecionados === 0) return 'Nenhum estande selecionado';
  if (selecionados === 1) return '1 estande selecionado';
  return `${selecionados} estandes selecionados`;
}
