# CLAUDE.md — Circuito de Descobertas

Monorepo com o painel web da organização (`web/`, React + TypeScript + Vite) e o app Android do visitante (`mobile/`, Flutter), ligados por um único projeto Firebase.

O plano completo está em [`docs/plano-de-implementacao.md`](docs/plano-de-implementacao.md). Leia a etapa pedida (P1…D3) e a seção 2 do plano antes de começar. O contrato de dados (seção 5) e o design (`docs/design/`) são a fonte de verdade.

## Regras de trabalho

Estas regras têm prioridade sobre qualquer conveniência de implementação.

1. **Sem commits.** Não executar `git add`, `git commit`, `git push`, `git tag`, nem criar ou trocar de branch. Todos os commits são feitos por Yago.
2. **Uma etapa por vez.** Ao terminar, parar e entregar: arquivos criados ou alterados, como testar, resultado do critério de aceite e a mensagem de commit sugerida. Só seguir depois da confirmação de Yago.
3. **Somente plano Spark.** Nada de Cloud Functions, Cloud Storage, extensões ou recursos do plano Blaze. Serviços permitidos: Authentication, Firestore, Remote Config, Analytics, App Distribution e, opcionalmente, Hosting.
4. **Sem segredos no repositório.** Nunca versionar keystore (`*.jks`, `*.keystore`), `key.properties` ou `.env.local`. Versionar apenas `.env.example`.
5. **Contrato fixo.** Coleções, campos, parâmetros do Remote Config e eventos do Analytics seguem a seção 5 do plano (e `docs/contrato-de-dados.md`, quando existir). Não renomear sem pedir.
6. **Escopo da lauda.** Código direto, sem camadas genéricas, sem bibliotecas além das listadas na seção 3, sem funcionalidades extras.
7. **Design.** Seguir `docs/design/` (`tokens.md` e as telas em `web/` e `mobile/`). Não inventar cores, fontes ou layouts. Tela ou estado ausente no design: perguntar antes de criar.
8. **Ações na conta de Yago.** `firebase login`, `flutterfire configure`, deploys e qualquer ação no console do Firebase são feitos por Yago. Preparar os arquivos e informar o comando exato.
9. **Versões.** Instalar dependências pela ferramenta (`npm install`, `flutter pub add`). Não fixar números de versão de memória.
10. **Dados fictícios.** Nenhum nome, e-mail ou dado real de visitante em código, seeds ou eventos.

## Arquitetura (resumo)

- **Web:** feature-based (`auth`, `estandes`, `qrcode`, `checkins`, `missao`) + `shared/`. Uma feature só importa de `shared/` e do `index.ts` público de outra feature.
- **Mobile:** feature-first (`auth`, `estandes`, `checkin`, `missao`) + `app/` e `core/`. Somente Android.
- **Estilo:** tokens do design viram `web/src/shared/styles/tokens.css` e o tema em `mobile/lib/app/theme/`. Nenhuma cor ou tamanho solto nos componentes.

## Mensagens de commit sugeridas

Conventional Commits: `tipo(escopo): descrição`, em português, no imperativo e em minúsculas.

- Tipos: `feat`, `fix`, `chore`, `docs`, `style`, `refactor`, `test`, `build`
- Escopos: `web`, `mobile`, `firebase`, `docs`, `repo`

Se uma etapa for dividida em mais de um commit, sugerir uma mensagem para cada parte, na ordem.
