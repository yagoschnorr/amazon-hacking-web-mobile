import { Navigate, useParams } from 'react-router';
import { useEstandes } from '@/features/estandes';
import { QrCodePage } from '@/features/qrcode';
import { Alert } from '@/shared/components';
import styles from './QrCodeRoute.module.css';

// Liga os dados do estande (feature estandes) à tela do QR (feature qrcode).
export function QrCodeRoute() {
  const { id } = useParams();
  const { estado } = useEstandes();

  if (estado.status === 'carregando') return null;

  if (estado.status === 'erro') {
    return (
      <main className={styles.erro}>
        <Alert
          title="Não foi possível carregar o estande."
          message="Verifique a conexão e recarregue a página."
        />
      </main>
    );
  }

  const estande = estado.estandes.find((e) => e.id === id);
  if (!estande) return <Navigate to="/estandes" replace />;

  return <QrCodePage estande={estande} />;
}
