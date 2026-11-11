import { collection, onSnapshot } from 'firebase/firestore';
import { db } from '@/shared/lib/firebase';

// O painel só precisa do estandeId de cada check-in para calcular os totais.
export function observarCheckins(
  onDados: (checkins: { estandeId?: unknown }[]) => void,
  onErro: (erro: Error) => void,
): () => void {
  return onSnapshot(
    collection(db, 'checkins'),
    (snap) => onDados(snap.docs.map((d) => ({ estandeId: d.get('estandeId') }))),
    onErro,
  );
}
