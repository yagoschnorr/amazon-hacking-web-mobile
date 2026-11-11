import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

// Valores do app Web registrado no console (Configurações do projeto → Seus apps).
// Ficam em web/.env.local, fora do git. Modelo em web/.env.example.
const env = {
  VITE_FIREBASE_API_KEY: import.meta.env.VITE_FIREBASE_API_KEY,
  VITE_FIREBASE_AUTH_DOMAIN: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  VITE_FIREBASE_PROJECT_ID: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  VITE_FIREBASE_APP_ID: import.meta.env.VITE_FIREBASE_APP_ID,
};

const ausentes = Object.entries(env)
  .filter(([, valor]) => !valor?.trim())
  .map(([nome]) => nome);

if (ausentes.length > 0) {
  throw new Error(
    `Configuração do Firebase incompleta. Variáveis ausentes: ${ausentes.join(', ')}. ` +
      'Copie web/.env.example para web/.env.local, preencha com os valores do app Web ' +
      'no console do Firebase e reinicie o npm run dev.',
  );
}

const app = initializeApp({
  apiKey: env.VITE_FIREBASE_API_KEY,
  authDomain: env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: env.VITE_FIREBASE_PROJECT_ID,
  appId: env.VITE_FIREBASE_APP_ID,
});

export const auth = getAuth(app);
export const db = getFirestore(app);
