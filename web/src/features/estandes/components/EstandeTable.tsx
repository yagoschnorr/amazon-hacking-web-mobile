import type { ReactNode } from 'react';
import type { TotaisPorEstande } from '@/features/checkins';
import { Badge, Button, ButtonLink, Icon, IconLink, type IconName } from '@/shared/components';
import type { Estande, EstadoLista } from '../types';
import styles from './EstandeTable.module.css';

interface EstandeTableProps {
  estado: EstadoLista;
  alterando: ReadonlySet<string>;
  // null enquanto os check-ins carregam ou se a leitura falhar.
  totais: TotaisPorEstande | null;
  // Estandes cujo total acabou de mudar (destaque breve).
  destacados: ReadonlySet<string>;
  onAlternarAtivo: (estande: Estande) => void;
  onTentarDeNovo: () => void;
}

const COLUNAS = 6;

export function EstandeTable({
  estado,
  alterando,
  totais,
  destacados,
  onAlternarAtivo,
  onTentarDeNovo,
}: EstandeTableProps) {
  return (
    <div className={styles.wrapper}>
      <div className={styles.scroll}>
        <table className={styles.table}>
          <thead>
            <tr>
              <th scope="col">Código</th>
              <th scope="col">Estande</th>
              <th scope="col">Localização</th>
              <th scope="col">Status</th>
              <th scope="col" className={styles.alignEnd}>
                Check-ins
              </th>
              <th scope="col" className={styles.alignEnd}>
                Ações
              </th>
            </tr>
          </thead>
          <tbody>
            {estado.status === 'carregando' && (
              <EstadoTabela icone="storefront" titulo="Carregando estandes…" />
            )}

            {estado.status === 'erro' && (
              <EstadoTabela
                icone="wifi_off"
                tom="erro"
                titulo="Não foi possível carregar os estandes."
                texto="Verifique a conexão e tente de novo."
                acao={
                  <Button variant="secondary" icon="refresh" onClick={onTentarDeNovo}>
                    Tentar de novo
                  </Button>
                }
              />
            )}

            {estado.status === 'pronto' && estado.estandes.length === 0 && (
              <EstadoTabela
                icone="storefront"
                titulo="Nenhum estande cadastrado."
                texto="Cadastre o primeiro estande para gerar o QR code dele e liberar os check-ins no app."
                acao={
                  <ButtonLink to="/estandes/novo" icon="add">
                    Novo estande
                  </ButtonLink>
                }
              />
            )}

            {estado.status === 'pronto' &&
              estado.estandes.map((estande) => (
                <tr
                  key={estande.id}
                  className={destacados.has(estande.id) ? styles.destacado : undefined}
                >
                  <td className={styles.codigo}>{estande.id}</td>
                  <td>
                    <span className={styles.nome}>{estande.nome}</span>
                    <span className={styles.sub}>{estande.descricao}</span>
                  </td>
                  <td>{estande.localizacao}</td>
                  <td>
                    <Badge status={estande.ativo ? 'ativo' : 'inativo'} />
                  </td>
                  <td className={styles.numero}>
                    {totais ? (totais[estande.id] ?? 0).toLocaleString('pt-BR') : '–'}
                  </td>
                  <td>
                    <div className={styles.acoes}>
                      <IconLink
                        to={`/estandes/${estande.id}/editar`}
                        icon="edit"
                        label={`Editar ${estande.nome}`}
                      />
                      <IconLink
                        to={`/estandes/${estande.id}/qr`}
                        target="_blank"
                        rel="noopener"
                        icon="qr_code_2"
                        label={`QR code de ${estande.nome} (abre em nova aba)`}
                      />
                      <Button
                        variant="secondary"
                        size="sm"
                        icon={estande.ativo ? 'pause_circle' : 'play_circle'}
                        disabled={alterando.has(estande.id)}
                        aria-label={`${estande.ativo ? 'Inativar' : 'Ativar'} ${estande.nome}`}
                        onClick={() => onAlternarAtivo(estande)}
                      >
                        {estande.ativo ? 'Inativar' : 'Ativar'}
                      </Button>
                    </div>
                  </td>
                </tr>
              ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

interface EstadoTabelaProps {
  icone: IconName;
  tom?: 'neutro' | 'erro';
  titulo: string;
  texto?: string;
  acao?: ReactNode;
}

function EstadoTabela({ icone, tom = 'neutro', titulo, texto, acao }: EstadoTabelaProps) {
  return (
    <tr>
      <td colSpan={COLUNAS} className={styles.estadoCelula}>
        <div className={styles.estado} role={tom === 'erro' ? 'alert' : 'status'}>
          <span className={`${styles.estadoIcone} ${tom === 'erro' ? styles.estadoErro : ''}`}>
            <Icon name={icone} size={36} />
          </span>
          <p className={styles.estadoTitulo}>{titulo}</p>
          {texto && <p className={styles.estadoTexto}>{texto}</p>}
          {acao && <div className={styles.estadoAcao}>{acao}</div>}
        </div>
      </td>
    </tr>
  );
}
