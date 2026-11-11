# Circuito de Descobertas

Sistema acadêmico inspirado no evento Amazon Hacking. A organização cadastra estandes e gera QR codes num painel web; os visitantes usam um app Android para fazer check-in nos estandes lendo o QR code, e uma missão surpresa pode ser ligada e desligada em tempo real pelo Firebase Remote Config.

Todos os dados usados são fictícios.

## Partes do sistema

| Pasta | O que é | Tecnologia |
| --- | --- | --- |
| `web/` | Painel da organização: login do administrador, cadastro de estandes, QR codes e total de check-ins | React + TypeScript (Vite), Firebase JS SDK |
| `mobile/` | App do visitante: lista de estandes, leitura de QR, check-in e missão surpresa | Flutter (somente Android) |

Os dois usam o mesmo projeto Firebase, no plano Spark: Authentication, Firestore, Remote Config, Google Analytics, App Distribution e, opcionalmente, Hosting.

## Estrutura do repositório

```text
.
├── CLAUDE.md                 # regras para o Claude Code
├── README.md
├── firebase.json             # regras do Firestore (etapa F1) e Hosting (etapa W9)
├── .firebaserc               # id do projeto Firebase (etapa F1)
├── firestore.rules           # regras de segurança (etapa F1)
├── firestore.indexes.json    # (etapa F1)
├── docs/
│   ├── lauda.pdf
│   ├── plano-de-implementacao.md
│   ├── contrato-de-dados.md  # (etapa F1)
│   ├── guia-firebase.md      # passos manuais no console (etapa F1)
│   ├── roteiro-video.md      # (etapa D3)
│   └── design/               # tokens e telas de referência
├── web/                      # painel (etapa W1 em diante)
└── mobile/                   # app Flutter (etapa M1 em diante)
```

## Pré-requisitos

- Git
- Node.js (versão LTS) e npm, para o painel web
- Flutter SDK (canal stable) e Android Studio com Android SDK, para o app
- Firebase CLI (`npm install -g firebase-tools`), para publicar regras e, se usado, o Hosting
- FlutterFire CLI (`dart pub global activate flutterfire_cli`), para ligar o app ao projeto Firebase
- Acesso ao projeto Firebase do Circuito de Descobertas

## Como rodar

### Painel web

Dentro de `web/`:

```bash
cd web
npm install
cp .env.example .env.local   # preencha com o app Web do console do Firebase
npm run dev                  # http://localhost:5173
```

O login só aceita contas de administrador: um usuário de e-mail e senha no Authentication e um documento `admins/{uid}` no Firestore. Os dois são criados à mão no console ([guia](docs/guia-firebase.md)).

| Comando | O que faz |
| --- | --- |
| `npm run dev` | Servidor de desenvolvimento |
| `npm run build` | Checagem de tipos e build de produção em `web/dist` |
| `npm run preview` | Serve o build de `web/dist` localmente |
| `npm run lint` | ESLint |
| `npm run format` | Prettier (`format:check` só confere) |
| `npm test` | Testes unitários (Vitest) |

#### Publicar no Firebase Hosting (opcional)

O `firebase.json` já aponta o Hosting para `web/dist`, com rewrite para o `index.html` (as rotas do painel funcionam ao recarregar a página). Na raiz do repositório, depois de `npm run build` em `web/`:

```bash
firebase deploy --only hosting
```

O painel fica em `https://<id-do-projeto>.web.app`. Esse domínio já vem autorizado no Authentication. Se o CLI avisar que não há site de Hosting, abra Hosting no console do Firebase e clique em "Começar" antes de repetir o comando.

### App mobile

<!-- Preenchido nas etapas M2 e M10. -->

_A definir._

### Regras do Firestore

Com o Firebase CLI instalado, `firebase login` feito e o ID do projeto no `.firebaserc`, na raiz do repositório:

```bash
firebase deploy --only firestore:rules
```

Passo a passo completo em [docs/guia-firebase.md](docs/guia-firebase.md). O contrato de dados está em [docs/contrato-de-dados.md](docs/contrato-de-dados.md).

## Segredos

Nunca versionar keystore (`*.jks`, `*.keystore`), `mobile/android/key.properties` ou `web/.env.local`. Apenas `web/.env.example` vai para o repositório.

## Documentação

- [Plano de implementação](docs/plano-de-implementacao.md)
- [Tokens e componentes do design](docs/design/tokens.md)

## Licença

[MIT](LICENSE)
