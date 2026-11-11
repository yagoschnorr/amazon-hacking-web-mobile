import { useState, type FormEvent } from 'react';
import { mensagemErroLogin } from '../api/errosLogin';
import { useAuth } from '../hooks/useAuth';
import type { ErroLogin } from '../types';

export function LoginForm() {
  const { sessao, erroSessao, entrar } = useAuth();
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [enviando, setEnviando] = useState(false);
  const [erroEnvio, setErroEnvio] = useState<ErroLogin | null>(null);

  const ocupado = enviando || sessao.status === 'carregando';
  const erro = erroEnvio ?? erroSessao;

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault();
    setErroEnvio(null);
    setEnviando(true);
    try {
      await entrar(email, senha);
    } catch (e) {
      setErroEnvio(mensagemErroLogin(e));
    } finally {
      setEnviando(false);
    }
  }

  return (
    <form onSubmit={enviar} aria-busy={ocupado}>
      <h1>Entrar no painel</h1>
      <p>Use o e-mail e a senha da organização do evento.</p>

      {erro && (
        <div role="alert">
          <strong>{erro.titulo}</strong>
          <p>{erro.detalhe}</p>
        </div>
      )}

      <label htmlFor="login-email">E-mail</label>
      <input
        id="login-email"
        type="email"
        autoComplete="username"
        placeholder="nome@exemplo.com.br"
        required
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />

      <label htmlFor="login-senha">Senha</label>
      <input
        id="login-senha"
        type="password"
        autoComplete="current-password"
        required
        value={senha}
        onChange={(e) => setSenha(e.target.value)}
      />

      <button type="submit" disabled={ocupado}>
        Entrar
      </button>

      <p>Esqueceu a senha? Fale com a coordenação do evento.</p>
    </form>
  );
}
