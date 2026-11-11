import { useEffect, useRef, useState } from 'react';
import { observarCheckins } from '../api/checkinsApi';
import {
  contarPorEstande,
  estandesAlterados,
  type TotaisPorEstande,
} from '../utils/contarPorEstande';

export type EstadoCheckins =
  | { status: 'carregando' }
  | { status: 'erro' }
  | { status: 'pronto'; porEstande: TotaisPorEstande; total: number };

const DESTAQUE_MS = 2400;

// Totais calculados dos documentos de checkins, em tempo real (sem campo contador no estande).
export function useCheckinTotals() {
  const [estado, setEstado] = useState<EstadoCheckins>({ status: 'carregando' });
  // Estandes cujo total acabou de mudar, para o destaque breve na tabela.
  const [destacados, setDestacados] = useState<ReadonlySet<string>>(new Set());
  const anterior = useRef<TotaisPorEstande | null>(null);
  const timers = useRef(new Map<string, ReturnType<typeof setTimeout>>());

  useEffect(() => {
    const ativos = timers.current;

    const parar = observarCheckins(
      (checkins) => {
        const porEstande = contarPorEstande(checkins);
        // A primeira leitura não destaca nada.
        const mudaram = anterior.current ? estandesAlterados(anterior.current, porEstande) : [];
        anterior.current = porEstande;
        setEstado({ status: 'pronto', porEstande, total: checkins.length });

        for (const id of mudaram) {
          setDestacados((atual) => new Set(atual).add(id));
          clearTimeout(ativos.get(id));
          ativos.set(
            id,
            setTimeout(() => {
              ativos.delete(id);
              setDestacados((atual) => {
                const proximo = new Set(atual);
                proximo.delete(id);
                return proximo;
              });
            }, DESTAQUE_MS),
          );
        }
      },
      () => setEstado({ status: 'erro' }),
    );

    return () => {
      parar();
      ativos.forEach(clearTimeout);
      ativos.clear();
    };
  }, []);

  return { estado, destacados };
}
