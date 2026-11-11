import { useState, type FormEvent } from 'react';
import { Alert, Button, Input } from '@/shared/components';
import { mensagemErroLogin } from '../api/errosLogin';
import { useAuth } from '../hooks/useAuth';
import type { ErroLogin } from '../types';
import styles from './LoginForm.module.css';

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
    <section className={styles.card}>
      <header className={styles.header}>
        <h1 className={styles.title}>Entrar no painel</h1>
        <p className={styles.subtitle}>Use o e-mail e a senha da organização do evento.</p>
      </header>

      <form className={styles.form} onSubmit={enviar} aria-busy={ocupado}>
        {erro && <Alert title={erro.titulo} message={erro.detalhe} />}

        <Input
          label="E-mail"
          type="email"
          icon="mail"
          autoComplete="username"
          placeholder="nome@exemplo.com.br"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <Input
          label="Senha"
          type="password"
          icon="lock"
          autoComplete="current-password"
          required
          value={senha}
          onChange={(e) => setSenha(e.target.value)}
        />

        <Button type="submit" icon="login" disabled={ocupado} className={styles.submit}>
          Entrar
        </Button>
      </form>

      <p className={styles.note}>Esqueceu a senha? Fale com a coordenação do evento.</p>
    </section>
  );
}
