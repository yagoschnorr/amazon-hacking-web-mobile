# Tokens e componentes — Circuito de Descobertas

Nov 11, 2026 · @Yago

## Como usar

Todos os valores abaixo saem do sistema de design Circuito de Descobertas (`tokens.json` e `components/bundle.css`) e das 21 telas do canvas: 8 do painel web (1440×900) e 13 do app Android (360×800).

- No React, gere variáveis CSS a partir dos tokens com o mesmo nome (`--primary`, `--radius-lg`…). O sistema não traz um `tokens.css` pronto: nas telas, as variáveis foram declaradas à mão em `:root`.
- As classes dos componentes usam o prefixo `cd-`.
- No Flutter, monte o `ColorScheme` à mão a partir das cores, sem `fromSeed`.
- Só tema claro.
- Valores usados nas telas que não são tokens estão marcados como **fora da escala** e reunidos na última seção.

## Cores

As telas usam 27 das 29 cores do sistema; `error-hover` e `scrim` existem, mas nenhuma tela as usa.

| Token | Hex | Uso | Onde aparece |
| --- | --- | --- | --- |
| `primary` | #0165b7 | Ação: botão primário, links, foco, item ativo | Botões do painel, “Ler QR code”, links “Voltar”, checkbox da tabela, interruptor ligado |
| `primary-hover` | #01589f | Hover do primário e de links | Painel |
| `primary-pressed` | #024a85 | Pressionado; texto forte sobre `primary-soft` | Iniciais do avatar, sobretítulo da permissão de câmera |
| `primary-soft` | #e6f0fa | Fundos de destaque claro; linha selecionada | Linhas selecionadas da tabela, ícone do card de check-ins, avatar do estande |
| `primary-deep` | #0a4e8f | Faixas institucionais grandes | Topo do app (início, detalhe, lista vazia, sem conexão) |
| `on-primary` | #ffffff | Texto e ícone sobre `primary`, `primary-deep`, `success`, `error` | Botões primários, topo do app |
| `surface-page` | #f3f6fa | Fundo de página | Painel e app |
| `surface` | #ffffff | Cartões, tabela, campos, modal, toast | Todos os cartões e campos |
| `surface-sunken` | #e9eef4 | Cabeçalho da tabela, campo desabilitado, estado inativo | Cabeçalho da tabela, código bloqueado, tela “Estande não está ativo” |
| `surface-inverse` | #111214 | Preto institucional | Barra superior do painel, lado esquerdo do login, abertura e leitor do app |
| `on-inverse` | #ffffff | Texto sobre `surface-inverse` | Mesmos lugares |
| `glow` | #06e2ff | Ciano do logo, só sobre `surface-inverse` | Traço do login e da abertura, indicador de carregamento, moldura de mira, lanterna ligada |
| `ink` | #111418 | Texto principal | Todas as telas |
| `ink-muted` | #475467 | Texto secundário, legendas, cabeçalho da tabela | Todas as telas |
| `ink-subtle` | #5f6b7a | Placeholder, desabilitado, contador | Campos vazios, botão desabilitado, contador da descrição |
| `line` | #d6dde6 | Divisórias e contorno de cartões | Cartões, tabela, rodapé fixo do app |
| `line-strong` | #7b8796 | Borda de campo e interruptor desligado | Campos de texto, divisória do topo do painel, linha da folha A4 |
| `success` | #127a3f | Sucesso, ativo, visitado | Etiqueta Ativo, selo Visitado, tela “Visita registrada” |
| `success-soft` | #e4f5eb | Fundo de sucesso | Mesmos lugares |
| `warning` | #a14a00 | Aviso | Tela “Você já registrou esta visita” |
| `warning-soft` | #fff0de | Fundo de aviso | Mesma tela |
| `error` | #c0211d | Erro e ação destrutiva | Erro de login, campo Código inválido, “QR code inválido”, sem conexão |
| `error-soft` | #fdecea | Fundo de erro | Mesmos lugares |
| `missao` | #ffb81c | Exclusiva da missão surpresa (preenchimento) | Banner, faixa do cartão, topo da tela da missão, etiqueta Missão |
| `missao-soft` | #fff5d6 | Fundo do cartão destacado pela missão | Cartão Trilha Verde com a missão ligada |
| `missao-ink` | #6e4600 | Texto e borda da missão sobre claro | Chip “Falta visitar” |
| `on-missao` | #111418 (= `ink`) | Texto e ícone sobre `missao` | Banner e topo da missão |
| `error-hover` | #a01b18 | Hover do botão Perigo | Não usado |
| `scrim` | #11141866 (`ink` a 40%) | Véu do modal | Não usado |

