import { describe, expect, it } from 'vitest';
import {
  aplicarMissao,
  inicioIso,
  paraCampoLocal,
  validarMissao,
  valoresMissao,
  type DadosMissao,
} from './publicacaoMissao';

const base: DadosMissao = {
  ids: ['E04', 'E02'],
  semPrazo: false,
  inicio: '2026-11-20T15:00',
  duracao: '30',
};
const antes = new Date('2026-11-20T14:00');

describe('inicioIso', () => {
  it('acrescenta segundos e o fuso, apontando para o mesmo instante', () => {
    const iso = inicioIso('2026-11-20T15:00');
    expect(iso).toMatch(/^2026-11-20T15:00:00[+-]\d{2}:\d{2}$/);
    expect(new Date(iso).getTime()).toBe(new Date('2026-11-20T15:00').getTime());
  });

  it('volta ao campo local de origem', () => {
    expect(paraCampoLocal(new Date('2026-01-05T09:07:41'))).toBe('2026-01-05T09:07');
  });
});

describe('validarMissao', () => {
  it('aceita estandes, início e duração válidos', () => {
    expect(validarMissao(base, antes)).toEqual({});
  });

  it('exige estande, início e duração inteira', () => {
    const erros = validarMissao({ ids: [], semPrazo: false, inicio: '', duracao: '2.5' }, antes);
    expect(Object.keys(erros).sort()).toEqual(['duracao', 'estandes', 'inicio']);
  });

  it('recusa missão que já terminou', () => {
    expect(validarMissao(base, new Date('2026-11-20T15:30')).inicio).toMatch(/já terminou/);
    expect(validarMissao(base, new Date('2026-11-20T15:29')).inicio).toBeUndefined();
  });

  it('sem prazo ignora início e duração', () => {
    expect(validarMissao({ ...base, semPrazo: true, inicio: '', duracao: '' }, antes)).toEqual({});
  });
});

describe('valoresMissao', () => {
  it('monta os quatro parâmetros do contrato', () => {
    const valores = valoresMissao(base);
    expect(valores.map((v) => [v.nome, v.tipo])).toEqual([
      ['missao_ativa', 'BOOLEAN'],
      ['missao_estandes_ids', 'JSON'],
      ['missao_inicio', 'STRING'],
      ['missao_duracao_min', 'NUMBER'],
    ]);
    expect(valores[0].valor).toBe('true');
    expect(valores[1].valor).toBe('["E02","E04"]');
    expect(valores[2].valor).toBe(inicioIso('2026-11-20T15:00'));
    expect(valores[3].valor).toBe('30');
  });

  it('sem prazo publica início vazio e duração 0', () => {
    const valores = valoresMissao({ ...base, semPrazo: true });
    expect(valores[2].valor).toBe('');
    expect(valores[3].valor).toBe('0');
  });
});

describe('aplicarMissao', () => {
  const template = {
    conditions: [{ name: 'android', expression: "device.os == 'android'" }],
    parameters: {
      missao_ativa: {
        defaultValue: { value: 'false' },
        conditionalValues: { android: { value: 'false' } },
        valueType: 'BOOLEAN',
      },
      outro: { defaultValue: { value: 'x' }, valueType: 'STRING' },
    },
    parameterGroups: {
      missao: {
        parameters: { missao_inicio: { defaultValue: { useInAppDefault: true } } },
      },
    },
    version: { versionNumber: '7', updateTime: '2026-11-11T00:00:00Z' },
  };

  it('troca só os valores padrão da missão e mantém o resto', () => {
    const novo = aplicarMissao(template, valoresMissao(base));
    expect(novo.conditions).toEqual(template.conditions);
    expect(novo.parameters?.outro).toEqual(template.parameters.outro);
    expect(novo.parameters?.missao_ativa).toEqual({
      defaultValue: { value: 'true' },
      conditionalValues: { android: { value: 'false' } },
      valueType: 'BOOLEAN',
    });
    expect(novo.parameters?.missao_duracao_min?.defaultValue).toEqual({ value: '30' });
    expect(novo.version).toEqual({ description: 'Missão publicada pelo painel' });
  });

  it('atualiza o parâmetro dentro do grupo, sem duplicar', () => {
    const novo = aplicarMissao(template, valoresMissao(base));
    expect(novo.parameters?.missao_inicio).toBeUndefined();
    expect(novo.parameterGroups?.missao.parameters?.missao_inicio).toEqual({
      valueType: 'STRING',
      defaultValue: { value: inicioIso('2026-11-20T15:00') },
    });
  });

  it('não altera o template recebido', () => {
    aplicarMissao(template, valoresMissao(base));
    expect(template.parameters.missao_ativa.defaultValue.value).toBe('false');
  });
});
