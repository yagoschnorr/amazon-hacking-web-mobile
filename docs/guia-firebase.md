# Guia do Firebase — passos manuais

Ações feitas por Yago no console e na conta do Firebase. O Claude Code prepara os arquivos e informa os comandos, mas não os executa.

Tudo roda no plano **Spark**, sem cartão. Não ativar Cloud Functions, Cloud Storage, extensões nem fazer upgrade para o Blaze.

## 1. Criação do projeto (etapa P1)

1. Criar o projeto no [console do Firebase](https://console.firebase.google.com/), no plano Spark, com o **Google Analytics ativado** na criação.
2. **Authentication → Método de login:** ativar os provedores **E-mail/senha** e **Anônimo**.
3. **Authentication → Usuários:** criar o administrador com um e-mail fictício (por exemplo, `admin@circuito.test`) e copiar o **UID**.
4. **Firestore Database:** criar o banco em **modo de produção**. Criar a coleção `admins` com um documento cujo ID é o UID copiado e o campo `email` (string) com o mesmo e-mail.
5. **Remote Config:** criar os parâmetros abaixo e **publicar**.

   | Parâmetro | Tipo | Valor padrão |
   | --- | --- | --- |
   | `missao_ativa` | Boolean | `false` |
   | `missao_estandes_ids` | JSON | `[]` |
   | `missao_inicio` | String | (vazio) |
   | `missao_duracao_min` | Number | `0` |

6. **Configurações do projeto → Seus apps:** registrar um app **Web** e guardar o objeto de configuração (`apiKey`, `authDomain`, `projectId`…). Ele vai para o `web/.env.local` na etapa W2.

Aceite: os dois provedores ativos, o documento em `admins` e os quatro parâmetros publicados.

## 2. Publicação das regras do Firestore (etapa F1)

### Uma única vez

1. Instalar o Firebase CLI:

   ```bash
   npm install -g firebase-tools
   ```

2. Entrar na conta:

   ```bash
   firebase login
   ```

3. Em **Configurações do projeto → Geral**, copiar o **ID do projeto** e colocá-lo no `.firebaserc`, na raiz do repositório, no lugar de `SEU-PROJECT-ID`:

   ```json
   {
     "projects": {
       "default": "id-do-seu-projeto"
     }
   }
   ```

   O ID do projeto não é segredo e pode ser versionado.

### A cada mudança em `firestore.rules`

Na raiz do repositório:

```bash
firebase deploy --only firestore:rules
```

Conferir em **Firestore Database → Regras** que o texto publicado é igual ao de `firestore.rules`.

O `firestore.indexes.json` está vazio de propósito: as consultas do projeto não exigem índice composto. Se um dia ele mudar, publicar com `firebase deploy --only firestore:indexes`.

## 3. Validação das regras

As regras têm 13 cenários obrigatórios. Se algum falhar, a correção é na regra, nunca no contrato.

| # | Cenário | Resultado esperado |
| --- | --- | --- |
| 1 | Sem autenticação lê `estandes` | Negado |
| 2 | Visitante lista estandes com `ativo == true` | Permitido |
| 3 | Visitante lê um estande inativo pelo ID | Negado |
| 4 | Visitante lê um ID de estande inexistente | Permitido, documento não existe |
| 5 | Visitante cria ou edita um estande | Negado |
| 6 | Visitante cria check-in com o próprio uid em estande ativo | Permitido |
| 7 | Visitante cria check-in com uid de outra pessoa | Negado |
| 8 | Visitante cria check-in em estande inativo | Negado |
| 9 | Visitante regrava um check-in que já existe | Negado |
| 10 | Visitante lista check-ins de todos | Negado |
| 11 | Admin cria e edita estande | Permitido |
| 12 | Admin cria estande com ID fora do formato | Negado |
| 13 | Admin lista todos os check-ins | Permitido |

### Resultado no emulador local

Os 13 cenários foram executados no emulador do Firestore em 11/11/2026 e todos deram o resultado esperado, sem alteração no rascunho do plano. Na mesma execução passaram também 10 cenários complementares:

- Admin lê o próprio documento em `admins`.
- Usuário que não é admin consegue ler `admins/{próprio uid}` e recebe "inexistente", que é o que a etapa W3 usa para barrar o acesso.
- Admin lê estande inativo e lista todos os estandes.
- Admin não consegue apagar estande nem check-in.
- Visitante lê o próprio check-in pelo ID composto, mas não lê o de outra pessoa.
- Visitante lista os próprios check-ins com `where('visitanteId', '==', uid)`.
- Check-in em estande inexistente é negado.
- Check-in com `criadoEm` gerado no cliente ou com campo extra é negado.
- Estande com campo extra ou com `nome` vazio é negado.

### Conferência no simulador do console (opcional)

Em **Firestore Database → Regras → Playground de regras**, depois de publicar:

- O simulador lê os **dados reais** do banco. Para os cenários de admin, o documento `admins/{uid}` precisa existir. Para os de estande ativo e inativo, cadastre antes um estande ativo e outro inativo, ou use os da etapa W5.
- **Visitante:** marcar **Autenticado**, provedor **Anônimo** e um UID qualquer, por exemplo `visitanteA`.
- **Admin:** marcar **Autenticado**, provedor **Senha** e o UID do administrador.
- **Leitura de lista** (cenários 2, 10 e 13): o simulador testa um documento por vez, não consultas. Por isso esses cenários ficam cobertos pelo emulador e, na prática, pelo próprio painel (W5 e W7) e pelo app (M4).
- **Check-in** (cenários 6 a 9): tipo **create**, caminho `checkins/visitanteA_E01` e corpo com `visitanteId` e `estandeId`. A regra exige `criadoEm == request.time`, que só o `serverTimestamp()` do SDK satisfaz. No simulador, o cenário 6 tende a aparecer como negado. Os casos negados (7 a 9) podem ser conferidos no simulador. O cenário 6 fica coberto pelo emulador e pelo app na etapa M6.

## 4. APK de release assinado (etapa M10)

O APK de release é assinado com uma chave de upload própria. A keystore e as senhas ficam **fora do repositório**: `*.jks`, `*.keystore` e `key.properties` estão no `.gitignore`. Sem a chave, `flutter build apk --release` falha de propósito, em vez de sair assinado com a chave de debug.

### Gerar a keystore (uma vez)

Escolha uma pasta fora do repositório e rode o `keytool` do JDK que acompanha o Android Studio. Ele pede as senhas e os dados do certificado:

```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkeypair -v `
  -keystore C:\caminho\fora\do\repo\circuito-upload.jks `
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Guarde o arquivo `.jks` e as senhas em local seguro, com cópia de reserva. Perder a keystore impede publicar atualizações assinadas com a mesma chave.

### Criar `mobile/android/key.properties`

```properties
storePassword=<senha da keystore>
keyPassword=<senha da chave>
keyAlias=upload
storeFile=C:/caminho/fora/do/repo/circuito-upload.jks
```

Use barras normais (`/`) no caminho. Confira com `git status` que o arquivo não aparece.

### Gerar e conferir o APK

```powershell
cd mobile
flutter build apk --release
& "$env:LOCALAPPDATA\Android\Sdk\build-tools\<versão>\apksigner.bat" verify --print-certs build\app\outputs\flutter-apk\app-release.apk
```

O `apksigner` deve mostrar o DN informado na criação da keystore, e não `CN=Android Debug`. O APK fica em `mobile/build/app/outputs/flutter-apk/app-release.apk`.

A versão vem de `version` no `mobile/pubspec.yaml` (`1.0.0+1`: `versionName` 1.0.0 e `versionCode` 1). A cada novo APK distribuído, aumente o número depois do `+`.

### Instalar em um aparelho ou emulador limpo

Um APK de release não instala por cima de uma versão de debug, porque as assinaturas são diferentes. Desinstale antes; isso apaga a sessão anônima do aparelho, e o visitante recebe um novo `uid`:

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" uninstall com.circuitodescobertas.app
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" install mobile\build\app\outputs\flutter-apk\app-release.apk
```

O caminho completo dispensa ter o `adb` no PATH.

Aceite: o APK instala em um aparelho ou emulador limpo e repete lista, check-in, missão e eventos, com a assinatura da chave de upload.

## 5. Publicar a missão pelo painel (opcional)

O botão **Iniciar missão**, na lista de estandes, abre um modal para escolher os estandes, o início e a duração. Ele publica os quatro parâmetros da missão direto no Remote Config. O SDK web do Remote Config só lê, então o painel usa a API REST do Remote Config com a autorização de uma conta Google do projeto, pedida num pop-up. O login de administrador (e-mail e senha) continua o mesmo.

### Uma única vez

1. **Authentication → Método de login:** ativar o provedor **Google**, informando o e-mail de suporte do projeto. Continua no plano Spark.
2. Usar no pop-up a conta Google **proprietária ou editora** do projeto, a mesma que abre o console.
3. Ao publicar pelo Hosting, o domínio `<id-do-projeto>.web.app` já vem autorizado. `localhost` também.

### Ao publicar

1. Clicar em **Iniciar missão**, escolher os estandes, o início e a duração (ou **Sem prazo**) e clicar em **Publicar missão**.
2. No pop-up, escolher a conta Google do projeto e permitir o acesso. O Google pede acesso aos dados do Google Cloud (escopo `cloud-platform`): a API do Remote Config aceita esse escopo ou o `firebase.remoteconfig`, mas o segundo não pode aparecer na tela de consentimento e dá `Erro 400: invalid_scope`. O token fica só na memória da aba e não é salvo. O Google pode mostrar o aviso "O Google não verificou este app", porque o escopo é sensível e o app não passou pela verificação. Como a conta é sua e o projeto também, clique em **Avançado** e continue.
3. O aviso "Missão publicada." aparece no painel, e o app aberto mostra o banner em segundos. No console, **Remote Config → Histórico de versões** mostra a versão com a descrição "Missão publicada pelo painel".

A autorização vale por 50 minutos; depois disso, o pop-up aparece de novo. A conta Google entra em **Authentication → Usuários** como um usuário comum, sem acesso de administrador, porque não tem documento em `admins`.

Para **encerrar** a missão, desligue `missao_ativa` no console. Se o painel não conseguir publicar, os quatro valores aparecem no modal com botão de copiar, para colar no console.

| Mensagem no modal | O que fazer |
| --- | --- |
| O login com Google não está ativado | Fazer o passo 1 de "Uma única vez" |
| Essa conta Google não pode publicar no Remote Config | Entrar com a conta proprietária. Se for a proprietária, ativar a "Firebase Remote Config API" no Google Cloud Console do projeto |
| O navegador bloqueou a janela do Google | Permitir pop-ups para o endereço do painel |

A lauda pede a missão ligada e desligada pelo console. No vídeo, o roteiro continua publicando pelo console (bloco 3).
