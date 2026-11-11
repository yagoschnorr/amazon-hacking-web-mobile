// Documento de estandes/{id} (contrato de dados). O id é o código curto, por exemplo E03.
export interface Estande {
  id: string;
  nome: string;
  descricao: string;
  localizacao: string;
  ativo: boolean;
}

export type DadosEstande = Omit<Estande, 'id'>;

export interface ValoresEstande extends DadosEstande {
  codigo: string;
}

export type CampoEstande = 'codigo' | 'nome' | 'descricao' | 'localizacao';

export type ErrosEstande = Partial<Record<CampoEstande, string>>;

export type EstadoLista =
  { status: 'carregando' } | { status: 'erro' } | { status: 'pronto'; estandes: Estande[] };
