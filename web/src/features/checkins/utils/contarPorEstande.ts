export type TotaisPorEstande = Record<string, number>;

// Agrupa os check-ins por estandeId. Registros sem estandeId válido são ignorados.
export function contarPorEstande(
  checkins: ReadonlyArray<{ estandeId?: unknown }>,
): TotaisPorEstande {
  const totais: TotaisPorEstande = {};
  for (const { estandeId } of checkins) {
    if (typeof estandeId !== 'string' || estandeId === '') continue;
    totais[estandeId] = (totais[estandeId] ?? 0) + 1;
  }
  return totais;
}

// Estandes cujo total mudou entre duas contagens.
export function estandesAlterados(antes: TotaisPorEstande, depois: TotaisPorEstande): string[] {
  const ids = new Set([...Object.keys(antes), ...Object.keys(depois)]);
  return [...ids].filter((id) => (antes[id] ?? 0) !== (depois[id] ?? 0));
}

export function textoCheckinsAteAgora(total: number): string {
  if (total === 0) return 'Nenhum check-in até agora';
  if (total === 1) return '1 check-in até agora';
  return `${total.toLocaleString('pt-BR')} check-ins até agora`;
}
