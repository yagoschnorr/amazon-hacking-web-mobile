import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react';
import * as authApi from '../api/authApi';
import { ACESSO_RESTRITO, mensagemErroLogin } from '../api/errosLogin';
import { AuthContext } from '../hooks/useAuth';
import type { ErroLogin, Sessao } from '../types';

export function AuthProvider({ children }: { children: ReactNode }) {
  const [sessao, setSessao] = useState<Sessao>({ status: 'carregando' });
  const [erroSessao, setErroSessao] = useState<ErroLogin | null>(null);

  useEffect(() => {
    let ativo = true;
    let ultimaChamada = 0;

    // Toda sessão (login novo ou restaurada ao recarregar) passa pela checagem de admin.
    const parar = authApi.observarSessao(async (usuario) => {
      const chamada = ++ultimaChamada;
      if (!usuario) {
        setSessao({ status: 'deslogado' });
        return;
      }

      setSessao({ status: 'carregando' });
      try {
        const admin = await authApi.ehAdmin(usuario.uid);
        if (!ativo || chamada !== ultimaChamada) return;
        if (admin) {
          setSessao({ status: 'admin', admin: { uid: usuario.uid, email: usuario.email } });
          return;
        }
        setErroSessao(mensagemErroLogin({ code: ACESSO_RESTRITO }));
      } catch (erro) {
        if (!ativo || chamada !== ultimaChamada) return;
        setErroSessao(mensagemErroLogin(erro));
      }
      // Sem permissão confirmada: encerra a sessão; o observador leva para "deslogado".
      await authApi.sair();
    });

    return () => {
      ativo = false;
      parar();
    };
  }, []);

  const entrar = useCallback(async (email: string, senha: string) => {
    setErroSessao(null);
    await authApi.entrar(email, senha);
  }, []);

  const sair = useCallback(() => authApi.sair(), []);

  const valor = useMemo(
    () => ({ sessao, erroSessao, entrar, sair }),
    [sessao, erroSessao, entrar, sair],
  );

  return <AuthContext.Provider value={valor}>{children}</AuthContext.Provider>;
}