## Tipografia

Uma família só: **Figtree** (Google Fonts), pesos 400, 500, 600, 700 e 800. Pilha: `"Figtree", system-ui, -apple-system, "Segoe UI", sans-serif`. Contagens, tempos e códigos usam algarismos tabulares (`font-variant-numeric: tabular-nums`; no Flutter, `FontFeature.tabularFigures()`).

- Web: `https://fonts.googleapis.com/css2?family=Figtree:wght@400;500;600;700;800&display=swap`
- Flutter: pacote `google_fonts` (`GoogleFonts.figtreeTextTheme()`) ou os arquivos em `assets/fonts`

### Escala do sistema

| Estilo | Tamanho / altura de linha | Peso | Espaçamento entre letras | Uso nas telas |
| --- | --- | --- | --- | --- |
| `display` | 40px / 44px | 800 | −0,01em | Título do login, abertura do app, número do card de check-ins |
| `title-lg` | 28px / 34px | 700 | −0,005em | Título de página do painel, nome no detalhe do app |
| `title` | 22px / 28px | 700 | — | Nome do app no topo, lista vazia, sem conexão |
| `subtitle` | 18px / 24px | 600 | — | Nome do painel na barra, títulos de seção, nome do estande no cartão |
| `body-lg` | 16px / 24px | 400 | — | Corpo no app |
| `body` | 15px / 22px | 400 | — | Corpo no painel, células da tabela, descrição nos cartões do app |
| `label` | 15px / 20px | 700 | — | Botões e rótulos de campo |
| `caption` | 13px / 18px | 500 | — | Ajuda de campo, localização no cartão, legendas |
| `overline` | 12px / 16px | 700 | 0,12em, caixa alta | Sobretítulos (“CHECK-INS NO TOTAL”, “AMAZON HACKING”) |

Nenhum texto de leitura fica abaixo de 13px.

### Tamanhos internos dos componentes

| Elemento | Tamanho / altura de linha | Peso e detalhes |
| --- | --- | --- |
| Botão do painel, tamanho `sm` | 14px | 700 |
| Botão principal do app (`AppButton`) | 17px / 22px | 700 |
| Texto digitado no campo | 15px / 22px | 400 |
| “(opcional)” no rótulo | 15px | 500, `ink-muted` |
| Interruptor: rótulo / descrição | 15px / 13px (18px) | 500 / 500 |
| Etiqueta de status | 12px / 16px | 700, 0,06em, caixa alta |
| Cabeçalho da tabela | 12px / 16px | 700, 0,1em, caixa alta |
| Linha secundária da célula (`cd-sub`) | 13px / 18px | 500 |
| Toast: título / mensagem | 15px (22px) / 14px (20px) | 700 / 400 |
| Iniciais do avatar do estande | 18px | 800, 0,02em |
| Faixa “Missão surpresa” no cartão | 12px / 16px; tempo 13px | 800, 0,1em, caixa alta; tempo 700 |
| Selo “Visitado às 10h42” | 13px / 18px | 700 |
| Banner da missão: sobretítulo / título / mensagem / tempo | 12px (16px) / 22px (28px) / 16px (24px) / 14px (20px) | 800 0,12em / 800 / 400 / 700 |
| Tela de retorno: sobretítulo / título / mensagem / detalhe | 12px (16px) / 28px (34px) / 16px (24px) / 14px (20px) | 800 0,12em / 800 −0,005em / 400 / 600 |

