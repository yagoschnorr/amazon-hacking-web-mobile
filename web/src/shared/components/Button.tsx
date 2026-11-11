import type { ButtonHTMLAttributes } from 'react';
import { Link, type LinkProps } from 'react-router';
import styles from './Button.module.css';
import { Icon, type IconName } from './Icon';

export type ButtonVariant = 'primary' | 'secondary' | 'danger' | 'missao';
export type ButtonSize = 'md' | 'sm';

interface Aparencia {
  variant?: ButtonVariant;
  size?: ButtonSize;
  icon?: IconName;
}

function classes(variant: ButtonVariant, size: ButtonSize, extra?: string) {
  return [styles.button, styles[variant], size === 'sm' && styles.sm, extra]
    .filter(Boolean)
    .join(' ');
}

export function Button({
  variant = 'primary',
  size = 'md',
  icon,
  type = 'button',
  className,
  children,
  ...rest
}: Aparencia & ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button type={type} className={classes(variant, size, className)} {...rest}>
      {icon && <Icon name={icon} size={20} />}
      {children}
    </button>
  );
}

// Navegação com a aparência de botão (ex.: "Novo estande", "Ver QR code").
export function ButtonLink({
  variant = 'primary',
  size = 'md',
  icon,
  className,
  children,
  ...rest
}: Aparencia & LinkProps) {
  return (
    <Link className={classes(variant, size, className)} {...rest}>
      {icon && <Icon name={icon} size={20} />}
      {children}
    </Link>
  );
}
