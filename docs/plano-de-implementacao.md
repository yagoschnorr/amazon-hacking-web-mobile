# Plano de Implementação — Circuito de Descobertas

Nov 11, 2026 · @Yago

## 1. Visão geral

O sistema tem duas partes obrigatórias, ligadas pelo Firebase: um painel web para a organização e um app Flutter (Android) para os visitantes. A ausência de qualquer uma das duas anula a atividade.

A nota vem de quatro evidências mostradas em vídeo. O código precisa existir e funcionar, mas o que pontua é a operação dos serviços.

| Critério | Valor | O que precisa aparecer no vídeo |
| --- | --- | --- |
| Firebase App Distribution | 1,0 | APK assinado entregue a um testador convidado, com acesso à versão, instalação e abertura do app |
| Firebase Remote Config | 1,0 | Missão ligada e desligada pelo console no mesmo app instalado, sem recompilar ou reinstalar |
| Google Analytics para Firebase | 1,0 | Eventos `missao_aberta` e `checkin_concluido` no relatório Tempo real do GA4, com o parâmetro `estande_id` visível |
| Demonstração integrada | 0,5 | Estande criado no painel aparece no app, o check-in atualiza o total no painel e o evento aparece no Analytics |

Restrições que valem para o projeto inteiro:

- Funcionar no plano Firebase Spark, sem cartão e sem serviços pagos.
- Usar apenas dados fictícios, com pelo menos três estandes de demonstração.
- Distribuir o app por APK no App Distribution, sem publicação na Google Play.

**Como usar este plano.** Salve este documento em `docs/plano-de-implementacao.md` no repositório e peça ao Claude Code uma etapa por vez, pelo código dela. Exemplo: "Implemente a etapa W3 do plano".

## 2. Regras de trabalho para o Claude Code

Estas regras valem em todas as etapas e têm prioridade sobre qualquer conveniência de implementação.

1. **O Claude Code não faz commits.** Não executar `git add`, `git commit`, `git push`, `git tag`, nem criar ou trocar de branch. Todos os commits são feitos por Yago.
2. **Uma etapa por vez.** Ao terminar uma etapa, parar e entregar: arquivos criados ou alterados, como testar, resultado do critério de aceite e a mensagem de commit sugerida. Só seguir para a próxima etapa depois da confirmação de Yago.
3. **Somente plano Spark.** Não usar Cloud Functions, Cloud Storage, extensões ou qualquer recurso que exija o plano Blaze. O projeto usa apenas Authentication, Firestore, Remote Config, Analytics, App Distribution e, opcionalmente, Hosting.
4. **Sem segredos no repositório.** Nunca versionar keystore (`*.jks`, `*.keystore`), `key.properties` ou `.env.local`. Versionar apenas `.env.example`.
5. **Contrato fixo.** Nomes de coleções, campos, parâmetros do Remote Config e eventos do Analytics seguem a seção 5. Não renomear sem pedir.
6. **Escopo da lauda.** Implementar o que a lauda pede, com código direto. Sem camadas genéricas, sem bibliotecas além das listadas na seção 3, sem funcionalidades extras não pedidas.
7. **Design.** Seguir os arquivos em `docs/design/`. Não inventar identidade visual (seção 6).
8. **Ações na conta de Yago.** `firebase login`, `flutterfire configure`, deploys e tudo que acontece no console do Firebase são executados por Yago. O Claude Code prepara os arquivos e informa o comando exato.
9. **Versões.** Instalar dependências pela ferramenta (`npm install`, `flutter pub add`) para obter a versão estável atual. Não fixar números de versão de memória.
10. **Dados fictícios.** Nenhum nome, e-mail ou dado real de visitante em código, seeds ou eventos.

### Convenção de commits

As mensagens sugeridas seguem Conventional Commits, no formato `tipo(escopo): descrição`, com descrição em português, no imperativo e em minúsculas.

| Elemento | Valores usados neste projeto |
| --- | --- |
| Tipos | `feat`, `fix`, `chore`, `docs`, `style`, `refactor`, `test`, `build` |
| Escopos | `web`, `mobile`, `firebase`, `docs`, `repo` |

Se uma etapa for dividida em mais de um commit, o Claude Code sugere uma mensagem para cada parte, na ordem.

## 3. Decisões de arquitetura

### Um repositório só (monorepo)

O painel web e o app mobile ficam no mesmo repositório do GitHub, em pastas separadas. Os dois usam o mesmo projeto Firebase, as mesmas regras do Firestore e o mesmo contrato de dados, e a entrega é única.

Com tudo junto, o Claude Code enxerga os dois lados numa sessão e mantém o contrato coerente. Dois repositórios também funcionariam, mas as regras e o contrato precisariam morar em um deles ou ser duplicados.

### Painel web

| Item | Escolha |
| --- | --- |
| Base | React + TypeScript com Vite |
| Arquitetura | Feature-based: `auth`, `estandes`, `qrcode`, `checkins`, `missao` |
| Rotas | React Router |
| Dados | Firebase JS SDK modular (Auth e Firestore), com `onSnapshot` para tempo real |
| QR code | `qrcode.react` |
| Estilo | CSS Modules com variáveis CSS vindas dos tokens do design |
| Estado | Context para a sessão e hooks por feature. Sem biblioteca de estado global |
| Formulários | Componentes controlados com validação simples. Sem biblioteca de formulário |
| Qualidade | ESLint, Prettier e Vitest apenas para funções puras |

Regra da arquitetura feature-based: uma feature só importa de `shared/` e do `index.ts` público de outra feature. Nada de importar arquivos internos de outra feature.

