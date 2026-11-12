import { useEffect, useState } from 'react';
import { useCheckinTotals } from '@/features/checkins';
import { CopiarIdsMissao, IniciarMissaoModal } from '@/features/missao';
import { Button, ButtonLink, PageHeader, Toast } from '@/shared/components';
import { definirAtivo } from '../api/estandesApi';
import { EstandeTable } from '../components/EstandeTable';
import { TotalCheckinsCard } from '../components/TotalCheckinsCard';
import { useEstandes } from '../hooks/useEstandes';
import type { Estande } from '../types';
import { resumoEstandes } from '../utils/estande';
import styles from './EstandesPage.module.css';

const AVISO_DURACAO_MS = 6000;

interface Aviso {
  tone: 'success' | 'error' | 'missao';
  title: string;
  message: string;
}

export function EstandesPage() {
  const { estado, tentarDeNovo } = useEstandes();
  const { estado: checkins, destacados } = useCheckinTotals();
  const [alterando, setAlterando] = useState<ReadonlySet<string>>(new Set());
  const [aviso, setAviso] = useState<Aviso | null>(null);
  const [selecionados, setSelecionados] = useState<ReadonlySet<string>>(new Set());
  const [missaoAberta, setMissaoAberta] = useState(false);

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
      setAviso({
        tone: 'error',
        title: `Não foi possível ${estande.ativo ? 'inativar' : 'ativar'} ${estande.nome}.`,
        message: 'Verifique a conexão e tente de novo.',
      });
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

  // Só estandes ativos entram na missão; um estande inativado sai da seleção.
  const estandesAtivos = estandes.filter((e) => e.ativo);
  const ativos = estandesAtivos.map((e) => e.id);
  const idsMissao = ativos.filter((id) => selecionados.has(id));

  function alternarSelecao(id: string) {
    setSelecionados((atual) => {
      const proximo = new Set(atual);
      if (proximo.has(id)) proximo.delete(id);
      else proximo.add(id);
      return proximo;
    });
  }

  return (
    <div className={styles.page}>
      <title>Estandes · Circuito de Descobertas</title>
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

      <TotalCheckinsCard estado={checkins} />

      <section className={styles.secao} aria-labelledby="titulo-estandes-cadastrados">
        <div className={styles.secaoCabecalho}>
          <h2 id="titulo-estandes-cadastrados" className={styles.secaoTitulo}>
            Estandes cadastrados
          </h2>
          {estado.status === 'pronto' && (
            <div className={styles.acoesMissao}>
              <CopiarIdsMissao
                ids={idsMissao}
                totalAtivos={ativos.length}
                onCopiado={(json) =>
                  setAviso({
                    tone: 'success',
                    title: 'IDs copiados.',
                    message: `Cole ${json} no parâmetro missao_estandes_ids do Remote Config e publique no console do Firebase.`,
                  })
                }
                onFalha={(json) =>
                  setAviso({
                    tone: 'error',
                    title: 'Não foi possível copiar.',
                    message: `Copie manualmente ${json} para o parâmetro missao_estandes_ids do Remote Config.`,
                  })
                }
              />
              <Button
                variant="missao"
                icon="bolt"
                disabled={ativos.length === 0}
                onClick={() => setMissaoAberta(true)}
              >
                Iniciar missão
              </Button>
            </div>
          )}
        </div>
        <EstandeTable
          estado={estado}
          alterando={alterando}
          totais={checkins.status === 'pronto' ? checkins.porEstande : null}
          destacados={destacados}
          selecionados={selecionados}
          onAlternarSelecao={alternarSelecao}
          onSelecionarTodos={(marcar) => setSelecionados(new Set(marcar ? ativos : []))}
          onAlternarAtivo={(estande) => void alternarAtivo(estande)}
          onTentarDeNovo={tentarDeNovo}
        />
      </section>

      {missaoAberta && (
        <IniciarMissaoModal
          estandes={estandesAtivos}
          selecionadosIniciais={idsMissao}
          onFechar={() => setMissaoAberta(false)}
          onPublicada={() => {
            setMissaoAberta(false);
            setAviso({
              tone: 'missao',
              title: 'Missão publicada.',
              message:
                'O app aberto recebe a missão em segundos. Para encerrar, desligue missao_ativa no console do Firebase.',
            });
          }}
        />
      )}

      {aviso && (
        <Toast
          tone={aviso.tone}
          title={aviso.title}
          message={aviso.message}
          onClose={() => setAviso(null)}
        />
      )}
    </div>
  );
}
