# Roteiro do vídeo — Circuito de Descobertas

O vídeo segue os quatro passos da lauda (página 4) e mostra a evidência de cada critério da avaliação. Cada bloco diz qual serviço aparece na tela e tem um responsável, porque a lauda exige que cada integrante apareça ou narre uma parte identificável.

Duração estimada: de 10 a 12 minutos, sem contar pausas para esperar o Analytics.

## Divisão entre os integrantes

Troque os nomes antes de gravar. Em equipe de dois, o Integrante 2 também narra o bloco 4; individualmente, uma pessoa narra tudo.

| Bloco | Conteúdo | Critério | Responsável |
| --- | --- | --- | --- |
| 1 | Apresentação e instalação pelo App Distribution | App Distribution (1,0) | Integrante 1 |
| 2 | Estande novo no painel, no app e com QR code | Demonstração integrada (0,5) | Integrante 2 |
| 3 | Missão pelo Remote Config, check-in e total no painel | Remote Config (1,0) e demonstração integrada | Integrante 2 |
| 4 | Eventos no Tempo real do GA4 | Analytics (1,0) e demonstração integrada | Integrante 3 |

## Preparação (antes de gravar)

### Dados
- [ ] Os estandes fictícios `E01` (Maré Viva), `E02` (Trilha Verde) e `E03` (Farinha Digital) estão cadastrados e ativos ([contrato de dados](contrato-de-dados.md)).
- [ ] O estande do vídeo, `E04`, **ainda não existe**. Ele é criado ao vivo no bloco 2.
- [ ] Não ensaie com o código `E04`: as regras do Firestore não deixam apagar estandes. No ensaio, use outro código, por exemplo `E09`, e inative esse estande depois.

### Firebase
- [ ] **Remote Config** publicado com `missao_ativa = false`. Os outros parâmetros podem ficar como estão; eles são alterados no bloco 3.
- [ ] **App Distribution** com a versão de release mais recente (1.0.1 (2) ou maior) enviada. Para gravar o convite chegando, use como testador o e-mail de alguém que **ainda não foi convidado**, por exemplo outro integrante.
- [ ] Abas abertas no navegador: App Distribution, Remote Config e Analytics → Relatórios → Tempo real.

### Celular do testador
- [ ] App **desinstalado**, para a instalação aparecer no vídeo.
- [ ] Modo de depuração do Analytics desligado (a lauda pede o app como visitante comum). Com o celular no cabo, na pasta `mobile`:
  ```powershell
  & "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" shell setprop debug.firebase.analytics.app .none.
  ```
- [ ] Modo **Não perturbe** ligado, bateria carregada e Wi-Fi conectado.
- [ ] Tela espelhada no PC com `scrcpy --stay-awake`, para o celular aparecer na mesma gravação.

### PC
- [ ] Painel aberto e logado (`npm run dev` em `web/` ou o endereço do Hosting).
- [ ] Gravador capturando a tela inteira, com o navegador e a janela do scrcpy lado a lado (por exemplo, OBS Studio).
- [ ] Brilho do monitor alto, para o celular ler o QR na tela.

## Bloco 1 — App Distribution (Integrante 1)

**Serviço em tela:** Firebase App Distribution.

| # | Tela | Ação | Resultado esperado |
| --- | --- | --- | --- |
| 1.1 | Câmera ou slide | Cada integrante se apresenta | Nomes de todos no início do vídeo |
| 1.2 | Terminal | Rodar `apksigner verify --print-certs` no `app-release.apk` ([guia, seção 4](guia-firebase.md)) | Certificado da chave de upload, não `Android Debug`: o APK é assinado |
| 1.3 | Console → App Distribution | Mostrar a versão enviada (ou arrastar o APK agora) | Versão 1.0.1 (2) na lista de versões |
| 1.4 | Console → App Distribution | Em Testadores e grupos, adicionar o e-mail do testador e clicar em **Distribuir** | Testador com convite enviado |
| 1.5 | Celular | Abrir o e-mail de convite, tocar em **Começar** e aceitar com a conta Google convidada | Página da versão no celular |
| 1.6 | Celular | Tocar em **Baixar** e depois em **Instalar** (permitir apps desconhecidos, se o Android pedir) | App instalado |
| 1.7 | Celular | Abrir o app | Abertura escura e, em seguida, a lista de estandes **sem missão** |
| 1.8 | Console → App Distribution | Atualizar a página de testadores | Convite aceito e download feito |

Fala sugerida: "Geramos o APK assinado, enviamos pelo Firebase App Distribution e convidamos um testador. No celular dele, o convite chega por e-mail, ele aceita, baixa, instala e abre o app. Não passamos pela Google Play."

## Bloco 2 — Estande novo do painel ao app (Integrante 2)

**Serviços em tela:** Firebase Authentication (login da organização) e Cloud Firestore (dados em tempo real).

| # | Tela | Ação | Resultado esperado |
| --- | --- | --- | --- |
| 2.1 | Painel | Mostrar que o painel está logado com a conta da organização (ou fazer o login) | Lista de estandes com os totais |
| 2.2 | Painel | **Novo estande** com Código `E04`, Nome `Castanha em Rede`, Descrição breve `Cooperativa que vende óleos de castanha pela internet`, Localização `Corredor B, estande 4` e **Estande ativo** ligado; **Salvar estande** | `E04` na lista do painel, com 0 check-ins |
| 2.3 | Celular | Só olhar para o app, sem tocar | O cartão Castanha em Rede aparece sozinho, sem reiniciar |
| 2.4 | Painel | Abrir **Ver QR code** do `E04` em tela cheia | QR code do estande gerado a partir do código |

