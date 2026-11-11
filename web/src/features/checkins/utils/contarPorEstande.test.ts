import { describe, expect, it } from 'vitest';
import { contarPorEstande, estandesAlterados, textoCheckinsAteAgora } from './contarPorEstande';

describe('contarPorEstande', () => {
  it('agrupa os check-ins por estandeId', () => {
    const checkins = [
      { estandeId: 'E01' },
      { estandeId: 'E02' },
      { estandeId: 'E01' },
      { estandeId: 'E01' },
    ];
    expect(contarPorEstande(checkins)).toEqual({ E01: 3, E02: 1 });
  });

  it('devolve objeto vazio sem check-ins', () => {
    expect(contarPorEstande([])).toEqual({});
  });

  it('ignora registros sem estandeId válido', () => {
    expect(
      contarPorEstande([{ estandeId: 'E01' }, {}, { estandeId: 7 }, { estandeId: '' }]),
    ).toEqual({ E01: 1 });
  });
});

describe('estandesAlterados', () => {
  it('lista os estandes cujo total mudou, inclusive os novos', () => {
    expect(estandesAlterados({ E01: 2, E02: 1 }, { E01: 3, E02: 1, E03: 1 }).sort()).toEqual([
      'E01',
      'E03',
    ]);
  });

  it('não lista nada quando os totais são iguais', () => {
    expect(estandesAlterados({ E01: 2 }, { E01: 2 })).toEqual([]);
  });
});

describe('textoCheckinsAteAgora', () => {
  it('trata zero, singular e plural', () => {
    expect(textoCheckinsAteAgora(0)).toBe('Nenhum check-in até agora');
    expect(textoCheckinsAteAgora(1)).toBe('1 check-in até agora');
    expect(textoCheckinsAteAgora(12)).toBe('12 check-ins até agora');
  });
});
