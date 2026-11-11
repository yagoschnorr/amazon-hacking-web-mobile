import { describe, expect, it } from 'vitest';
import { montarJsonMissao, textoSelecao } from './jsonMissao';

describe('montarJsonMissao', () => {
  it('gera JSON válido só com os códigos selecionados, ordenados', () => {
    const json = montarJsonMissao(['E03', 'E02']);
    expect(json).toBe('["E02","E03"]');
    expect(JSON.parse(json)).toEqual(['E02', 'E03']);
  });

  it('remove repetidos e vazios', () => {
    expect(montarJsonMissao(['E02', 'E02', '', 'E10', 'E9'])).toBe('["E02","E9","E10"]');
  });

  it('gera lista vazia sem seleção', () => {
    expect(montarJsonMissao([])).toBe('[]');
  });
});

describe('textoSelecao', () => {
  it('trata zero, singular e plural', () => {
    expect(textoSelecao(0)).toBe('Nenhum estande selecionado');
    expect(textoSelecao(1)).toBe('1 estande selecionado');
    expect(textoSelecao(2)).toBe('2 estandes selecionados');
  });
});
