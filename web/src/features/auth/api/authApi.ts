import { onAuthStateChanged, signInWithEmailAndPassword, signOut, type User } from 'firebase/auth';
import { doc, getDoc } from 'firebase/firestore';
import { auth, db } from '@/shared/lib/firebase';

export async function entrar(email: string, senha: string): Promise<void> {
  await signInWithEmailAndPassword(auth, email.trim(), senha);
}

export function sair(): Promise<void> {
  return signOut(auth);
}

// Admin é quem tem documento em admins/{uid} (contrato de dados).
export async function ehAdmin(uid: string): Promise<boolean> {
  const snap = await getDoc(doc(db, 'admins', uid));
  return snap.exists();
}

export function observarSessao(callback: (usuario: User | null) => void): () => void {
  return onAuthStateChanged(auth, callback);
}
