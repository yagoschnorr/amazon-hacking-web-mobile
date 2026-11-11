import type { ReactNode } from 'react';
import logoUrl from '@/shared/assets/logo-amazon-hacking.svg';
import styles from './AppShell.module.css';
import { Button } from './Button';
import { Icon } from './Icon';

interface AppShellProps {
  email: string | null;
  onSair: () => void;
  children: ReactNode;
}

export function AppShell({ email, onSair, children }: AppShellProps) {
  return (
    <div className={styles.shell}>
      <header className={styles.bar}>
        <div className={styles.barInner}>
          <div className={styles.brand}>
            <img src={logoUrl} alt="Amazon Hacking" className={styles.logo} />
            <span className={styles.divider} aria-hidden="true" />
            <span className={styles.name}>Circuito de Descobertas</span>
          </div>

          <div className={styles.account}>
            {email && (
              <span className={styles.email}>
                <Icon name="account_circle" size={20} />
                {email}
              </span>
            )}
            <Button variant="secondary" size="sm" icon="logout" onClick={onSair}>
              Sair
            </Button>
          </div>
        </div>
      </header>

      <main className={styles.content}>{children}</main>
    </div>
  );
}
