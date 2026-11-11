export interface Admin {
  uid: string;
  email: string | null;
}

export type Sessao =
  { status: 'carregando' } | { status: 'deslogado' } | { status: 'admin'; admin: Admin };

export interface ErroLogin {
  titulo: string;
  detalhe: string;
}
