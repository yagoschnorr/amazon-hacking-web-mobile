import { useId, type InputHTMLAttributes } from 'react';
import styles from './Field.module.css';
import { Icon, type IconName } from './Icon';

interface InputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'id'> {
  label: string;
  hint?: string;
  error?: string;
  icon?: IconName;
  optional?: boolean;
}

export function Input({ label, hint, error, icon, optional, disabled, ...rest }: InputProps) {
  const id = useId();
  const mensagemId = `${id}-mensagem`;
  const mensagem = error ?? hint;

  const classes = [styles.control, error && styles.invalid, disabled && styles.disabled]
    .filter(Boolean)
    .join(' ');

  return (
    <div className={styles.field}>
      <label htmlFor={id} className={styles.label}>
        {label}
        {optional && <span className={styles.optional}> (opcional)</span>}
      </label>

      <div className={classes}>
        {icon && <Icon name={icon} size={20} className={styles.icon} />}
        <input
          id={id}
          className={styles.input}
          disabled={disabled}
          aria-invalid={error ? true : undefined}
          aria-describedby={mensagem ? mensagemId : undefined}
          {...rest}
        />
      </div>

      {error ? (
        <p id={mensagemId} className={styles.error}>
          <Icon name="error" size={16} fill />
          {error}
        </p>
      ) : hint ? (
        <p id={mensagemId} className={styles.hint}>
          {hint}
        </p>
      ) : null}
    </div>
  );
}
