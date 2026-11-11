import type { ButtonHTMLAttributes } from 'react';
import { Link, type LinkProps } from 'react-router';
import { Icon, type IconName } from './Icon';
import styles from './IconButton.module.css';

interface Aparencia {
  icon: IconName;
  // Vira o aria-label e a dica do botão.
  label: string;
}

export function IconButton({
  icon,
  label,
  type = 'button',
  className,
  ...rest
}: Aparencia & Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'children'>) {
  return (
    <button
      type={type}
      className={[styles.iconButton, className].filter(Boolean).join(' ')}
      aria-label={label}
      title={label}
      {...rest}
    >
      <Icon name={icon} size={20} />
    </button>
  );
}

export function IconLink({
  icon,
  label,
  className,
  ...rest
}: Aparencia & Omit<LinkProps, 'children'>) {
  return (
    <Link
      className={[styles.iconButton, className].filter(Boolean).join(' ')}
      aria-label={label}
      title={label}
      {...rest}
    >
      <Icon name={icon} size={20} />
    </Link>
  );
}
