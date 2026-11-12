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
├── firebase.json             # regras do Firestore e Hosting
├── .firebaserc               # id do projeto Firebase
├── firestore.rules           # regras de segurança
├── firestore.indexes.json
├── docs/
│   ├── lauda.pdf             # enunciado da atividade
│   ├── plano-de-implementacao.md
│   ├── contrato-de-dados.md  # coleções, Remote Config e eventos do Analytics
│   ├── guia-firebase.md      # passos manuais no console e APK de release
│   ├── roteiro-video.md      # roteiro da demonstração em vídeo
│   └── design/               # tokens e telas de referência
├── web/                      # painel da organização (React + TypeScript)
└── mobile/                   # app do visitante (Flutter, Android)
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

Dentro de `mobile/`, com um aparelho Android conectado por USB (com a depuração USB ligada) ou um emulador aberto:

```bash
cd mobile
flutter pub get
flutter run
```

O app já está ligado ao projeto Firebase: `lib/firebase_options.dart` e `android/app/google-services.json` estão versionados (contêm identificadores, não segredos). O `flutterfire configure` só precisa ser rodado de novo para trocar de projeto.

A leitura do QR code usa a câmera traseira. Num emulador, configure a câmera traseira como webcam (Device Manager → Advanced Settings → Camera → Back: Webcam0). Num aparelho físico, não há nada a configurar.

| Comando | O que faz |
| --- | --- |
| `flutter run` | Roda o app em modo debug no aparelho ou emulador |
| `flutter analyze` | Análise estática |
| `flutter test` | Testes de unidade e de widget |
| `flutter build apk --release` | APK de release assinado em `build/app/outputs/flutter-apk/app-release.apk` |

O build de release exige a chave de upload: a keystore e o `android/key.properties` ficam fora do git, e sem eles o build falha de propósito. Passo a passo da chave, da conferência da assinatura e da instalação em [docs/guia-firebase.md](docs/guia-firebase.md#4-apk-de-release-assinado-etapa-m10). A versão vem de `version` no `pubspec.yaml`; aumente o número depois do `+` a cada APK distribuído.

O visitante entra com sessão anônima, sem cadastro. A missão surpresa é controlada pelos parâmetros `missao_ativa`, `missao_estandes_ids`, `missao_inicio` e `missao_duracao_min` do Remote Config ([contrato de dados](docs/contrato-de-dados.md)); o padrão local é a missão desligada.

#### Distribuir pelo Firebase App Distribution

1. Gerar o APK de release (acima) e conferir a assinatura.
2. No console do Firebase, em App Distribution, enviar o `app-release.apk`.
3. Em Testadores e grupos, adicionar o e-mail do testador e distribuir.
4. No Android do testador, abrir o convite por e-mail, aceitar, baixar e instalar.

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
- [Contrato de dados](docs/contrato-de-dados.md): coleções do Firestore, parâmetros do Remote Config e eventos do Analytics
- [Guia do Firebase](docs/guia-firebase.md): passos no console, regras e APK de release
- [Roteiro do vídeo](docs/roteiro-video.md)
- [Tokens e componentes do design](docs/design/tokens.md)

## Licença

[MIT](LICENSE)
