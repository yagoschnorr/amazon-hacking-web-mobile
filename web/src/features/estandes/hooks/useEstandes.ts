import { useCallback, useEffect, useState } from 'react';
import { observarEstandes } from '../api/estandesApi';
import type { EstadoLista } from '../types';
import { ordenarPorCodigo } from '../utils/estande';

// Lista de estandes em tempo real, ordenada por código no cliente.
export function useEstandes() {
  const [estado, setEstado] = useState<EstadoLista>({ status: 'carregando' });
  const [tentativa, setTentativa] = useState(0);

  useEffect(
    () =>
      observarEstandes(
        (estandes) => setEstado({ status: 'pronto', estandes: ordenarPorCodigo(estandes) }),
        () => setEstado({ status: 'erro' }),
      ),
    [tentativa],
  );

  const tentarDeNovo = useCallback(() => {
    setEstado({ status: 'carregando' });
    setTentativa((t) => t + 1);
  }, []);

  return { estado, tentarDeNovo };
}
