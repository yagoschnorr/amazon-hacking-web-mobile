// Conteúdo do QR code (contrato de dados): circuito-descobertas:estande:{estandeId}
export const QR_PREFIXO = 'circuito-descobertas:estande:';

export function buildQrPayload(estandeId: string): string {
  return `${QR_PREFIXO}${estandeId}`;
}
