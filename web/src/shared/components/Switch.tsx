import { useId } from 'react';
import { Icon } from './Icon';
import styles from './Switch.module.css';

interface SwitchProps {
  label: string;
  description?: string;
  checked: boolean;
  onChange: (checked: boolean) => void;
  disabled?: boolean;
}

export function Switch({ label, description, checked, onChange, disabled }: SwitchProps) {
  const id = useId();
  const descricaoId = `${id}-descricao`;

  return (
    <div className={[styles.switch, disabled && styles.disabled].filter(Boolean).join(' ')}>
      <input
        id={id}
        type="checkbox"
        role="switch"
        className={styles.input}
        checked={checked}
        disabled={disabled}
        onChange={(e) => onChange(e.target.checked)}
        aria-describedby={description ? descricaoId : undefined}
      />
      <label htmlFor={id} className={styles.track}>
        <span className={styles.thumb}>{checked && <Icon name="check" size={16} />}</span>
      </label>
      <label htmlFor={id} className={styles.label}>
        {label}
      </label>
      {description && (
        <span id={descricaoId} className={styles.description}>
          {description}
        </span>
      )}
    </div>
  );
}