### Tamanhos fora da escala usados nas telas

| Onde | Tamanho / altura de linha | Peso |
| --- | --- | --- |
| QR em tela cheia: nome do estande | 64px / 68px | 800, −0,015em |
| Folha A4: nome do estande | 72px / 76px | 800, −0,015em |
| Folha A4: sobretítulo | 14px / 18px | 700, 0,12em, caixa alta |
| Folha A4: localização | 24px / 30px | 700 |
| QR (tela e A4): descrição | 20px / 28px | 400 |
| QR (tela e A4): instrução de leitura; detalhe do app: descrição | 18px / 26px | 500 / 400 |
| QR em tela cheia: chips de código e local | 18px / 24px | 700 / 600 |
| Alerta de erro do login: texto de apoio | 14px / 20px | 400 |
| Chip de tempo na tela da missão | 14px / 20px | 700 |
| Avatar grande no detalhe do app | 22px | 800 |

## Ícones

**Material Symbols Rounded**, eixos `wght` 500, `GRAD` 0, `opsz` 24, `FILL` 0. `FILL` 1 só em ícones de estado: `check_circle`, `error`, `bolt`, `pause_circle`. A cor vem do texto ao lado, e o ícone sempre acompanha texto ou `aria-label`.

- Web: `https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,400..600,0..1,0&display=block`
- Flutter: pacote `material_symbols_icons` (`Symbols.*`, `weight: 500`)

| Tamanho | Onde |
| --- | --- |
| 16px | Etiquetas de status, erro de campo, localização no cartão, chip “Falta visitar” |
| 18px | Faixa da missão, selo Visitado, tempo da missão, linha de progresso no topo do app |
| 20px | Padrão: botões do painel, campos, ações da tabela |
| 22px | Alerta de erro do login, chips da tela de QR |
| 24px | Botão principal do app, voltar e fechar no app |
| 26px | Ícone do banner da missão |
| 28px | Card de check-ins, avatar “visitado”, lanterna, instruções do QR |
| 32px | Instrução na folha A4 |
| 36px | Lista vazia do painel |
| 48px | Lista vazia e sem conexão no app |
| 64px | Telas de retorno e de permissão |

Ícones usados: `account_circle`, `add`, `arrow_back`, `bolt`, `check`, `check_circle`, `chevron_right`, `close`, `content_copy`, `edit`, `error`, `flashlight_off`, `flashlight_on`, `history`, `how_to_reg`, `location_on`, `lock`, `login`, `logout`, `mail`, `no_photography`, `pause_circle`, `play_circle`, `print`, `qr_code_2`, `qr_code_scanner`, `radio_button_unchecked`, `refresh`, `schedule`, `settings`, `storefront`, `wifi_off`.

## Espaçamento

Grade de 4px. Componentes usam múltiplos de 4; o layout usa 16, 24, 32 e 48.

| Token | Valor | Uso |
| --- | --- | --- |
| `space-1` | 4px | Entre ícone e texto pequeno |
| `space-2` | 8px | Entre ícone e rótulo do botão; entre rótulo e campo |
| `space-3` | 12px | Entre itens de uma linha; padding vertical da célula; entre cartões do app |
| `space-4` | 16px | Margem lateral do app; padding horizontal da célula; padding do cartão do app |
| `space-5` | 20px | Padding horizontal do botão médio |
| `space-6` | 24px | Padding de cartão e modal no painel; entre campos de um formulário |
| `space-8` | 32px | Entre seções de uma página; padding do cartão de formulário |
| `space-12` | 48px | Margem lateral do painel; padding do cartão de login; topo das telas de retorno |
| `space-16` | 64px | Padding inferior do conteúdo do painel |

Layout do painel: conteúdo com largura máxima de 1344px, centralizado, margem lateral de 48px. Formulário com largura máxima de 760px e painel lateral de 340px.

