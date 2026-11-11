import { Icon, type IconName } from './Icon';
import styles from './Toast.module.css';

export type ToastTone = 'success' | 'error' | 'warning' | 'missao';

const ICONE: Record<ToastTone, IconName> = {
  success: 'check_circle',
  error: 'error',
  warning: 'error',
  missao: 'bolt',
};

interface ToastProps {
  tone?: ToastTone;
  title: string;
  message?: string;
  actionLabel?: string;
  onAction?: () => void;
  onClose: () => void;
}

// Exibido no canto inferior direito da tela.
export function Toast({
  tone = 'success',
  title,
  message,
  actionLabel,
  onAction,
  onClose,
}: ToastProps) {
  return (
    <div className={styles.toast} role="status" aria-live="polite">
      <Icon name={ICONE[tone]} size={24} fill className={styles[tone]} />
      <div className={styles.text}>
        <p className={styles.title}>{title}</p>
        {message && <p className={styles.message}>{message}</p>}
        {actionLabel && onAction && (
          <button type="button" className={styles.action} onClick={onAction}>
            {actionLabel}
          </button>
        )}
      </div>
      <button type="button" className={styles.close} onClick={onClose} aria-label="Fechar aviso">
        <Icon name="close" size={20} />
      </button>
    </div>
  );
}
