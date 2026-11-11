import { createContext, useContext } from 'react';
import type { ErroLogin, Sessao } from '../types';

export interface AuthContextValue {
  sessao: Sessao;
  // Erro detectado ao validar a sessão (conta sem permissão, falha de rede).
  erroSessao: ErroLogin | null;
  entrar: (email: string, senha: string) => Promise<void>;
  sair: () => Promise<void>;
}

export const AuthContext = createContext<AuthContextValue | null>(null);

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth precisa estar dentro de <AuthProvider>.');
  return ctx;
}
