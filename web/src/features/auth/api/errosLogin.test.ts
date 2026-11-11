import { describe, expect, it } from 'vitest';
import { ACESSO_RESTRITO, mensagemErroLogin } from './errosLogin';

describe('mensagemErroLogin', () => {
  it('traduz credenciais inválidas', () => {
    expect(mensagemErroLogin({ code: 'auth/invalid-credential' }).titulo).toBe(
      'E-mail ou senha incorretos.',
    );
    expect(mensagemErroLogin({ code: 'auth/wrong-password' }).titulo).toBe(
      'E-mail ou senha incorretos.',
    );
  });

  it('traduz falha de rede do Auth e do Firestore', () => {
    expect(mensagemErroLogin({ code: 'auth/network-request-failed' }).titulo).toBe(
      'Sem conexão com o servidor.',
    );
    expect(mensagemErroLogin({ code: 'unavailable' }).titulo).toBe('Sem conexão com o servidor.');
  });

  it('traduz conta sem documento em admins', () => {
    expect(mensagemErroLogin({ code: ACESSO_RESTRITO }).titulo).toBe(
      'Acesso restrito à organização.',
    );
  });

  it('usa mensagem genérica para erro desconhecido ou sem código', () => {
    const generica = 'Não foi possível entrar.';
    expect(mensagemErroLogin({ code: 'auth/outro' }).titulo).toBe(generica);
    expect(mensagemErroLogin(new Error('x')).titulo).toBe(generica);
    expect(mensagemErroLogin(null).titulo).toBe(generica);
  });
});
