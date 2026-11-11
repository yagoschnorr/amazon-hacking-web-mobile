import styles from './Alert.module.css';
import { Icon } from './Icon';

interface AlertProps {
  title: string;
  message?: string;
}

// Alerta de erro inline (tokens.md, "Padrões montados nas telas").
export function Alert({ title, message }: AlertProps) {
  return (
    <div className={styles.alert} role="alert">
      <Icon name="error" size={22} fill className={styles.icon} />
      <div>
        <p className={styles.title}>{title}</p>
        {message && <p className={styles.message}>{message}</p>}
      </div>
    </div>
  );
}
