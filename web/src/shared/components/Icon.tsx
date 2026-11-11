import styles from './Icon.module.css';

// Ícones do design (docs/design/tokens.md), Material Symbols Rounded.
export type IconName =
  | 'account_circle'
  | 'add'
  | 'arrow_back'
  | 'bolt'
  | 'check'
  | 'check_circle'
  | 'chevron_right'
  | 'close'
  | 'content_copy'
  | 'edit'
  | 'error'
  | 'history'
  | 'how_to_reg'
  | 'location_on'
  | 'lock'
  | 'login'
  | 'logout'
  | 'mail'
  | 'pause_circle'
  | 'play_circle'
  | 'print'
  | 'qr_code_2'
  | 'qr_code_scanner'
  | 'refresh'
  | 'schedule'
  | 'settings'
  | 'storefront'
  | 'wifi_off';

export type IconSize = 16 | 18 | 20 | 22 | 24 | 28 | 32 | 36 | 48 | 64;

interface IconProps {
  name: IconName;
  size?: IconSize;
  // FILL 1 só em ícones de estado (check_circle, error, bolt, pause_circle).
  fill?: boolean;
  className?: string;
}

export function Icon({ name, size = 20, fill = false, className }: IconProps) {
  const classes = [styles.icon, styles[`s${size}`], fill && styles.fill, className]
    .filter(Boolean)
    .join(' ');

  return (
    <span className={classes} aria-hidden="true">
      {name}
    </span>
  );
}
