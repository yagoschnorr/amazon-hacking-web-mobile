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
