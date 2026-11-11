import { useAuth } from '../hooks/useAuth';

export function LogoutButton() {
  const { sair } = useAuth();

  return (
    <button type="button" onClick={() => void sair()}>
      Sair
    </button>
  );
}
