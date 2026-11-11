import { Outlet } from 'react-router';
import { useAuth } from '@/features/auth';
import { AppShell } from '@/shared/components';

// Moldura das telas do painel (lista e formulários). A tela de QR fica fora dela.
export function PainelLayout() {
  const { sessao, sair } = useAuth();
  const email = sessao.status === 'admin' ? sessao.admin.email : null;

  return (
    <AppShell email={email} onSair={() => void sair()}>
      <Outlet />
    </AppShell>
  );
}
