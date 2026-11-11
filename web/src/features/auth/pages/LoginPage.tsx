import { Navigate, useLocation } from 'react-router';
import logoUrl from '@/shared/assets/logo-amazon-hacking.svg';
import { LoginForm } from '../components/LoginForm';
import { useAuth } from '../hooks/useAuth';
import styles from './LoginPage.module.css';

export function LoginPage() {
  const { sessao } = useAuth();
  const location = useLocation();

  if (sessao.status === 'admin') {
    const destino = (location.state as { de?: string } | null)?.de ?? '/estandes';
    return <Navigate to={destino} replace />;
  }

  return (
    <div className={styles.page}>
      <title>Entrar · Circuito de Descobertas</title>
      <aside className={styles.aside}>
        <img src={logoUrl} alt="Amazon Hacking" className={styles.logo} />

        <div className={styles.intro}>
          <span className={styles.accent} aria-hidden="true" />
          <p className={styles.overline}>Painel da organização</p>
          <p className={styles.display}>Circuito de Descobertas</p>
          <p className={styles.lead}>
            Cadastre os estandes, gere os QR codes e acompanhe os check-ins dos visitantes durante o
            evento.
          </p>
        </div>

        <p className={styles.footer}>Amazon Hacking · CESUPA, Belém</p>
      </aside>

      <main className={styles.main}>
        <LoginForm />
      </main>
    </div>
  );
}