**Fora da escala usados nas telas:** 2px (entre linhas de texto empilhadas), 6px (entre ícone e texto em etiquetas e no topo do app), 10px e 14px (padding horizontal de etiquetas e do chip de tempo), 28px (padding superior do topo do app), 40px (respiros do login, da abertura e da folha A4), 56px (padding do lado escuro do login e espaço entre QR e texto na tela cheia) e 72px (margem da folha A4, 0,75 pol.).

## Raios, bordas e sombras

### Raios

| Token | Valor | Onde |
| --- | --- | --- |
| `radius-sm` | 8px | QR dentro da mira do leitor |
| `radius-md` | 12px | Campos de texto, toast, avatar do estande, alerta do login, caixa da prévia do QR |
| `radius-lg` | 20px | Cartões do painel e do app, tabela, banner da missão, cantos da mira |
| `radius-xl` | 28px | Cantos inferiores da barra do painel e do topo do app, folha do QR em tela cheia, modal |
| `radius-full` | 9999px | Botões, etiquetas, chips, interruptor, barra de progresso, círculos de ícone |

### Bordas

| Espessura e cor | Onde |
| --- | --- |
| 1px `line` | Contorno de cartões e tabela, divisórias, linhas da tabela |
| 1,5px `line-strong` | Campos de texto (foco: `primary`; erro: `error`) |
| 1,5px `primary` | Botão secundário |
| 1,5px `missao-ink` | Chip “Falta visitar” |
| 1px `error` | Alerta de erro do login |
| 2px `line-strong` | Trilho do interruptor desligado |
| 2px `missao` | Cartão destacado pela missão |
| 4px `glow` | Cantos da moldura de mira (48×48px, raio 20px) |

### Sombras

| Token | Valor | Onde |
| --- | --- | --- |
| `shadow-sm` | `0 1px 2px #1114180f, 0 1px 3px #1114180a` | Cartões em repouso, tabela, card de login |
| `shadow-md` | `0 4px 12px #11141814` | Barra superior do painel, banner e cartão da missão, botão principal do app |
| `shadow-lg` | `0 12px 32px #11141829` | Toast e modal |
| `focus-ring` | `0 0 0 2px #ffffff, 0 0 0 4px #0165b7` | Foco por teclado em todo elemento interativo |

Anéis e contornos internos dos componentes:

- Campo em foco: `0 0 0 3px` `primary-soft`; com erro: `0 0 0 3px` `error-soft`
- Botão Perigo em foco: `0 0 0 2px` `surface`, `0 0 0 4px` `error`
- Botão do app `tonal`: `inset 0 0 0 1.5px` `primary`
- Botão Missão em hover: `inset 0 0 0 1.5px` `missao-ink`
- Botão do banner em foco: `0 0 0 2px` `missao`, `0 0 0 4px` `ink`

Sem desfoque de fundo, sem gradiente e sem brilho.

## Alturas e alvos de toque

| Token | Valor | Onde |
| --- | --- | --- |
| `control-sm` | 36px | Botão `sm` e botões de ícone nas linhas da tabela, botão Sair |
| `control-md` | 44px | Botão, campo de texto e interruptor do painel; links “Voltar” |
| `control-lg` | 56px | Botão principal do app (`AppButton`) |
| `touch-min` | 48px | Menor área tocável no app: voltar, fechar, botão do banner |

Outras medidas fixas: interruptor 52×32px (polegar de 16px desligado, 24px ligado); etiqueta de status com 26px de altura; avatar do estande 52px (64px no detalhe); botão da lanterna 64px; círculo das telas de retorno 112px; checkbox da tabela 18px.

## Componentes do sistema

Os 14 componentes estão em `window.Circuito` como referência visual; no projeto, reimplemente-os em TypeScript na pasta compartilhada de UI. “Não usado” indica uma variação do sistema que nenhuma tela mostra.

### Painel web

