import { Navigate, useLocation } from 'react-router';
import { LoginForm } from '../components/LoginForm';
import { useAuth } from '../hooks/useAuth';

export function LoginPage() {
  const { sessao } = useAuth();
  const location = useLocation();

  if (sessao.status === 'admin') {
    const destino = (location.state as { de?: string } | null)?.de ?? '/estandes';
    return <Navigate to={destino} replace />;
  }

  return (
    <main>
      <LoginForm />
    </main>
  );
}
