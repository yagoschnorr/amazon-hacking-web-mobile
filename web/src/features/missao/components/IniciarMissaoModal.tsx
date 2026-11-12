import { useEffect, useId, useState, type FormEvent } from 'react';
import { Alert, Button, Icon, IconButton, Input, Modal } from '@/shared/components';
import { ErroPublicacao, prepararPublicacao, publicarMissao } from '../api/remoteConfigApi';
import { textoSelecao } from '../utils/jsonMissao';
import {
  paraCampoLocal,
  validarMissao,
  valoresMissao,
  type ErrosMissao,
} from '../utils/publicacaoMissao';
import styles from './IniciarMissaoModal.module.css';

const COPIADO_MS = 2000;

export interface EstandeMissao {
  id: string;
  nome: string;
}

interface IniciarMissaoModalProps {
  // Estandes ativos, na ordem da tabela.
  estandes: EstandeMissao[];
  // Seleção feita na tabela; o modal abre com ela.
  selecionadosIniciais: string[];
  onFechar: () => void;
  onPublicada: () => void;
}

// Monta a missão e publica os quatro parâmetros no Remote Config. Os valores
// ficam à vista com botão de copiar, para publicar pelo console se preferir.
export function IniciarMissaoModal({
  estandes,
  selecionadosIniciais,
  onFechar,
  onPublicada,
}: IniciarMissaoModalProps) {
  const formId = useId();
  const rotuloId = useId();
  const [selecionados, setSelecionados] = useState<ReadonlySet<string>>(
    () => new Set(selecionadosIniciais),
  );
  const [inicio, setInicio] = useState(() => paraCampoLocal(new Date()));
  const [duracao, setDuracao] = useState('30');
  const [semPrazo, setSemPrazo] = useState(false);
  const [erros, setErros] = useState<ErrosMissao>({});
  const [publicando, setPublicando] = useState(false);
  const [falha, setFalha] = useState<ErroPublicacao | null>(null);
  const [copiado, setCopiado] = useState<string | null>(null);

  useEffect(prepararPublicacao, []);

  useEffect(() => {
    if (!copiado) return;
    const timer = setTimeout(() => setCopiado(null), COPIADO_MS);
    return () => clearTimeout(timer);
  }, [copiado]);

  // Um estande inativado com o modal aberto sai da missão.
  const ids = estandes.filter((e) => selecionados.has(e.id)).map((e) => e.id);
  const dados = { ids, semPrazo, inicio, duracao };
  const valores = valoresMissao(dados);

  function alternar(id: string) {
    setSelecionados((atual) => {
      const proximo = new Set(atual);
      if (proximo.has(id)) proximo.delete(id);
      else proximo.add(id);
      return proximo;
    });
  }

  async function copiar(nome: string, valor: string) {
    try {
      await navigator.clipboard.writeText(valor);
      setCopiado(nome);
    } catch {
      // Sem permissão de área de transferência: o valor continua à vista.
    }
  }

  async function publicar(evento: FormEvent) {
    evento.preventDefault();
    const novosErros = validarMissao(dados, new Date());
    setErros(novosErros);
    if (Object.keys(novosErros).length > 0) return;

    setPublicando(true);
    setFalha(null);
    try {
      await publicarMissao(valores);
      onPublicada();
    } catch (erro) {
      setFalha(
        erro instanceof ErroPublicacao
          ? erro
          : new ErroPublicacao('Não foi possível publicar a missão.', 'Tente de novo.'),
      );
      setPublicando(false);
    }
  }

  return (
    <Modal
      open
      onClose={onFechar}
      tone="missao"
      icon="bolt"
      title="Iniciar missão"
      actions={
        <>
          <Button variant="secondary" onClick={onFechar}>
            Cancelar
          </Button>
          <Button type="submit" form={formId} variant="missao" icon="bolt" disabled={publicando}>
            {publicando ? 'Publicando…' : 'Publicar missão'}
          </Button>
        </>
      }
    >
      <form id={formId} className={styles.form} onSubmit={(e) => void publicar(e)} noValidate>
        <div role="group" aria-labelledby={rotuloId} className={styles.grupo}>
          <div className={styles.cabecalho}>
            <span id={rotuloId} className={styles.rotulo}>
              Estandes da missão
            </span>
            <span className={styles.contagem} aria-live="polite">
              {textoSelecao(ids.length)}
            </span>
          </div>
          <ul className={styles.lista}>
            {estandes.map((estande) => (
              <li key={estande.id}>
                <label
                  className={[styles.opcao, selecionados.has(estande.id) && styles.selecionado]
                    .filter(Boolean)
                    .join(' ')}
                >
                  <input
                    type="checkbox"
                    className={styles.caixa}
                    checked={selecionados.has(estande.id)}
                    onChange={() => alternar(estande.id)}
                  />
                  <span className={styles.codigo}>{estande.id}</span>
                  <span className={styles.nome}>{estande.nome}</span>
                </label>
              </li>
            ))}
          </ul>
          {erros.estandes && <MensagemErro texto={erros.estandes} />}
        </div>

        <div className={styles.grupo}>
          <div className={styles.campos}>
            <Input
              label="Início"
              type="datetime-local"
              icon="schedule"
              value={inicio}
              disabled={semPrazo}
              error={semPrazo ? undefined : erros.inicio}
              onChange={(e) => setInicio(e.target.value)}
            />
            <Input
              label="Duração"
              type="number"
              inputMode="numeric"
              min={1}
              step={1}
              hint="Em minutos"
              value={duracao}
              disabled={semPrazo}
              error={semPrazo ? undefined : erros.duracao}
              onChange={(e) => setDuracao(e.target.value)}
            />
          </div>
          <label className={styles.semPrazo}>
            <input
              type="checkbox"
              className={styles.caixa}
              checked={semPrazo}
              onChange={(e) => setSemPrazo(e.target.checked)}
            />
            Sem prazo (a missão vale até ser desligada no console)
          </label>
        </div>

        <div className={styles.valores}>
          <p className={styles.valoresTitulo}>
            Valores publicados no Remote Config. Se preferir, copie e publique no console.
          </p>
          <dl className={styles.tabela}>
            {valores.map(({ nome, valor }) => (
              <div key={nome} className={styles.linha}>
                <dt className={styles.parametro}>{nome}</dt>
                <dd className={styles.valor}>{valor === '' ? '(vazio)' : valor}</dd>
                <dd>
                  <IconButton
                    icon={copiado === nome ? 'check' : 'content_copy'}
                    label={copiado === nome ? `${nome} copiado` : `Copiar ${nome}`}
                    onClick={() => void copiar(nome, valor)}
                  />
                </dd>
              </div>
            ))}
          </dl>
        </div>

        {falha && <Alert title={falha.message} message={falha.detalhe} />}
      </form>
    </Modal>
  );
}

function MensagemErro({ texto }: { texto: string }) {
  return (
    <p className={styles.erro}>
      <Icon name="error" size={16} fill />
      {texto}
    </p>
  );
}
