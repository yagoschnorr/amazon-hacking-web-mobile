import { Button } from '@/shared/components';
import { montarJsonMissao, textoSelecao } from '../utils/jsonMissao';
import styles from './CopiarIdsMissao.module.css';

interface CopiarIdsMissaoProps {
  // Códigos dos estandes ativos selecionados na tabela.
  ids: string[];
  // Quantos estandes ativos existem (sem nenhum, não há o que selecionar).
  totalAtivos: number;
  onCopiado: (json: string) => void;
  onFalha: (json: string) => void;
}

// O painel não publica no Remote Config: só copia o JSON para colar no console.
export function CopiarIdsMissao({ ids, totalAtivos, onCopiado, onFalha }: CopiarIdsMissaoProps) {
  async function copiar() {
    const json = montarJsonMissao(ids);
    try {
      await navigator.clipboard.writeText(json);
      onCopiado(json);
    } catch {
      onFalha(json);
    }
  }

  const legenda =
    totalAtivos === 0 ? 'Cadastre estandes para montar a missão.' : textoSelecao(ids.length);

  return (
    <div className={styles.copiar}>
      <span className={styles.legenda} aria-live="polite">
        {legenda}
      </span>
      <Button
        variant="secondary"
        icon="content_copy"
        disabled={ids.length === 0}
        onClick={() => void copiar()}
      >
        Copiar IDs da missão
      </Button>
    </div>
  );
}
