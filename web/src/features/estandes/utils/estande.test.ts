import { describe, expect, it } from 'vitest';
import type { Estande, ValoresEstande } from '../types';
import {
  normalizarCodigo,
  ordenarPorCodigo,
  resumoEstandes,
  sugerirCodigo,
  validarEstande,
} from './estande';

const valido: ValoresEstande = {
  codigo: 'E04',
  nome: 'Castanha em Rede',
  descricao: 'Mapa colaborativo de pontos de coleta de castanha',
  localizacao: 'Corredor B, estande 4',
  ativo: true,
};

const criando = { criando: true, codigosExistentes: ['E01', 'E02', 'E03'] };

describe('normalizarCodigo', () => {
  it('passa para maiúsculas e remove espaços', () => {
    expect(normalizarCodigo(' e 04 ')).toBe('E04');
  });
});

describe('sugerirCodigo', () => {
  it('sugere o próximo número depois do maior', () => {
    expect(sugerirCodigo(['E01', 'E03', 'E02'])).toBe('E04');
    expect(sugerirCodigo(['E09'])).toBe('E10');
  });

  it('começa em E01 e ignora códigos fora do padrão E + números', () => {
    expect(sugerirCodigo([])).toBe('E01');
    expect(sugerirCodigo(['ABC', 'X1'])).toBe('E01');
  });
});

describe('validarEstande', () => {
  it('aceita valores válidos', () => {
    expect(validarEstande(valido, criando)).toEqual({});
  });

  it('recusa código fora do formato ^[A-Z0-9]{2,12}$', () => {
    for (const codigo of ['', 'E', 'E-04', 'e04', 'ABCDEFGHIJKLM']) {
      expect(validarEstande({ ...valido, codigo }, criando).codigo).toBeDefined();
    }
  });

  it('recusa código já existente e sugere outro', () => {
    expect(validarEstande({ ...valido, codigo: 'E01' }, criando).codigo).toBe(
      'Código já em uso. Use outro, como E04.',
    );
  });

  it('não valida o código na edição', () => {
    expect(
      validarEstande({ ...valido, codigo: 'E01' }, { criando: false, codigosExistentes: ['E01'] }),
    ).toEqual({});
  });

  it('exige nome, descrição e localização, sem contar espaços', () => {
    const erros = validarEstande(
      { ...valido, nome: '  ', descricao: '', localizacao: ' ' },
      criando,
    );
    expect(Object.keys(erros).sort()).toEqual(['descricao', 'localizacao', 'nome']);
  });

  it('limita a descrição a 80 caracteres', () => {
    expect(
      validarEstande({ ...valido, descricao: 'a'.repeat(81) }, criando).descricao,
    ).toBeDefined();
    expect(
      validarEstande({ ...valido, descricao: 'a'.repeat(80) }, criando).descricao,
    ).toBeUndefined();
  });
});

describe('ordenarPorCodigo', () => {
  it('ordena pelo código com números em ordem natural', () => {
    const base = { nome: '', descricao: '', localizacao: '', ativo: true };
    const lista: Estande[] = ['E10', 'E02', 'E1', 'A01'].map((id) => ({ id, ...base }));
    expect(ordenarPorCodigo(lista).map((e) => e.id)).toEqual(['A01', 'E1', 'E02', 'E10']);
  });
});

describe('resumoEstandes', () => {
  it('descreve a lista como no design', () => {
    expect(resumoEstandes(0, 0)).toBe('Nenhum estande cadastrado ainda.');
    expect(resumoEstandes(3, 2)).toBe('3 estandes cadastrados, 2 ativos no app.');
    expect(resumoEstandes(1, 1)).toBe('1 estande cadastrado, 1 ativo no app.');
  });
});