| Componente | Variações e props | Onde aparece |
| --- | --- | --- |
| `Button` | `variant`: `primary`, `secondary`, `danger` (não usado), `missao` (não usado) · `size`: `md` 44px, `sm` 36px · `icon` opcional · `disabled` | Entrar, Novo estande, Salvar, Cancelar, Copiar IDs da missão (normal e desabilitado), Sair e Ativar/Inativar (`sm`), Imprimir |
| `IconButton` | 36px · `icon` + `label` (vira `aria-label`) · `tone`: `default`, `danger` (não usado) | Editar e Ver QR code na tabela |
| `TextField` | `label`, `hint`, `error`, `icon` à esquerda, `optional`, `disabled` | Login (e-mail, senha); formulário: código com erro, código bloqueado com `lock`, localização com `location_on` |
| `TextArea` | `label`, `hint`, `error`, `maxLength` (mostra contador), `rows` | Descrição breve (80 caracteres, 3 linhas) |
| `Switch` | `label`, `description`, `checked`/`defaultChecked`, `disabled`; ligado mostra `check` no polegar | Estande ativo |
| `StatusTag` | `status`: `ativo` (`check_circle`), `inativo` (`pause_circle`), `missao` (`bolt`) | Tabela de estandes; `missao` no cartão Maré Viva do app |
| `DataTable` | `columns`, `rows`, `selectedId`, `caption`, `empty` | Montada com as classes `cd-table` para permitir várias linhas selecionadas (o componente aceita só uma) |
| `Toast` | `tone`: `success`, `error`, `warning`, `info`, `missao` · `title`, `message`, `actionLabel`, `onClose` | “IDs copiados.” (`success`), canto inferior direito |
| `Modal` | `tone`: `default`, `danger`, `missao` · `title`, `actions`, `icon` | Não usado |

### App Android

| Componente | Variações e props | Onde aparece |
| --- | --- | --- |
| `StandCard` | `state`: `normal`, `missao` (faixa amarela, fundo `missao-soft`, borda 2px), `visitado` (avatar com `check`, selo verde) | Início, início com missão, tela da missão. Montado com as classes `cd-stand` para incluir a descrição, que o componente não tem |
| `MissionBanner` | `title`, `message`, `timeLeft`, `actionLabel` | Início com missão |
| `AppButton` | `variant`: `primary`, `tonal` · `icon` · `disabled` | “Ler QR code” fixo no rodapé, Abrir configurações, Atualizar lista, Tentar de novo, Voltar ao início (`tonal`) |
| `FeedbackScreen` | `kind`: `sucesso`, `aviso`, `erro`, `missao` (não usado) · `eyebrow`, `title`, `message`, `detail`, botões primário e secundário | Visita registrada, QR code inválido, já registrou esta visita |
| `Icon` | `name`, `fill`, `size` | Todas as telas |

### Os quatro retornos da leitura

| Tela | Cor (fundo do círculo / ícone) | Ícone | Sobretítulo |
| --- | --- | --- | --- |
| Visita registrada | `success-soft` / `success` | `check_circle` preenchido | Check-in feito |
| QR code inválido | `error-soft` / `error` | `qr_code_scanner` | Não reconhecido |
| Estande não está ativo | `surface-sunken` / `ink-muted` | `pause_circle` preenchido | Estande inativo |
| Já registrou esta visita | `warning-soft` / `warning` | `history` preenchido | Já registrado |

## Padrões montados nas telas

Estes padrões não existem como componentes no sistema. Foram montados com os tokens acima e valem como candidatos a componentes compartilhados.

