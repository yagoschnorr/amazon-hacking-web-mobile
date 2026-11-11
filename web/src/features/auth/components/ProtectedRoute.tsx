import { Navigate, Outlet, useLocation } from 'react-router';
import { useAuth } from '../hooks/useAuth';

export function ProtectedRoute() {
  const { sessao } = useAuth();
  const location = useLocation();

  // Enquanto a sessão é restaurada e o admin é checado, não exibe nada.
  if (sessao.status === 'carregando') return null;

  if (sessao.status !== 'admin') {
    return <Navigate to="/login" replace state={{ de: location.pathname }} />;
  }

  return <Outlet />;
}
