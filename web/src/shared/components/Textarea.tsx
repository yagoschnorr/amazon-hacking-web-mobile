import { useId, type TextareaHTMLAttributes } from 'react';
import styles from './Field.module.css';
import { Icon } from './Icon';

interface TextareaProps extends Omit<TextareaHTMLAttributes<HTMLTextAreaElement>, 'id'> {
  label: string;
  hint?: string;
  error?: string;
  optional?: boolean;
}

export function Textarea({
  label,
  hint,
  error,
  optional,
  disabled,
  maxLength,
  value,
  rows = 3,
  ...rest
}: TextareaProps) {
  const id = useId();
  const mensagemId = `${id}-mensagem`;
  const mensagem = error ?? hint;
  const tamanho = String(value ?? '').length;

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
        <textarea
          id={id}
          className={styles.textarea}
          disabled={disabled}
          maxLength={maxLength}
          value={value}
          rows={rows}
          aria-invalid={error ? true : undefined}
          aria-describedby={mensagem ? mensagemId : undefined}
          {...rest}
        />
      </div>

      {(mensagem || maxLength) && (
        <div className={styles.footer}>
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
          {maxLength !== undefined && (
            <span className={styles.counter} aria-live="polite">
              {tamanho}/{maxLength}
            </span>
          )}
        </div>
      )}
    </div>
  );
}
