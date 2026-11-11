import { useEffect, useId, useRef, type ReactNode } from 'react';
import { Icon, type IconName } from './Icon';
import styles from './Modal.module.css';

export type ModalTone = 'default' | 'danger' | 'missao';

interface ModalProps {
  open: boolean;
  onClose: () => void;
  title: string;
  tone?: ModalTone;
  icon?: IconName;
  children?: ReactNode;
  actions?: ReactNode;
}

// <dialog> nativo: foco preso no modal, Esc fecha e o fundo usa --scrim.
export function Modal({
  open,
  onClose,
  title,
  tone = 'default',
  icon,
  children,
  actions,
}: ModalProps) {
  const ref = useRef<HTMLDialogElement>(null);
  const tituloId = useId();

  useEffect(() => {
    const dialog = ref.current;
    if (!dialog) return;
    if (open && !dialog.open) dialog.showModal();
    if (!open && dialog.open) dialog.close();
  }, [open]);

  return (
    <dialog ref={ref} className={styles.modal} aria-labelledby={tituloId} onClose={onClose}>
      {icon && (
        <span className={`${styles.icon} ${styles[tone]}`}>
          <Icon name={icon} size={24} />
        </span>
      )}
      <h2 id={tituloId} className={styles.title}>
        {title}
      </h2>
      {children && <div className={styles.body}>{children}</div>}
      {actions && <div className={styles.actions}>{actions}</div>}
    </dialog>
  );
}
