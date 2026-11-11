import type { EstadoCheckins } from '@/features/checkins';
import { Icon } from '@/shared/components';
import styles from './TotalCheckinsCard.module.css';

function legenda(estado: EstadoCheckins): string {
  if (estado.status === 'carregando') return 'Carregando check-ins…';
  if (estado.status === 'erro') return 'Não foi possível carregar os check-ins.';
  return estado.total === 0
    ? 'Os check-ins aparecem aqui quando os visitantes lerem os QR codes.'
    : 'Somando todos os estandes cadastrados.';
}

// Card de indicador (tokens.md, "Padrões montados nas telas").
export function TotalCheckinsCard({ estado }: { estado: EstadoCheckins }) {
  // Sem check-ins (ou sem dados), o ícone fica neutro, como no design da lista vazia.
  const vazio = estado.status !== 'pronto' || estado.total === 0;

  return (
    <section className={styles.card} aria-labelledby="titulo-total-checkins">
      <span className={`${styles.icone} ${vazio ? styles.iconeVazio : ''}`}>
        <Icon name="how_to_reg" size={28} />
      </span>
      <div className={styles.texto}>
        <h2 id="titulo-total-checkins" className={styles.overline}>
          Check-ins no total
        </h2>
        <p className={styles.numero} aria-live="polite">
          {estado.status === 'pronto' ? estado.total.toLocaleString('pt-BR') : '–'}
        </p>
        <p className={styles.legenda}>{legenda(estado)}</p>
      </div>
    </section>
  );
}
