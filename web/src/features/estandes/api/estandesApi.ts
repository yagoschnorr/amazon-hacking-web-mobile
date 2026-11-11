import {
  collection,
  doc,
  onSnapshot,
  runTransaction,
  serverTimestamp,
  updateDoc,
  type QueryDocumentSnapshot,
} from 'firebase/firestore';
import { db } from '@/shared/lib/firebase';
import type { DadosEstande, Estande } from '../types';

const ESTANDES = 'estandes';

// Código próprio para "documento com esse ID já existe".
export const CODIGO_EM_USO = 'codigo-em-uso';

function paraEstande(snap: QueryDocumentSnapshot): Estande {
  const dados = snap.data();
  return {
    id: snap.id,
    nome: String(dados.nome ?? ''),
    descricao: String(dados.descricao ?? ''),
    localizacao: String(dados.localizacao ?? ''),
    ativo: dados.ativo === true,
  };
}

function limpar(dados: DadosEstande): DadosEstande {
  return {
    nome: dados.nome.trim(),
    descricao: dados.descricao.trim(),
    localizacao: dados.localizacao.trim(),
    ativo: dados.ativo,
  };
}

export function observarEstandes(
  onDados: (estandes: Estande[]) => void,
  onErro: (erro: Error) => void,
): () => void {
  return onSnapshot(
    collection(db, ESTANDES),
    (snap) => onDados(snap.docs.map(paraEstande)),
    onErro,
  );
}

// A transação garante que o código não é reaproveitado, mesmo com dois admins ao mesmo tempo.
export async function criarEstande(codigo: string, dados: DadosEstande): Promise<void> {
  const ref = doc(db, ESTANDES, codigo);
  await runTransaction(db, async (tx) => {
    const existente = await tx.get(ref);
    if (existente.exists()) {
      throw Object.assign(new Error(`Código ${codigo} já em uso.`), { code: CODIGO_EM_USO });
    }
    tx.set(ref, {
      ...limpar(dados),
      criadoEm: serverTimestamp(),
      atualizadoEm: serverTimestamp(),
    });
  });
}

export function atualizarEstande(id: string, dados: DadosEstande): Promise<void> {
  return updateDoc(doc(db, ESTANDES, id), { ...limpar(dados), atualizadoEm: serverTimestamp() });
}

export function definirAtivo(id: string, ativo: boolean): Promise<void> {
  return updateDoc(doc(db, ESTANDES, id), { ativo, atualizadoEm: serverTimestamp() });
}
