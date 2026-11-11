import type { ReactNode } from 'react';

// Ponto único dos providers globais. O AuthProvider entra na etapa W3.
export function Providers({ children }: { children: ReactNode }) {
  return children;
}
