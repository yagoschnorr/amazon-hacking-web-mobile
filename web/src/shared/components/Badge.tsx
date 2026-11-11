import styles from './Badge.module.css';
import { Icon, type IconName } from './Icon';

export type BadgeStatus = 'ativo' | 'inativo' | 'missao';

const CONTEUDO: Record<BadgeStatus, { icone: IconName; texto: string }> = {
  ativo: { icone: 'check_circle', texto: 'Ativo' },
  inativo: { icone: 'pause_circle', texto: 'Inativo' },
  missao: { icone: 'bolt', texto: 'Missão' },
};

export function Badge({ status }: { status: BadgeStatus }) {
  const { icone, texto } = CONTEUDO[status];

  return (
    <span className={`${styles.badge} ${styles[status]}`}>
      <Icon name={icone} size={16} fill />
      {texto}
    </span>
  );
}