### App mobile

| Item | Escolha |
| --- | --- |
| Base | Flutter, somente Android |
| Arquitetura | Feature-first: `auth`, `estandes`, `checkin`, `missao` |
| Pacotes Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_remote_config`, `firebase_analytics` |
| Leitura de QR | `mobile_scanner` |
| Ícones | `material_symbols_icons` (Material Symbols Rounded, como pede o design) |
| Estado | `StreamBuilder` sobre os streams do Firestore e um `ChangeNotifier` para a missão. Sem biblioteca de estado |
| Navegação | `Navigator` padrão do Flutter |

iOS fica fora do escopo. A lauda recomenda Android, e a distribuição para iPhone pelo App Distribution exigiria uma conta paga de desenvolvedor Apple.

### Identidade e acesso

- Organização: e-mail e senha no Firebase Authentication. Um usuário é administrador quando existe o documento `admins/{uid}`.
- Visitante: sessão anônima criada na primeira abertura do app. O `uid` anônimo é a identidade usada no check-in.

## 4. Estrutura de pastas

### Raiz do repositório

```text
circuito-de-descobertas/
├── CLAUDE.md                     # resumo das regras da seção 2 e ponteiro para o plano
├── README.md                     # o que é, como rodar web e mobile
├── .gitignore
├── firebase.json                 # regras do Firestore e Hosting (opcional)
├── .firebaserc                   # id do projeto Firebase
├── firestore.rules
├── firestore.indexes.json
├── docs/
│   ├── lauda.pdf
│   ├── plano-de-implementacao.md
│   ├── contrato-de-dados.md      # cópia da seção 5, fonte única para web e mobile
│   ├── guia-firebase.md          # passos manuais no console
│   ├── roteiro-video.md
│   └── design/                   # exportado do Claude Design (seção 6)
│       ├── tokens.md
│       ├── web/
│       └── mobile/
├── web/                          # painel da organização
└── mobile/                       # app Flutter do visitante
```

### Painel web (`web/`)

```text
web/
├── .env.example                  # VITE_FIREBASE_* sem valores
├── index.html
├── package.json
├── vite.config.ts
├── tsconfig.json
└── src/
    ├── main.tsx
    ├── app/
    │   ├── App.tsx
    │   ├── router.tsx            # rotas públicas e protegidas
    │   └── providers.tsx
    ├── features/
    │   ├── auth/
    │   │   ├── api/              # login, logout, checagem de admin
    │   │   ├── components/       # LoginForm, ProtectedRoute
    │   │   ├── hooks/            # useAuth
    │   │   ├── pages/            # LoginPage
    │   │   ├── types.ts
    │   │   └── index.ts          # API pública da feature
    │   ├── estandes/
    │   │   ├── api/              # leitura em tempo real, criar, editar
    │   │   ├── components/       # EstandeTable, EstandeForm, StatusBadge
    │   │   ├── hooks/            # useEstandes
    │   │   ├── pages/            # EstandesPage, EstandeFormPage
    │   │   ├── types.ts
    │   │   └── index.ts
    │   ├── qrcode/
    │   │   ├── components/       # EstandeQrCode
    │   │   ├── pages/            # QrCodePage (tela cheia e impressão)
    │   │   ├── utils/            # buildQrPayload + teste
    │   │   └── index.ts
    │   ├── checkins/
    │   │   ├── api/              # leitura em tempo real dos check-ins
    │   │   ├── hooks/            # useCheckinTotals
    │   │   ├── utils/            # contarPorEstande + teste
    │   │   └── index.ts
    │   └── missao/
    │       ├── components/       # CopiarIdsMissao
    │       └── index.ts
    └── shared/
        ├── components/           # Button, Input, Modal, Toast, AppShell
        ├── lib/
        │   └── firebase.ts       # initializeApp, auth, db
        ├── styles/
        │   ├── tokens.css        # variáveis CSS do design
        │   └── global.css
        └── utils/
```

### App mobile (`mobile/`)

```text
mobile/
├── pubspec.yaml
├── analysis_options.yaml
├── android/
│   ├── key.properties            # fora do git
│   └── app/
│       ├── build.gradle.kts      # applicationId e assinatura de release
│       └── google-services.json  # gerado pelo flutterfire configure
├── test/                         # testes das funções puras
└── lib/
    ├── main.dart                 # inicializa Firebase e sobe o app
    ├── firebase_options.dart     # gerado pelo flutterfire configure
    ├── app/
    │   ├── app.dart              # MaterialApp e rotas
    │   └── theme/                # cores e tipografia vindas dos tokens
    ├── core/
    │   ├── analytics/            # AnalyticsService
    │   ├── constants/            # nomes de coleções, parâmetros e eventos
    │   └── widgets/              # estados de carregando, vazio e erro
    └── features/
        ├── auth/
        │   ├── data/             # AuthService (sessão anônima)
        │   └── presentation/     # SplashPage
        ├── estandes/
        │   ├── data/             # EstandeRepository, modelo Estande
        │   └── presentation/     # HomePage, EstandeCard, EstandeDetalhePage
        ├── checkin/
        │   ├── data/             # CheckinService, parseQrPayload
        │   └── presentation/     # ScannerPage, ResultadoCheckinPage
        └── missao/
            ├── data/             # MissaoController (Remote Config)
            └── presentation/     # MissaoBanner, MissaoPage
