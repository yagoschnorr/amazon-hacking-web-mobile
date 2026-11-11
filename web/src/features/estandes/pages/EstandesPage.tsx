import { LogoutButton, useAuth } from '@/features/auth';

export function EstandesPage() {
  const { sessao } = useAuth();

  return (
    <main>
      {/* Provisório: e-mail e Sair passam para o AppShell na etapa W4. */}
      <header>
        <span>{sessao.status === 'admin' ? sessao.admin.email : null}</span> <LogoutButton />
      </header>
      <h1>Estandes</h1>
    </main>
  );
}