Fala sugerida: "O administrador entra com e-mail e senha pelo Firebase Authentication. O estande salvo no Cloud Firestore aparece no app do visitante em tempo real. O painel gera o QR code do estande a partir do código, e ele pode ser impresso ou aberto em tela cheia."

## Bloco 3 — Missão pelo Remote Config e check-in (Integrante 2)

**Serviços em tela:** Firebase Remote Config, Cloud Firestore e o painel.

| # | Tela | Ação | Resultado esperado |
| --- | --- | --- | --- |
| 3.1 | Celular | Mostrar a lista normal | Sem banner da missão (missão desligada) |
| 3.2 | Painel | Selecionar `E02` e `E04` e clicar em **Copiar IDs da missão** | Aviso "IDs copiados." com `["E02","E04"]` |
| 3.3 | Console → Remote Config | `missao_ativa` = `true`; colar em `missao_estandes_ids`; se quiser a contagem, `missao_inicio` com o horário atual (ex.: `2026-11-20T15:00:00-03:00`) e `missao_duracao_min` = `30`; **Publicar alterações** | Publicação confirmada no console |
| 3.4 | Celular | Só olhar para o app | Em segundos aparecem o banner "Missão surpresa" e as faixas amarelas em Trilha Verde e Castanha em Rede, **no mesmo APK, sem reinstalar** |
| 3.5 | Celular | Tocar em **Ver missão** | Tela da missão com os estandes participantes (evento `missao_aberta`) |
| 3.6 | Celular | **Ler QR code** e apontar para o QR do `E04` na tela do PC | "Visita registrada." com o chip Castanha em Rede (evento `checkin_concluido`) |
| 3.7 | Painel | Olhar a lista, sem recarregar | Check-ins do `E04` passam de 0 para 1 e o total geral sobe |
| 3.8 | Celular | Ler o mesmo QR de novo (opcional) | "Você já registrou esta visita.": uma visita por estande |
| 3.9 | Console → Remote Config | `missao_ativa` = `false`; **Publicar alterações** | Publicação confirmada |
| 3.10 | Celular | Voltar ao início e olhar o app | Banner e faixas somem. A lista continua e **Ler QR code** segue funcionando |

Fala sugerida: "No console do Remote Config ligamos a missão e escolhemos os estandes. O app instalado reage em tempo real, sem recompilar nem reinstalar. O visitante abre a missão, lê o QR code e o check-in é gravado no Firestore; o painel soma a visita na hora. Ao desligar a missão no console, o app volta à lista normal."

Se a tela da missão estiver aberta quando a missão for desligada, o app volta sozinho ao início com o aviso "Missão encerrada". Também serve como demonstração.

## Bloco 4 — Eventos no Google Analytics (Integrante 3)

**Serviço em tela:** Google Analytics para Firebase (relatório Tempo real do GA4).

| # | Tela | Ação | Resultado esperado |
| --- | --- | --- | --- |
| 4.1 | Console → Analytics → Relatórios → Tempo real | Abrir o relatório | Usuários nos últimos 30 minutos |
| 4.2 | Tempo real | No cartão **Contagem de eventos por nome do evento**, mostrar os eventos | `missao_aberta` e `checkin_concluido` na lista |
| 4.3 | Tempo real | Clicar em `checkin_concluido` e depois no parâmetro `estande_id` | Valor `E04`, o estande lido no bloco 3 |
| 4.4 | Painel e celular | Fechar o percurso | Estande criado no painel → aparece no app → check-in → total no painel → evento no Analytics |

Fala sugerida: "No relatório Tempo real do GA4 aparecem os dois eventos que o app registrou: `missao_aberta`, quando o visitante abriu a missão, e `checkin_concluido`, depois da gravação do check-in. Abrindo o check-in, o parâmetro `estande_id` mostra `E04`, o estande que cadastramos no começo."

Se os eventos ainda não tiverem aparecido, pause a gravação e retome quando surgirem; a lauda permite. O Tempo real mostra só os últimos 30 minutos, então grave este bloco logo depois do bloco 3.

## Cobertura dos critérios

| Critério | Valor | Onde aparece |
| --- | --- | --- |
| Firebase App Distribution | 1,0 | 1.2 (APK assinado), 1.3 e 1.4 (versão e testador), 1.5 a 1.7 (convite, instalação e abertura), 1.8 (status no console) |
| Firebase Remote Config | 1,0 | 3.1 (desligada), 3.3 (publicação), 3.4 (missão no mesmo app), 3.9 e 3.10 (desativação e volta à lista) |
| Google Analytics para Firebase | 1,0 | 3.5 e 3.6 (eventos gerados), 4.2 (os dois eventos no Tempo real), 4.3 (`estande_id`) |
| Demonstração integrada | 0,5 | 2.2 e 2.3 (painel → app), 3.6 e 3.7 (check-in → total no painel), 4.3 e 4.4 (evento no Analytics) |

Requisitos complementares que o percurso também mostra: login da organização (2.1), QR code do estande (2.4), retorno de visita já registrada (3.8) e lista e check-in disponíveis com a missão desligada (3.10).

## Plano B

| Problema | O que fazer |
| --- | --- |
| E-mail de convite não chega | Procurar no spam ou em Promoções. No console, reenviar o convite pela linha do testador |
| Celular não instala | Permitir que o navegador instale apps desconhecidos (Configurações → Apps → Acesso especial) |
| Banner demora a aparecer | Manter o app em primeiro plano, porque a atualização em tempo real só funciona assim. Se passar de um minuto, feche e abra o app |
| Leitor não pega o QR | Aumentar o brilho do monitor ou usar a folha impressa (**Imprimir** no painel) |
| Eventos não aparecem no Tempo real | Pausar a gravação e esperar alguns minutos. Conferir se o modo de depuração foi desligado (preparação) |
