import { useEffect, useState } from 'react';
import { ButtonLink, PageHeader, Toast } from '@/shared/components';
import { definirAtivo } from '../api/estandesApi';
import { EstandeTable } from '../components/EstandeTable';
import { useEstandes } from '../hooks/useEstandes';
import type { Estande } from '../types';
import { resumoEstandes } from '../utils/estande';
import styles from './EstandesPage.module.css';

const AVISO_DURACAO_MS = 6000;

export function EstandesPage() {
  const { estado, tentarDeNovo } = useEstandes();
  const [alterando, setAlterando] = useState<ReadonlySet<string>>(new Set());
  const [aviso, setAviso] = useState<string | null>(null);

  useEffect(() => {
    if (!aviso) return;
    const timer = setTimeout(() => setAviso(null), AVISO_DURACAO_MS);
    return () => clearTimeout(timer);
  }, [aviso]);

  async function alternarAtivo(estande: Estande) {
    setAlterando((atual) => new Set(atual).add(estande.id));
    try {
      await definirAtivo(estande.id, !estande.ativo);
    } catch {
      setAviso(`Não foi possível ${estande.ativo ? 'inativar' : 'ativar'} ${estande.nome}.`);
    } finally {
      setAlterando((atual) => {
        const proximo = new Set(atual);
        proximo.delete(estande.id);
        return proximo;
      });
    }
  }

  const estandes = estado.status === 'pronto' ? estado.estandes : [];
  const subtitulo =
    estado.status === 'pronto'
      ? resumoEstandes(estandes.length, estandes.filter((e) => e.ativo).length)
      : undefined;

  return (
    <div className={styles.page}>
      <PageHeader
        title="Estandes"
        subtitle={subtitulo}
        actions={
          estandes.length > 0 ? (
            <ButtonLink to="/estandes/novo" icon="add">
              Novo estande
            </ButtonLink>
          ) : undefined
        }
      />

      <section className={styles.secao} aria-labelledby="titulo-estandes-cadastrados">
        <div className={styles.secaoCabecalho}>
          <h2 id="titulo-estandes-cadastrados" className={styles.secaoTitulo}>
            Estandes cadastrados
          </h2>
        </div>
        <EstandeTable
          estado={estado}
          alterando={alterando}
          onAlternarAtivo={(estande) => void alternarAtivo(estande)}
          onTentarDeNovo={tentarDeNovo}
        />
      </section>

      {aviso && (
        <Toast
          tone="error"
          title={aviso}
          message="Verifique a conexão e tente de novo."
          onClose={() => setAviso(null)}
        />
      )}
    </div>
  );
}
