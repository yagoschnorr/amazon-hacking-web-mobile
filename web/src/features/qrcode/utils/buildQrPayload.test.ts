import { describe, expect, it } from 'vitest';
import { buildQrPayload } from './buildQrPayload';

describe('buildQrPayload', () => {
  it('monta o texto do contrato a partir do código do estande', () => {
    expect(buildQrPayload('E03')).toBe('circuito-descobertas:estande:E03');
    expect(buildQrPayload('ABC123')).toBe('circuito-descobertas:estande:ABC123');
  });
});
