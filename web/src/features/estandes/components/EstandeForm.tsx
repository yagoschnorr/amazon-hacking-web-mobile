import { useState, type FormEvent } from 'react';
import { Alert, Button, Input, Switch, Textarea } from '@/shared/components';
import { CODIGO_EM_USO } from '../api/estandesApi';
import type { CampoEstande, ErrosEstande, Estande, ValoresEstande } from '../types';
import {
  CODIGO_MAX,
  DESCRICAO_MAX,
  mensagemCodigoEmUso,
  normalizarCodigo,
  validarEstande,
} from '../utils/estande';
import styles from './EstandeForm.module.css';

interface EstandeFormProps {
  // Sem estande inicial, o formulário cria; com ele, edita (código somente leitura).
  inicial?: Estande;
  codigosExistentes: string[];
  onSalvar: (valores: ValoresEstande) => Promise<void>;
  onCancelar: () => void;
}

const VAZIO: ValoresEstande = { codigo: '', nome: '', descricao: '', localizacao: '', ativo: true };

export function EstandeForm({
  inicial,
  codigosExistentes,
  onSalvar,
  onCancelar,
}: EstandeFormProps) {
  const criando = !inicial;
  const [valores, setValores] = useState<ValoresEstande>(() =>
    inicial
      ? {
          codigo: inicial.id,
          nome: inicial.nome,
          descricao: inicial.descricao,
          localizacao: inicial.localizacao,
          ativo: inicial.ativo,
        }
      : VAZIO,
  );
  const [erros, setErros] = useState<ErrosEstande>({});
  const [salvando, setSalvando] = useState(false);
  const [falhaAoSalvar, setFalhaAoSalvar] = useState(false);

  function alterar<K extends keyof ValoresEstande>(campo: K, valor: ValoresEstande[K]) {
    setValores((v) => ({ ...v, [campo]: valor }));
    setErros((e) => {
      const novos = { ...e };
      delete novos[campo as CampoEstande];
      return novos;
    });
  }

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault();
    const novosErros = validarEstande(valores, { criando, codigosExistentes });
    setErros(novosErros);
    setFalhaAoSalvar(false);
    if (Object.keys(novosErros).length > 0) return;

    setSalvando(true);
    try {
      await onSalvar(valores);
    } catch (erro) {
      if ((erro as { code?: string }).code === CODIGO_EM_USO) {
        setErros({ codigo: mensagemCodigoEmUso([...codigosExistentes, valores.codigo]) });
      } else {
        setFalhaAoSalvar(true);
      }
    } finally {
      setSalvando(false);
    }
  }

  return (
    <form className={styles.card} onSubmit={enviar} noValidate>
      {falhaAoSalvar && (
        <Alert
          title="Não foi possível salvar o estande."
          message="Verifique a conexão e tente de novo."
        />
      )}

      <div className={styles.linha}>
        {criando ? (
          <Input
            label="Código"
            placeholder="Ex.: E04"
            maxLength={CODIGO_MAX}
            autoCapitalize="characters"
            autoComplete="off"
            spellCheck={false}
            value={valores.codigo}
            error={erros.codigo}
            onChange={(e) => alterar('codigo', normalizarCodigo(e.target.value))}
          />
        ) : (
          <Input
            label="Código"
            icon="lock"
            value={valores.codigo}
            disabled
            hint="Não pode ser alterado."
          />
        )}

        <Input
          label="Nome"
          placeholder="Ex.: Castanha em Rede"
          value={valores.nome}
          error={erros.nome}
          hint="Aparece assim no app."
          onChange={(e) => alterar('nome', e.target.value)}
        />
      </div>

      <Textarea
        label="Descrição breve"
        placeholder="Ex.: Mapa colaborativo de pontos de coleta de castanha"
        maxLength={DESCRICAO_MAX}
        value={valores.descricao}
        error={erros.descricao}
        hint="Uma frase sobre o projeto. Aparece abaixo do nome."
        onChange={(e) => alterar('descricao', e.target.value)}
      />

      <Input
        label="Localização"
        icon="location_on"
        placeholder="Ex.: Corredor B, estande 4"
        value={valores.localizacao}
        error={erros.localizacao}
        hint="Corredor e número do estande, como na planta do evento."
        onChange={(e) => alterar('localizacao', e.target.value)}
      />

      <hr className={styles.divisoria} />

      <Switch
        label="Estande ativo"
        description="Aparece no app dos visitantes e aceita check-ins."
        checked={valores.ativo}
        onChange={(ativo) => alterar('ativo', ativo)}
      />

      <div className={styles.acoes}>
        <Button variant="secondary" onClick={onCancelar}>
          Cancelar
        </Button>
        <Button type="submit" icon="check" disabled={salvando}>
          {criando ? 'Salvar estande' : 'Salvar alterações'}
        </Button>
      </div>
    </form>
  );
}
