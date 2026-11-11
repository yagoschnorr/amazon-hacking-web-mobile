import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
// Inicializa o Firebase logo na abertura: configuração ausente falha aqui, com mensagem clara.
import '@/shared/lib/firebase';
import { App } from '@/app/App';
import '@/shared/styles/global.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
