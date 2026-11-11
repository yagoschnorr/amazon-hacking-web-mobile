# Contrato de dados — Circuito de Descobertas

Fonte única para o painel web e o app mobile. Copiado da seção 5 do [plano de implementação](plano-de-implementacao.md). Nomes de coleções, campos, parâmetros do Remote Config e eventos do Analytics não mudam sem acordo prévio.

## Coleções do Firestore

| Coleção | ID do documento | Campos |
| --- | --- | --- |
| `estandes` | Código curto digitado pelo admin, por exemplo `E03`. Formato `^[A-Z0-9]{2,12}$`. Imutável depois de criado | `nome` (string), `descricao` (string), `localizacao` (string), `ativo` (boolean), `criadoEm` (timestamp), `atualizadoEm` (timestamp) |
| `checkins` | `{visitanteId}_{estandeId}` | `visitanteId` (string, uid anônimo), `estandeId` (string), `criadoEm` (timestamp do servidor) |
| `admins` | `uid` do administrador | `email` (string). Criado à mão no console |

O código curto como ID do estande é uma decisão de projeto. Ele é fácil de digitar no Remote Config e aparece legível no GA4 como `estande_id: E03`, igual ao exemplo da lauda.

O ID composto do check-in garante uma visita por visitante e por estande. Um segundo check-in no mesmo estande teria o mesmo ID, e as regras não permitem alterar um check-in existente.

## Conteúdo do QR code

O QR carrega o texto `circuito-descobertas:estande:{estandeId}`, por exemplo `circuito-descobertas:estande:E03`. Qualquer leitura fora desse formato é tratada como QR inválido, sem consultar o Firestore.

## Regras de acesso

| Quem | Pode | Não pode |
| --- | --- | --- |
| Administrador | Ler, criar e editar estandes. Ler todos os check-ins | Apagar estandes ou check-ins |
| Visitante (anônimo) | Ler estandes ativos. Criar check-in com o próprio uid em estande ativo. Ler os próprios check-ins | Ler estandes inativos, alterar estandes, ler check-ins de outros, alterar ou apagar check-ins |
| Não autenticado | Nada | Tudo |

As regras implementadas estão em [`firestore.rules`](../firestore.rules), na raiz do repositório. Elas foram validadas no emulador local do Firestore com os 13 cenários da etapa F1 (ver [guia do Firebase](guia-firebase.md)).

Detalhes que valem para o código:

- Escrita de estande aceita apenas os campos `nome`, `descricao`, `localizacao`, `ativo`, `criadoEm` e `atualizadoEm`. `nome` não pode ser vazio.
- Check-in aceita apenas `visitanteId`, `estandeId` e `criadoEm`, e `criadoEm` precisa ser `serverTimestamp()`. Data gerada no cliente é recusada.

Consequência para o app: ao ler `estandes/{id}`, documento inexistente significa QR inválido e erro `permission-denied` significa estande inativo.

Consequência para as consultas: o app lista estandes com `where('ativo', '==', true)` e ordena no cliente, para não exigir índice composto. A lista dos check-ins do visitante usa `where('visitanteId', '==', uid)`. Uma consulta sem esses filtros é negada para o visitante.

## Remote Config

| Parâmetro | Tipo | Padrão local no app | Exemplo publicado |
| --- | --- | --- | --- |
| `missao_ativa` | Boolean | `false` | `true` |
| `missao_estandes_ids` | JSON | `[]` | `["E02","E03"]` |

O app destaca apenas a interseção entre `missao_estandes_ids` e os estandes ativos. JSON malformado é tratado como lista vazia.

## Eventos do Analytics

| Evento | Quando dispara | Parâmetros |
| --- | --- | --- |
| `missao_aberta` | O visitante abre a tela da missão | nenhum |
| `checkin_concluido` | Logo após a gravação do check-in ser confirmada | `estande_id` (string, código do estande) |

Os eventos saem apenas do app mobile. O painel web não envia eventos.

## Estandes fictícios sugeridos

| Código | Nome | Descrição | Localização |
| --- | --- | --- | --- |
| `E01` | Maré Viva | Alerta de marés para travessias ribeirinhas | Corredor A, estande 1 |
| `E02` | Trilha Verde | Rastreio de mudas em sistemas agroflorestais | Corredor C, estande 7 |
| `E03` | Farinha Digital | Vitrine online para produtores de farinha | Corredor D, estande 12 |

Os três são cadastrados pelo próprio painel. `E02` e `E03` ficam longe da entrada e servem como estandes da missão.