```

O `google-services.json` e o `firebase_options.dart` contêm identificadores do projeto, não segredos, e podem ser versionados. A proteção dos dados está nas regras do Firestore.

## 5. Contrato de dados

Esta seção é a fonte única para web e mobile. Na etapa F1 ela é copiada para `docs/contrato-de-dados.md`.

### Coleções do Firestore

| Coleção | ID do documento | Campos |
| --- | --- | --- |
| `estandes` | Código curto digitado pelo admin, por exemplo `E03`. Formato `^[A-Z0-9]{2,12}$`. Imutável depois de criado | `nome` (string), `descricao` (string), `localizacao` (string), `ativo` (boolean), `criadoEm` (timestamp), `atualizadoEm` (timestamp) |
| `checkins` | `{visitanteId}_{estandeId}` | `visitanteId` (string, uid anônimo), `estandeId` (string), `criadoEm` (timestamp do servidor) |
| `admins` | `uid` do administrador | `email` (string). Criado à mão no console |

O código curto como ID do estande é uma decisão de projeto. Ele é fácil de digitar no Remote Config e aparece legível no GA4 como `estande_id: E03`, igual ao exemplo da lauda.

O ID composto do check-in garante uma visita por visitante e por estande. Um segundo check-in no mesmo estande teria o mesmo ID, e as regras não permitem alterar um check-in existente.

### Conteúdo do QR code

O QR carrega o texto `circuito-descobertas:estande:{estandeId}`, por exemplo `circuito-descobertas:estande:E03`. Qualquer leitura fora desse formato é tratada como QR inválido, sem consultar o Firestore.

### Regras de acesso

| Quem | Pode | Não pode |
| --- | --- | --- |
| Administrador | Ler, criar e editar estandes. Ler todos os check-ins | Apagar estandes ou check-ins |
| Visitante (anônimo) | Ler estandes ativos. Criar check-in com o próprio uid em estande ativo. Ler os próprios check-ins | Ler estandes inativos, alterar estandes, ler check-ins de outros, alterar ou apagar check-ins |
| Não autenticado | Nada | Tudo |

Rascunho de `firestore.rules`. Ele não foi executado: a etapa F1 exige validá-lo cenário por cenário antes de seguir.

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function autenticado() {
      return request.auth != null;
    }

    function ehAdmin() {
      return autenticado()
        && exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }

    function estandeValido() {
      return request.resource.data.keys().hasOnly(
          ['nome', 'descricao', 'localizacao', 'ativo', 'criadoEm', 'atualizadoEm'])
        && request.resource.data.nome is string
        && request.resource.data.nome.size() > 0
        && request.resource.data.descricao is string
        && request.resource.data.localizacao is string
        && request.resource.data.ativo is bool;
    }

    match /admins/{uid} {
      allow get: if autenticado() && request.auth.uid == uid;
      allow list, write: if false;
    }

    match /estandes/{estandeId} {
      // resource == null permite distinguir "não existe" de "inativo" no app
      allow get: if ehAdmin()
        || (autenticado() && (resource == null || resource.data.ativo == true));
      allow list: if ehAdmin()
        || (autenticado() && resource.data.ativo == true);
      allow create: if ehAdmin()
        && estandeId.matches('^[A-Z0-9]{2,12}$')
        && estandeValido();
      allow update: if ehAdmin() && estandeValido();
      allow delete: if false;
    }

    match /checkins/{checkinId} {
      allow get: if ehAdmin()
        || (autenticado() && checkinId.matches(request.auth.uid + '_.+'));
      allow list: if ehAdmin()
        || (autenticado() && resource.data.visitanteId == request.auth.uid);
      allow create: if autenticado()
        && request.resource.data.keys().hasOnly(['visitanteId', 'estandeId', 'criadoEm'])
        && request.resource.data.visitanteId == request.auth.uid
        && request.resource.data.estandeId is string
        && checkinId == request.auth.uid + '_' + request.resource.data.estandeId
        && request.resource.data.criadoEm == request.time
        && get(/databases/$(database)/documents/estandes/$(request.resource.data.estandeId)).data.ativo == true;
      allow update, delete: if false;
    }
  }
}
```

Consequência para o app: ao ler `estandes/{id}`, documento inexistente significa QR inválido e erro `permission-denied` significa estande inativo.

Consequência para as consultas: o app lista estandes com `where('ativo', '==', true)` e ordena no cliente, para não exigir índice composto.

### Remote Config

| Parâmetro | Tipo | Padrão local no app | Exemplo publicado |
| --- | --- | --- | --- |
| `missao_ativa` | Boolean | `false` | `true` |
| `missao_estandes_ids` | JSON | `[]` | `["E02","E03"]` |
| `missao_inicio` | String | `""` | `2026-11-20T15:00:00-03:00` |
| `missao_duracao_min` | Number | `0` | `30` |

O app destaca apenas a interseção entre `missao_estandes_ids` e os estandes ativos. JSON malformado é tratado como lista vazia.

`missao_inicio` usa ISO 8601 com fuso. Com início e duração válidos, o app mostra o prazo ("Visite 2 estandes em 30 min", "Faltam 25 min") e trata a missão como desligada antes do início e depois do fim. Início vazio ou inválido, ou duração menor ou igual a zero, deixa a missão sem prazo.

### Eventos do Analytics

| Evento | Quando dispara | Parâmetros |
| --- | --- | --- |
| `missao_aberta` | O visitante abre a tela da missão | nenhum |
| `checkin_concluido` | Logo após a gravação do check-in ser confirmada | `estande_id` (string, código do estande) |

Os eventos saem apenas do app mobile. O painel web não envia eventos.