| Padrão | Composição | Telas |
| --- | --- | --- |
| Barra superior do painel | `surface-inverse`, cantos inferiores `radius-xl`, `shadow-md`, padding 16px 48px; logo do Amazon Hacking com 36px de altura, divisória de 1px `line-strong`, nome em `subtitle`; e-mail do admin + Sair (`Button` `secondary` `sm`) | Lista, lista vazia, novo, editar |
| Lado institucional do login | `surface-inverse`, padding 56px 64px, logo com 40px, traço `glow` 40×4px, `overline` + `display` + `body-lg` | Login e login com erro |
| Alerta de erro inline | `error-soft`, borda 1px `error`, `radius-md`, padding 16px; ícone `error` preenchido de 22px; título em 700 `error` e texto de apoio em 14/20 `ink`; `role="alert"` | Login com erro |
| Card de indicador | `surface`, borda `line`, `radius-lg`, `shadow-sm`, padding 24px; ícone de 28px em quadrado de 56px `primary-soft`; `overline` + número em `display` tabular + `caption` | Lista e lista vazia |
| Estado vazio da tabela | Círculo de 72px `primary-soft` com `storefront` de 36px; frase em `subtitle`, apoio em `body`, `Button` `primary` | Lista vazia do painel |
| Topo do app | `primary-deep`, cantos inferiores `radius-xl`, padding 28px 16px 20px; `overline` “AMAZON HACKING”, nome em `title`, progresso em 15/22 com `check_circle` | Início, início com missão, lista vazia, sem conexão |
| Topo da missão | `missao`, `shadow-md`; título 28/34 800; chip de tempo `ink` com texto `missao` (36px); barra de progresso de 8px (trilho `surface`, preenchimento `ink`) | Tela da missão |
| Rodapé fixo do app | `surface-page`, borda superior 1px `line`, padding 12px 16px 16px, com o `AppButton` | Telas com lista e detalhe |
| Chip “Falta visitar” | 26px de altura, borda 1,5px `missao-ink`, texto 13/18 700 `missao-ink`, ícone `radio_button_unchecked` de 16px | Tela da missão |
| Leitor de QR | Fundo `surface-inverse`; mira de 256px com 4 cantos de 48px, borda 4px `glow`, raio 20px; botão redondo de 64px para a lanterna (`surface` desligada, `glow` ligada, `aria-pressed`) | Leitor |
| Indicador de carregamento | Anel de 40px, traço de 4px, arco em `glow`, rotação de 0,9s (2,4s com movimento reduzido) | Abertura |
| Folha de QR | QR com zona de silêncio de 4 módulos, `#111418` sobre branco; 480px na tela, 500px (cerca de 13 cm) na A4; margens de 72px | QR em tela cheia e A4 |

## Exceções e pendências

Oito pontos precisam de decisão antes da implementação: dois de cor, quatro de componentes, um de texto e um de conteúdo.

- [x] **Cor fora dos tokens:** o trilho do indicador de carregamento usa `#2a2d32`. Trocar por um token ou criar um, como `line-inverse`. Decisão (M3): criado o token `line-inverse` (`#2a2d32`), em `AppCores.lineInverse` no app.
- [ ] **Hex fixos que equivalem a tokens:** o checkbox da tabela usa `accent-color: #0165b7` (= `primary`) e a lanterna usa `#06e2ff` (= `glow`) e `#ffffff` (= `surface`). No código, ler as variáveis.
- [ ] **`FeedbackScreen`** tem 320×600px fixos, com borda e raio. Nas telas, foi esticado para 360×800, sem borda e com padding de 48px 16px 16px. Falta um modo de tela cheia no componente.
- [ ] **`FeedbackScreen`** não tem o tipo “estande inativo”. A tela foi montada com as classes do componente (círculo `surface-sunken`, ícone `pause_circle`). Sugestão: `kind="inativo"`.
- [ ] **`StandCard`** não tem descrição nem a combinação “visitado + Missão”. Sugestão: props `description` e `badges`.
- [ ] **`DataTable`** aceita só uma linha selecionada (`selectedId`). A lista precisa de seleção múltipla para “Copiar IDs da missão”.
- [ ] **Descrição nos cartões do app** está em `body` (15/22), estilo do painel. O sistema indica `body-lg` (16/24) para o app.
- [ ] **QR code de exemplo** codifica só o texto “E01”. Definir o conteúdo real que o app vai ler.

Sem pendência, por regra do sistema: o logo do Amazon Hacking aparece só sobre `surface-inverse`, por isso fica fora da folha A4; e “Circuito de Descobertas” é sempre texto em Figtree, sem logotipo.
