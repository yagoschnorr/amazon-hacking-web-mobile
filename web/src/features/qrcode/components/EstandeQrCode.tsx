import { QRCodeSVG } from 'qrcode.react';
import { buildQrPayload } from '../utils/buildQrPayload';
import styles from './EstandeQrCode.module.css';

interface EstandeQrCodeProps {
  estandeId: string;
  // Define a largura e a altura do QR (o SVG escala pelo viewBox).
  className?: string;
}

export function EstandeQrCode({ estandeId, className }: EstandeQrCodeProps) {
  return (
    <QRCodeSVG
      value={buildQrPayload(estandeId)}
      level="M"
      marginSize={4}
      // A cor vem do CSS (--ink sobre --surface), sem hex solto no componente.
      fgColor="currentColor"
      bgColor="transparent"
      title={`QR code do estande ${estandeId}`}
      className={[styles.qr, className].filter(Boolean).join(' ')}
    />
  );
}