### Estandes fictícios sugeridos

| Código | Nome | Descrição | Localização |
| --- | --- | --- | --- |
| `E01` | Maré Viva | Alerta de marés para travessias ribeirinhas | Corredor A, estande 1 |
| `E02` | Trilha Verde | Rastreio de mudas em sistemas agroflorestais | Corredor C, estande 7 |
| `E03` | Farinha Digital | Vitrine online para produtores de farinha | Corredor D, estande 12 |

Os três são cadastrados pelo próprio painel. `E02` e `E03` ficam longe da entrada e servem como estandes da missão.

## 6. Design

O design do painel e do app será criado por Yago no Claude Design, tendo como referência o site oficial do [Amazon Hacking](https://amazon-hacking.com/). Essa etapa é manual e não é feita pelo Claude Code.

O Claude Code implementa a interface a partir do que estiver em `docs/design/`. Ele não escolhe cores, fontes ou layouts por conta própria.

### Referência observada no site

Ponto de partida para o briefing no Claude Design, a confirmar olhando o site:

- Cor de tema azul `#0165b7` e esquema claro.
- Slogan "Onde a Amazônia encontra a inovação" e logotipo em versão branca sobre fundo colorido.
- Fotos da região, ilustrações em SVG e cartões de projeto em seções bem delimitadas.
- Tom institucional e inspirador, com frases curtas.

O sistema é um trabalho acadêmico inspirado no evento. Logotipo e fotos oficiais só entram se a equipe tiver os arquivos e autorização para usá-los. Caso contrário, usar o nome "Circuito de Descobertas" em texto.

### O que o design precisa entregar

| Arquivo | Conteúdo |
| --- | --- |
| `docs/design/tokens.md` | Cores (primária, superfícies, texto, sucesso, alerta, erro, destaque da missão), tipografia, espaçamentos, raios e sombras, com valores exatos |
| `docs/design/web/` | Telas do painel exportadas como imagem ou PDF |
| `docs/design/mobile/` | Telas do app exportadas como imagem ou PDF |

Telas do painel web:

- Login do administrador, com estado de erro.
- Lista de estandes com status, total de check-ins e ações.
- Formulário de criar e editar estande.
- QR code do estande em tela cheia, pronto para impressão.

Telas do app mobile:

- Abertura (carregando a sessão).
- Início com a lista de estandes, nas duas versões: missão desligada e missão ligada (chamada no topo e estandes destacados).
- Tela da missão com os estandes participantes.
- Leitor de QR code.
- Quatro retornos do check-in: sucesso, QR inválido, estande inativo e visita já registrada.
- Estados de lista vazia e de erro de conexão.

### Como o Claude Code usa o design

1. Os tokens viram variáveis CSS em `web/src/shared/styles/tokens.css` e um `ThemeData` em `mobile/lib/app/theme/`. Nenhuma cor ou tamanho fica solto nos componentes.
2. Cada tela é comparada com a imagem correspondente antes de a etapa ser dada como concluída.
3. Se `docs/design/` ainda estiver vazia, as etapas W1 a W3 e M1 a M3 podem avançar com tokens provisórios neutros. As etapas W4 e M4 em diante esperam o design.
4. Tela ou estado que não exista no design: o Claude Code pergunta antes de criar.

## 7. Fase 0 — Preparação

Três etapas deixam o terreno pronto. P1 e P2 são manuais, feitas por Yago. P3 é a primeira etapa do Claude Code.

### P1 — Projeto no console do Firebase (Yago)

1. Criar o projeto no plano Spark, com o Google Analytics ativado na criação.
2. Authentication: ativar os provedores "E-mail/senha" e "Anônimo".
3. Authentication: criar o usuário administrador com um e-mail fictício e copiar o `uid`.
4. Firestore: criar o banco em modo de produção. Criar a coleção `admins` com um documento cujo ID é o `uid` copiado e o campo `email`.
5. Remote Config: criar `missao_ativa` (Boolean, `false`), `missao_estandes_ids` (JSON, `[]`), `missao_inicio` (String, vazio) e `missao_duracao_min` (Number, `0`) e publicar.
6. Registrar um app Web no projeto e guardar o objeto de configuração para o `.env.local`.

Aceite: o console mostra os dois provedores ativos, o documento em `admins` e os quatro parâmetros publicados. Esta etapa não gera commit.

### P2 — Design no Claude Design (Yago)

Criar o design conforme a seção 6 e exportar tokens e telas para `docs/design/`. Esta etapa pode correr em paralelo com P3, F1, W1 a W3 e M1 a M3.

Aceite: `docs/design/tokens.md` com valores exatos e uma imagem por tela listada na seção 6.

```text
docs(design): adiciona tokens e telas de referência do painel e do app
```

### P3 — Estrutura do repositório (Claude Code)

1. Criar a raiz conforme a seção 4, ainda sem `web/` e `mobile/`.
2. Escrever o `CLAUDE.md` com as regras da seção 2 e o caminho deste plano.
3. Escrever o `README.md` com descrição, pré-requisitos e espaço para os comandos de execução.
4. Criar o `.gitignore` cobrindo `node_modules`, `dist`, `.env.local`, artefatos de build do Flutter, `*.jks`, `*.keystore` e `key.properties`.
5. Copiar a lauda para `docs/lauda.pdf` e este plano para `docs/plano-de-implementacao.md`.

Aceite: a árvore da raiz bate com a seção 4 e o `.gitignore` cobre todos os itens de segredo.

```text
chore(repo): inicializa estrutura do monorepo e documentação base
```

## 8. Fase 1 — Firebase compartilhado

Uma etapa fixa o contrato e as regras antes de qualquer tela, porque web e mobile dependem dos dois.

### F1 — Contrato e regras do Firestore (Claude Code)

1. Criar `docs/contrato-de-dados.md` com o conteúdo da seção 5.
2. Criar `firebase.json`, `.firebaserc`, `firestore.indexes.json` e `firestore.rules` a partir do rascunho da seção 5.
3. Escrever em `docs/guia-firebase.md` os passos manuais da etapa P1 e o comando de publicação das regras.
4. Informar a Yago o comando `firebase deploy --only firestore:rules` para ele executar.
5. Validar as regras com os cenários abaixo, no simulador de regras do console ou no emulador local do Firestore.

| Cenário | Resultado esperado |
| --- | --- |
| Sem autenticação lê `estandes` | Negado |
| Visitante lista estandes com `ativo == true` | Permitido |
| Visitante lê um estande inativo pelo ID | Negado |
| Visitante lê um ID de estande inexistente | Permitido, documento não existe |
| Visitante cria ou edita um estande | Negado |
| Visitante cria check-in com o próprio uid em estande ativo | Permitido |
| Visitante cria check-in com uid de outra pessoa | Negado |
| Visitante cria check-in em estande inativo | Negado |
| Visitante regrava um check-in que já existe | Negado |
| Visitante lista check-ins de todos | Negado |
| Admin cria e edita estande | Permitido |
| Admin cria estande com ID fora do formato | Negado |
| Admin lista todos os check-ins | Permitido |

Aceite: os treze cenários dão o resultado esperado. Se algum falhar, corrigir a regra, nunca afrouxar o contrato.

```text
feat(firebase): adiciona contrato de dados e regras de segurança do firestore
```

## 9. Fase 2 — Painel web

O painel vem antes do app porque os estandes e os QR codes nascem nele. São nove etapas, todas do Claude Code, cada uma com um commit sugerido.

### W1 — Projeto React com TypeScript

1. Criar o projeto em `web/` com Vite, template React + TypeScript.
2. Configurar o alias `@/` para `src/`, ESLint, Prettier e Vitest.
3. Criar as pastas `app/`, `features/` e `shared/` conforme a seção 4.
4. Criar `tokens.css` e `global.css` com os tokens do design, ou provisórios se o design não estiver pronto.
5. Configurar o React Router com as rotas `/login`, `/estandes`, `/estandes/novo`, `/estandes/:id/editar` e `/estandes/:id/qr`, ainda com páginas vazias.

Aceite: `npm run dev` abre o painel, e `npm run build` e `npm run lint` passam sem erros.

```text
chore(web): configura projeto react com typescript, vite e estrutura por features
```

### W2 — SDK do Firebase

1. Instalar o pacote `firebase`.
2. Criar `shared/lib/firebase.ts` exportando `auth` e `db`, lendo a configuração de variáveis `VITE_FIREBASE_*`.
3. Criar `.env.example` com as chaves sem valores. Yago preenche o `.env.local`.
4. Falhar com mensagem clara na inicialização se alguma variável estiver ausente.

Aceite: o painel inicia sem erros no console do navegador com o `.env.local` preenchido.

```text
feat(web): configura sdk do firebase e variáveis de ambiente
```

### W3 — Autenticação do administrador

1. `LoginPage` com e-mail e senha, usando `signInWithEmailAndPassword`.
2. `AuthProvider` com `onAuthStateChanged`. Após o login, ler `admins/{uid}`: se não existir, encerrar a sessão e mostrar "Acesso restrito à organização".
3. `ProtectedRoute` que redireciona para `/login` quando não há administrador autenticado.
4. Botão de sair. Mensagens de erro em português para credenciais inválidas e falha de rede.
5. O painel não tem tela de cadastro de usuário.

Aceite: o admin entra e a sessão sobrevive ao recarregar a página. Senha errada mostra erro. Um usuário sem documento em `admins` é barrado.

```text
feat(web): adiciona autenticação de administrador com rota protegida
```

### W4 — Layout e componentes base

1. `AppShell` com cabeçalho, nome do painel, e-mail do admin e botão de sair.
2. Componentes em `shared/components/`: `Button`, `Input`, `Textarea`, `Switch`, `Badge`, `Modal` e `Toast`.
3. Todos os estilos consomem apenas variáveis de `tokens.css`.

Aceite: as telas de login e a moldura do painel batem com as imagens em `docs/design/web/`.

```text
feat(web): adiciona layout base e componentes de interface do design
```

### W5 — Cadastro e edição de estandes

1. `useEstandes` com `onSnapshot` na coleção `estandes`, ordenando por código no cliente.
2. `EstandesPage` com tabela: código, nome, localização, status e ações.
3. `EstandeForm` para criar: código, nome, descrição breve, localização e ativo. Validar o código com `^[A-Z0-9]{2,12}$` e recusar código já existente, checando dentro de uma transação.
4. O mesmo formulário para editar, com o código somente leitura. Atualizar `atualizadoEm` com `serverTimestamp()`.
5. Alternar ativo e inativo direto na tabela.
6. Estados de carregando, lista vazia e erro.

Aceite: os três estandes fictícios da seção 5 são cadastrados pelo painel. Editar e inativar refletem na tabela sem recarregar. Código duplicado é recusado.

```text
feat(web): adiciona cadastro, edição e ativação de estandes
```

### W6 — QR code por estande

1. `buildQrPayload(estandeId)` retornando `circuito-descobertas:estande:{id}`, com teste unitário.
2. `EstandeQrCode` com `qrcode.react`, em SVG, com nível de correção de erro M ou superior.
3. Ação "QR code" na tabela abrindo `/estandes/:id/qr` em nova aba.
4. `QrCodePage` em tela cheia com QR grande, nome, código e localização do estande, e botão "Imprimir".
5. CSS de impressão que esconde botões e cabeçalho e centraliza o QR na folha.

Aceite: um leitor de QR qualquer lê o texto esperado, tanto na tela quanto na pré-visualização de impressão.

```text
feat(web): adiciona geração e impressão de qr code por estande
```

### W7 — Total de check-ins por estande

1. `useCheckinTotals` com `onSnapshot` na coleção `checkins`.
2. `contarPorEstande(checkins)` como função pura que agrupa por `estandeId`, com teste unitário.
3. Coluna "Check-ins" na tabela de estandes e um total geral acima dela.
4. Destaque visual breve na linha cujo total acabou de mudar.

O total é calculado dos documentos de `checkins`, como a lauda exige. Não criar campo contador no estande.

Aceite: criar à mão no console um documento de check-in válido faz o total subir no painel em segundos, sem recarregar.

```text
feat(web): exibe total de check-ins por estande em tempo real
```

### W8 — Atalho para configurar a missão

1. Caixas de seleção na tabela de estandes ativos.
2. Botão "Copiar IDs da missão" que copia o JSON pronto para o Remote Config, por exemplo `["E02","E03"]`.
3. Texto curto explicando que a missão é publicada no console do Firebase, no parâmetro `missao_estandes_ids`.

O painel não publica no Remote Config. A lauda pede que a publicação seja feita pelo console.

Depois do plano, o painel ganhou o botão **Iniciar missão**, pedido por Yago. Ele publica a missão pela API REST do Remote Config com a conta Google do projeto ([guia, seção 5](guia-firebase.md#5-publicar-a-missão-pelo-painel-opcional)). O vídeo continua publicando pelo console.

Aceite: o texto copiado é um JSON válido contendo apenas os códigos selecionados.

```text
feat(web): adiciona atalho para copiar ids dos estandes da missão
```

### W9 — Acabamento e hospedagem opcional

1. Revisar todas as telas contra `docs/design/web/`, incluindo foco de teclado e larguras menores.
2. Ajustar título da página e favicon.
3. Atualizar o `README.md` com os comandos para rodar o painel.
4. Opcional: configurar o Firebase Hosting no `firebase.json` com `web/dist` e rewrite de SPA. O deploy é executado por Yago.

Aceite: o fluxo login, cadastro, QR e totais funciona do início ao fim em `npm run dev` e na versão de `npm run build`.

```text
style(web): refina telas, estados e responsividade conforme o design
```

Se a hospedagem for configurada, um segundo commit:

```text
chore(web): configura deploy do painel no firebase hosting
```

## 10. Fase 3 — App mobile

O app é construído em dez etapas, na ordem em que os critérios de nota dependem umas das outras: dados, check-in, missão, eventos e, por fim, o APK assinado.

### M1 — Projeto Flutter

1. Criar o projeto em `mobile/` apenas para Android, com o nome `circuito_descobertas`.
2. Definir agora o `applicationId` definitivo, por exemplo `com.circuitodescobertas.app`. Ele liga o app ao Firebase e não deve mudar depois.
3. Criar as pastas `app/`, `core/` e `features/` conforme a seção 4.
4. Criar o tema em `app/theme/` a partir dos tokens do design, ou provisório.
5. Criar `core/constants/` com os nomes de coleções, parâmetros e eventos da seção 5.

Aceite: `flutter analyze` sem avisos e o app abre uma tela inicial vazia no emulador ou aparelho.

```text
chore(mobile): cria projeto flutter com estrutura por features
```

### M2 — Firebase no app

1. Yago executa `flutterfire configure` dentro de `mobile/`, selecionando o projeto e a plataforma Android.
2. Adicionar `firebase_core` e inicializar o Firebase no `main.dart` com `DefaultFirebaseOptions.currentPlatform`.
3. Ajustar `minSdk` e plugins do Gradle se algum pacote do Firebase exigir.

Aceite: o app inicia sem erros de inicialização e o app Android aparece nas configurações do projeto no console.

```text
feat(mobile): integra o firebase ao app android
```

### M3 — Sessão anônima do visitante

1. Adicionar `firebase_auth`.
2. `AuthService.garantirSessao()`: se não houver usuário, chamar `signInAnonymously()`.
3. `SplashPage` exibida enquanto a sessão é criada, com mensagem e botão "Tentar de novo" em caso de falha.

Aceite: um usuário anônimo aparece no console de Authentication. Fechar e reabrir o app mantém o mesmo `uid`.

```text
feat(mobile): adiciona sessão anônima do visitante
```

### M4 — Lista de estandes ativos

1. Adicionar `cloud_firestore`.
2. Modelo `Estande` e `EstandeRepository.estandesAtivos()` como stream com `where('ativo', isEqualTo: true)`, ordenando por nome no cliente.
3. `HomePage` com `StreamBuilder` e um `EstandeCard` por estande, mostrando nome, descrição e localização.
4. `EstandeDetalhePage` ao tocar no cartão.
5. Stream dos check-ins do próprio visitante (`where('visitanteId', isEqualTo: uid)`) para marcar os estandes já visitados.
6. Estados de carregando, lista vazia e erro, e botão fixo "Ler QR code".

Aceite: um estande criado no painel aparece no app sem reiniciar. Inativá-lo no painel faz o cartão sumir.

```text
feat(mobile): lista estandes ativos em tempo real
```

### M5 — Leitura de QR code

1. Adicionar `mobile_scanner` e a permissão de câmera no `AndroidManifest.xml`.
2. `parseQrPayload(texto)`: devolve o `estandeId` quando o texto segue `circuito-descobertas:estande:{id}` e o ID respeita `^[A-Z0-9]{2,12}$`. Caso contrário, devolve nulo. Cobrir com testes unitários.
3. `ScannerPage` com a câmera, moldura de mira e botão de lanterna.
4. Processar apenas a primeira leitura e pausar o leitor até o retorno ser fechado.
5. Tela explicativa com atalho para as configurações quando a permissão de câmera for negada.

Em emulador Android, configurar a câmera traseira do AVD como webcam e apontar para o QR aberto em outra tela ou impresso.

Aceite: ler o QR do painel mostra o código do estande. Ler um QR qualquer mostra "QR code inválido".

```text
feat(mobile): adiciona leitura de qr code pela câmera
```

### M6 — Registro do check-in

`CheckinService.registrar(estandeId)` devolve um de cinco resultados e segue esta ordem:

1. Ler `estandes/{estandeId}`. Documento inexistente: `qrInvalido`. Erro `permission-denied`: `estandeInativo`.
2. Ler `checkins/{uid}_{estandeId}`. Documento existente: `jaRegistrado`.
3. Gravar o check-in com `visitanteId`, `estandeId` e `criadoEm: FieldValue.serverTimestamp()`.
4. Gravação confirmada: `sucesso`. Qualquer outra falha: `erro`, com opção de tentar de novo.

| Resultado | Retorno ao visitante |
| --- | --- |
| `sucesso` | "Visita registrada" com o nome do estande |
| `qrInvalido` | "QR code inválido" |
| `estandeInativo` | "Este estande não está ativo" |
| `jaRegistrado` | "Você já registrou esta visita" |
| `erro` | "Não foi possível registrar. Tente de novo" |

A validação do app melhora a mensagem, mas quem garante a regra é o Firestore. Um estande inativado entre a leitura e a gravação é barrado pelas regras e tratado como `estandeInativo`.

Aceite: os quatro cenários da lauda são reproduzidos no app. O documento aparece no Firestore com o ID composto e o total sobe no painel.

```text
feat(mobile): registra check-in com validação do estande e bloqueio de duplicatas
```

### M7 — Missão surpresa com Remote Config

1. Adicionar `firebase_remote_config`.
2. `MissaoController` (`ChangeNotifier`) com `ativa` (bool) e `estandesIds` (lista).
3. Na inicialização: `setDefaults` com `missao_ativa: false`, `missao_estandes_ids: '[]'`, `missao_inicio: ''` e `missao_duracao_min: 0`, depois `fetchAndActivate()`. Falha de rede mantém o padrão local.
4. Tempo real: escutar `onConfigUpdated`, chamar `activate()` e notificar os ouvintes.
5. Ler `missao_estandes_ids` com `jsonDecode` protegido. Valor inválido vira lista vazia.
6. Prazo: com `missao_inicio` e `missao_duracao_min` válidos, mostrar "em N min" e a contagem "Faltam N min"; antes do início e depois do fim, a missão conta como desligada.
7. Missão ligada: `MissaoBanner` no topo da `HomePage` e destaque nos cartões dos estandes participantes que estejam ativos.
8. `MissaoPage` aberta pelo banner, listando os estandes participantes e quais já foram visitados.
9. Missão desligada: banner e destaques somem. Se a `MissaoPage` estiver aberta, voltar para o início com o aviso "Missão encerrada".

O intervalo mínimo de busca pode ser zero apenas em modo debug. Em release, a atualização imediata vem do listener de tempo real, que funciona com o app em primeiro plano.

Aceite: publicar `missao_ativa` no console liga e desliga o banner no app aberto, em segundos, sem reiniciar. Sem rede na primeira abertura, o app inicia com a missão desligada e a lista normal.

```text
feat(mobile): controla a missão surpresa via remote config em tempo real
```

### M8 — Eventos do Analytics

1. Adicionar `firebase_analytics`.
2. `AnalyticsService` com dois métodos: `missaoAberta()` e `checkinConcluido(estandeId)`.
3. Disparar `missao_aberta` ao abrir a `MissaoPage`.
4. Disparar `checkin_concluido` com o parâmetro `estande_id` somente depois do resultado `sucesso`.

Durante o desenvolvimento, o DebugView do GA4 mostra os eventos quase na hora após `adb shell setprop debug.firebase.analytics.app <applicationId>`. No vídeo, a evidência é o relatório Tempo real, com o app usado como visitante comum.

Aceite: os dois eventos aparecem no GA4 e `checkin_concluido` traz `estande_id` com o código do estande lido.

```text
feat(mobile): registra eventos missao_aberta e checkin_concluido no analytics
```

### M9 — Acabamento visual

1. Revisar cada tela contra `docs/design/mobile/`.
2. Definir o nome exibido "Circuito de Descobertas" e o ícone do app.
3. Revisar textos, tamanhos de toque e contraste.

Aceite: as telas batem com o design nas duas versões da tela inicial, com missão ligada e desligada.

```text
style(mobile): aplica identidade visual, ícone e nome do app
```

### M10 — APK de release assinado

1. Yago gera a keystore de upload com `keytool` e guarda o arquivo e as senhas fora do repositório.
2. Criar `android/key.properties` (fora do git) e configurar `signingConfigs` de release em `android/app/build.gradle.kts`.
3. Definir `versionName` e `versionCode` no `pubspec.yaml`.
4. Confirmar as permissões de internet e câmera no manifesto principal.
5. Gerar com `flutter build apk --release` e conferir a assinatura com `apksigner verify --print-certs`.
6. Documentar o passo a passo em `docs/guia-firebase.md`, sem senhas.

Aceite: o APK de release instala em um aparelho ou emulador limpo e repete lista, check-in, missão e eventos. A assinatura não é a de debug.

```text
build(mobile): configura assinatura de release do apk
```

## 11. Fase 4 — Distribuição, teste integrado e vídeo

As três últimas etapas produzem as evidências que valem nota. D1 é manual, D2 é conjunta e D3 é do Claude Code.

### D1 — Firebase App Distribution (Yago)

1. No console, abrir App Distribution e enviar o APK de release gerado em M10.
2. Adicionar o e-mail do testador convidado e distribuir a versão, com uma nota curta.
3. No Android do testador: abrir o e-mail de convite, aceitar, baixar e instalar o app.
4. Abrir o app instalado e conferir a tela inicial.

Se a gravação for feita em emulador, usar uma imagem com Google Play e a conta Google do testador. Um aparelho Android físico de algum integrante simplifica a instalação e a leitura do QR.

Aceite: o console mostra o testador com convite aceito e download feito, e o app aberto é o distribuído, não um build de debug. Esta etapa não gera commit.

### D2 — Teste ponta a ponta (Yago, com apoio do Claude Code)

Rodar o percurso completo com o APK distribuído, na ordem do vídeo. Falhas viram correções pontuais do Claude Code.

- [ ] Estande novo cadastrado no painel aparece no app sem reiniciar
- [ ] QR code do estande abre em outra tela e é lido pela câmera
- [ ] Missão publicada no console faz o banner e os destaques aparecerem no app aberto
- [ ] Tela da missão abre e lista os estandes participantes
- [ ] Check-in concluído mostra a confirmação no app
- [ ] Total do estande sobe no painel sem recarregar
- [ ] Segunda leitura do mesmo QR mostra "visita já registrada"
- [ ] QR de estande inativo e QR aleatório mostram os retornos corretos
- [ ] Missão desligada no console remove banner e destaques, e a lista e o check-in continuam funcionando
- [ ] `missao_aberta` e `checkin_concluido` aparecem no Tempo real do GA4, com `estande_id` no check-in

Cada correção recebe uma mensagem no formato abaixo, com o escopo e a descrição do problema real.

```text
fix(mobile): corrige <problema encontrado no teste integrado>
```

### D3 — Roteiro do vídeo e documentação final (Claude Code)

Escrever `docs/roteiro-video.md` seguindo a ordem da lauda e completar o `README.md`.

1. Apresentar os integrantes. Mostrar o acesso à versão no App Distribution, a instalação e a abertura do app.
2. Cadastrar um estande no painel, mostrar que ele aparece no app e exibir o QR code gerado.
3. Publicar a missão no Remote Config, abrir a missão no app, fazer o check-in, conferir o total no painel, desativar a missão e mostrar a mudança no app.
4. No GA4, abrir Relatórios, Tempo real. Mostrar `missao_aberta` e `checkin_concluido` na contagem por nome do evento, abrir o check-in e mostrar `estande_id`.

O roteiro deve nomear cada serviço na tela em que ele aparece e reservar uma parte identificável para cada integrante. O Analytics pode atrasar: a lauda permite pausar a gravação até os eventos surgirem.

Aceite: o roteiro cobre os quatro critérios da tabela de avaliação e o `README.md` explica como rodar o painel e o app.

```text
docs: adiciona roteiro do vídeo e instruções finais de execução
```

## 12. Rastreabilidade com a lauda

Cada requisito da lauda está coberto por pelo menos uma etapa.

| Requisito da lauda | Etapas |
| --- | --- |
| Painel web roda no navegador e acessa os dados no Firebase | W1, W2 |
| Autenticar um administrador | P1, W3 |
| Cadastrar e editar estandes com nome, descrição, localização e estado | W5 |
| Ao menos três estandes fictícios | W5 |
| Gerar e exibir um QR code por estande, abrível em outra tela ou imprimível | W6 |
| Total de check-ins por estande calculado dos registros, atualizado após check-in | W7 |
| App lista estandes ativos com nome, descrição e localização, mesmo com a missão desligada | M4 |
| Ler QR pela câmera | M5 |
| Validar estande e dar retorno para QR inválido, inativo, já registrado e sucesso | M6 |
| Uma visita por estande e por visitante, com chave composta | F1, M6 |
| Remote Config com `missao_ativa` e IDs dos estandes, padrão local desligado | P1, M7 |
| Missão ligada: chamada na tela inicial, destaques e tela da missão | M7 |
| Missão desligada: sem chamada e sem destaques, lista e check-in disponíveis | M7 |
| Mudança em tempo real no mesmo APK instalado | M7, D2 |
| Regras do Firestore para admin, visitante e organização | F1 |
| Sessão anônima para o visitante e e-mail e senha para a organização | P1, W3, M3 |
| APK assinado distribuído pelo App Distribution | M10, D1 |
| Eventos `missao_aberta` e `checkin_concluido` com `estande_id` no GA4 | M8, D2 |
| Demonstração integrada e vídeo | D2, D3 |
| Plano Spark, sem serviços pagos | Regra 3 da seção 2 |
