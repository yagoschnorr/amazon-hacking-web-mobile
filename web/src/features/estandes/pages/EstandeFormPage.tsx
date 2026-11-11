import { Link, Navigate, useNavigate, useParams } from 'react-router';
import { Alert, Icon, PageHeader } from '@/shared/components';
import { atualizarEstande, criarEstande } from '../api/estandesApi';
import { EstandeForm } from '../components/EstandeForm';
import { useEstandes } from '../hooks/useEstandes';
import type { DadosEstande, ValoresEstande } from '../types';
import styles from './EstandeFormPage.module.css';

function dados({ nome, descricao, localizacao, ativo }: ValoresEstande): DadosEstande {
  return { nome, descricao, localizacao, ativo };
}

// Atende /estandes/novo e /estandes/:id/editar.
export function EstandeFormPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { estado } = useEstandes();

  if (estado.status === 'carregando') return null;

  const estandes = estado.status === 'pronto' ? estado.estandes : [];
  const estande = id ? estandes.find((e) => e.id === id) : undefined;

  if (id && estado.status === 'pronto' && !estande) return <Navigate to="/estandes" replace />;

  const voltar = () => navigate('/estandes');

  return (
    <div className={styles.page}>
      <Link to="/estandes" className={styles.voltar}>
        <Icon name="arrow_back" size={20} />
        Voltar para estandes
      </Link>

      {id ? (
        <PageHeader
          overline={`Estande ${id}`}
          title="Editar estande"
          subtitle="As alterações aparecem no app assim que forem salvas."
        />
      ) : (
        <PageHeader
          title="Novo estande"
          subtitle="O estande fica visível no app assim que for ativado."
        />
      )}

      {id && !estande ? (
        <div className={styles.formulario}>
          <Alert
            title="Não foi possível carregar o estande."
            message="Verifique a conexão e recarregue a página."
          />
        </div>
      ) : (
        <div className={styles.grade}>
          <div className={styles.formulario}>
            <EstandeForm
              key={id ?? 'novo'}
              inicial={estande}
              codigosExistentes={estandes.map((e) => e.id)}
              onCancelar={voltar}
              onSalvar={async (valores) => {
                if (estande) await atualizarEstande(estande.id, dados(valores));
                else await criarEstande(valores.codigo, dados(valores));
                voltar();
              }}
            />
          </div>

          {!id && (
            <aside className={styles.lateral}>
              <span className={styles.lateralIcone}>
                <Icon name="qr_code_2" size={24} />
              </span>
              <h2 className={styles.lateralTitulo}>O QR code sai do código</h2>
              <p>
                Ao salvar, o painel gera o QR code a partir do código do estande. Por isso o código
                não pode ser alterado depois do cadastro.
              </p>
              <p>Use a letra E seguida de 2 algarismos, sem repetir códigos.</p>
            </aside>
          )}
        </div>
      )}
    </div>
  );
}
