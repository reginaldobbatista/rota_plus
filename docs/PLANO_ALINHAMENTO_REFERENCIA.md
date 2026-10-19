# Plano de alinhamento com a referência (Rota Pro v1.1.60)

> **Status:** análise **completa**. As 122 capturas de `docs/imagens/` foram
> revisadas uma a uma (121 telas únicas — uma duplicata exata). Este documento
> substitui a versão anterior, que cobria só 11 capturas.
>
> **Nada foi implementado ainda.** Este é o passo a passo a aprovar antes de
> qualquer mudança de código. Há **uma decisão sua pendente** (§5).

---

## 1. Veredicto sobre o que já existe

O núcleo está certo. A superfície e parte do modelo de dados estão divergentes.

| Camada | Situação |
|---|---|
| Cálculo (custo/km, R$/km, R$/hora, lucro) | ✅ Correto e testado. Não muda |
| Local-first (Drift + outbox + sync) | ✅ Correto. Não muda |
| Backend (RLS, RPCs, cron, 9 migrations) | ✅ Correto. Precisa de **acréscimos**, não correções |
| Captura e overlay (Kotlin) | ✅ Estrutura correta. Parser precisa de **muito mais campos** |
| **Modelo de metas / faixas** | ❌ Conceitualmente diferente — §2.1 |
| **Categorias de despesa e receita** | ❌ Enum fixo vs. tabela configurável — §2.2 |
| **Plataformas** | ❌ Enum de 3 vs. catálogo de 17 + livres — §2.3 |
| **Ciclo financeiro (semana/mês/virada do dia)** | ❌ Não existe. É fundação, não enfeite — §2.4 |
| **Entrada do custo por km** | ❌ Fricção alta demais — §2.5 |
| **Modelo de meta financeira** | ❌ Rígido demais — §2.6 |
| **Fluxo de conta** | ❌ Não existe no início do app — §5 |
| Navegação e nomenclatura | ⚠️ Divergente — §3 |
| ~20 telas e sub-sistemas | ❌ Inexistentes — §4 |

Nada precisa ser jogado fora. É **acréscimo e reescrita de superfície** sobre
uma base que se sustenta.

---

## 2. Divergências estruturais de dados

Estas são as que **custam caro se deixadas para depois**: mudam tabela local,
tabela remota, migration, mapper e caso de uso. Vêm primeiro.

### 2.1 Faixas explícitas, não meta + tolerância

**Hoje:** uma meta por métrica (`goal_rs_per_km`) e uma tolerância global
(`think_tolerance_pct`). O amarelo é derivado: `meta × (1 − tolerância)`.

**Referência:** duas fronteiras explícitas por métrica, editadas diretamente —
nos rótulos **"RUIM ABAIXO DE"** e **"BOM ACIMA DE"**, com slider de dois
polegares (Ruim ← → Bom) e edição numérica ao lado.

| Métrica | Ruim | Atenção | Aceitar | Faixa válida |
|---|---|---|---|---|
| Ganho por km | < 1,40 | 1,40 – 1,55 | ≥ 1,55 | R$ 0,50 – R$ 5,00 |
| Ganho por hora | < 30 | 30 – 40 | ≥ 40 | R$ 10 – R$ 100 |
| **Nota do passageiro** | < 4,50 | 4,50 – 4,90 | ≥ 4,90 | ★ 3,00 – ★ 5,00 |

**A terceira métrica não existe no meu app.** A nota do passageiro é critério
de veredicto na referência, com peso igual às outras duas.

**Por que a referência é melhor:** o motorista vê e edita exatamente o número
que decide. Com tolerância percentual ele define 2,00 e o app recusa a 1,69 por
uma conta que ele não enxerga. É opacidade num app que decide dinheiro.

**Impacto:** `goal_rs_per_km` + `think_tolerance_pct` → `*_bad_below` +
`*_good_above` nas **três** métricas. Entidade, tabela local, tabela remota,
`EvaluateRide` e a tela de perfis.

### 2.2 Categorias são dados, não enum

**Hoje:** `enum ExpenseCategory` com 9 valores fixos. Receita não tem categoria.

**Referência:** tela **Categorias** com dois grupos editáveis.

- **Despesa (12):** Combustível\*, Alimentação, Manutenção\*, Lavagem, Pedágio,
  Seguro, Financiamento, Aluguel do veículo, Celular, Estacionamento, Multa,
  Outros\* — mais "Adicionar categoria".
- **Receita (4):** Corridas\*, Bônus, Gorjeta, Outros — mais "Adicionar".

`*` = *Sempre ligada*, não desativável. As demais têm interruptor. O ícone é
trocável tocando nele. Regra explícita da tela: *"Desligar só tira a categoria
das opções — o que já foi lançado fica igual. Excluir (as suas) passa os
lançamentos para 'Outros'."*

**Impacto:** tabelas `expense_categories` e `income_categories` (ou uma só com
discriminador), com seed das padrão, `is_system`, `is_enabled`, `icon`,
`sort_order`. `expenses.category` vira FK. Mesma coisa no Postgres.

### 2.3 Plataformas são catálogo, não enum de três

**Hoje:** `enum Platform { uber, noventaNove, inDrive }`.

**Referência:** duas listas distintas, e a tela avisa que **não são a mesma
coisa**:

- **Plataformas (Finanças):** só para lançamento financeiro. Catálogo de 17 —
  Uber, 99, inDrive, iFood, Keeta, Particular, Rappi, Amazon, Shopee, Loggi,
  Lalamove, Buser, BlaBlaCar, AiqFome, Zé Delivery, Moovit, Mercado Livre —
  mais **"Nova plataforma"** de nome livre. Tem seção **"EM USO — ORDEM"** com
  reordenação manual, que define a ordem dos cartões do *Fechar o dia* e dos
  botões de receita.
- **Apps do Semáforo:** só Uber, 99, inDrive, **iFood (BETA)** e
  **Keeta (BETA)** — os que a leitura de tela suporta.

A tela diz, literalmente: *"Ligar ou desligar aqui não muda os apps que o
Semáforo lê"* e *"Corridas lidas de uma plataforma desligada continuam virando
sugestão"*.

**Impacto:** tabela `platforms` com seed, `is_enabled`, `sort_order`,
`is_custom`, separada da lista de pacotes monitorados do
`accessibility_config.xml` — que **continua fechada** por segurança.

### 2.4 Ciclo financeiro configurável — fundação ausente

A tela **Configurações de Finanças → META E CICLO** define quatro coisas que
atravessam todo o agregado financeiro e que hoje eu assumo como fixas:

| Ajuste | Opções | Efeito |
|---|---|---|
| A semana começa em | Seg … Dom | Todo agrupamento semanal |
| Dias de trabalho | chips Seg–Dom | Meta por dia; dias de folga saem da conta |
| O mês começa no dia | Dia 1 … 31 | Fecha no dia do pagamento; o **ano** começa no mesmo dia de janeiro |
| **Virada do dia** | Meia-noite \| **4h (como a Uber)** | O que acontece até 3h59 conta no dia anterior |

A virada às 4h é a mais séria: muda a qual dia pertence um lançamento, uma
corrida e uma sessão de jornada. A tela ressalva que *"lançamentos já feitos
não mudam de dia"* — ou seja, a regra é aplicada **na escrita**, gravando o
`business_date` junto do `occurred_at`, nunca recalculada na leitura.

**Impacto:** coluna `business_date` em `expenses`, `incomes`,
`ride_evaluations` e `work_sessions`; tabela `finance_settings`; todas as
agregações passam a agrupar por `business_date`.

### 2.5 Custo por km: entrada direta, calculadora opcional

**Hoje:** o custo/km só existe depois de cadastrar veículo + manutenções +
custos fixos.

**Referência:** bottom sheet **"Custo por km rodado"** com um campo, botões
−/+, e o link *"Não sabe seu custo? Toque aqui para calcular"*. A calculadora é
a saída, não a porta.

Enquanto não há custo, a referência **degrada com clareza**: "Lucro líquido
mínimo" e "Porcentagem de lucro" aparecem com cadeado e o rótulo
**"Requer custo"**, e o Diagnóstico lista *"Custo por km não informado — o
lucro do cartão sai sem o custo do carro"*.

### 2.6 Meta financeira: dois eixos, não um

**Referência (tela "Sua meta"):**

- **Tipo:** Lucro líquido *(recomendado, com explicação)* | Faturamento bruto
- **Período:** Diária | Semanal | **Mensal** | Anual
- Valor único, e o app **deriva e exibe** "por dia útil", "por semana", "por ano"
- Chips de dias de trabalho, com contador *"6 por semana · 27 em out"*

### 2.7 Campos que o parser ainda não extrai

A oferta lida pela referência contém bem mais do que valor/distância/tempo:

- **Nota do passageiro** (★ 4,84) e selo **"Iniciante"**
- **Endereço completo** de embarque e destino (não só bairro)
- **Tempo de embarque** separado do tempo de viagem
- **Distância de embarque** separada da distância de viagem
- **Paradas** no caminho (`⚠ Parada(s)`)
- **Categoria** da corrida (Pop, etc.)

Isso alimenta os seis tetos de **Tempo e distância** (§4.2) e os
**Alertas da viagem** (§4.6).

> ⚠️ **Decisão de privacidade a revisitar.** Eu havia decidido guardar só o
> bairro. A referência guarda e exibe **endereço completo** no histórico e na
> notificação, e abre no Google Maps/Waze. É defensável (o dado é do motorista
> e fica no aparelho), mas muda o que vai para a nuvem. Minha recomendação:
> **endereço completo no banco local, nunca no sync** — o `rpc_sync_rides`
> continua recebendo só métricas derivadas. Confirme em §9.

---

## 3. Navegação e nomenclatura

**Referência — 4 abas:** `Início` · `Histórico` · `Finanças` · `Perfil`

### 3.1 Início

Painel de controle do Semáforo, não um dashboard financeiro:

1. **Três interruptores:** Copiloto · Semáforo de Valores · **Câmera Secreta**
2. "Ver relatório"
3. **Suas Faixas** — tabela Ruim / Atenção / Aceitar × R$/km, R$/hora, Nota, com botão "Ajustar"
4. **Condições mínimas** — Valor da viagem · Lucro líq. mínimo · Lucro mín. %
5. **Tempo e distância** — resumo dos tetos
6. **Custo operacional** — valor + "Calcular"
7. **Ferramentas** — Estilo do Cartão · Melhores Horários

### 3.2 Histórico

- Navegação por semana (`12 – 18 out`) com barra de dias e seletor de período
- Abas com contador: **Todas · Aceitas · Recusadas · Confirmar**
- Cartão-resumo: *N solicitações analisadas · R$ total analisado*
- Três métricas: Média por corrida · Por hora em corrida · Por km em corrida
- Busca **pelo valor** da corrida
- Menu `···` para limpar corridas; `?` abre o guia e as perguntas frequentes
- **Onboarding próprio de 5 slides**

**O fluxo que falta inteiro:** o cartão da corrida tem botão **"Aceitei"**.
Marcar manda a corrida para a aba *Aceitas*, soma no total aceito e **vira
sugestão de receita em Finanças**. As não marcadas contam como recusadas. A
aba *Confirmar* junta as pendentes, e há um botão **"Fiz todas as N deste
dia"**. Hoje eu gravo `outcome = unknown` e nunca pergunto.

### 3.3 Finanças

- Períodos: Dia · Semana · Mês · Ano · Período, com roda de meses e "calendário"
- Vazio: *"Seu caixa começa hoje"* → **Fechar o primeiro dia** / Lançar receita ou despesa
- **Primeiros passos — 0 de 4** (checklist de ativação, dispensável no `✕`)
- FAB `+` → *"O que você quer registrar?"*: **Receita · Despesa · Fechar o dia · Jornada**
- Setas ▲/▼ comparando com o período anterior do mesmo tamanho
- Médias mostram `—` quando falta dado (horas e km vêm do fechamento do dia)

### 3.4 Perfil

`Minha conta` · `Configurações` · `Finanças` · `Indique e ganhe` ·
`Ajuda e suporte` · `Sair`.

---

## 4. Funcionalidades que não existem no meu app

Ordenadas por quanto custam.

### 4.1 Fechar o dia
Fluxo de 1 minuto que fecha ganhos, km, horas e gastos do dia. É **a fonte de
horas e km** para todas as médias. Sem ele, metade dos números é `—`.

### 4.2 Tempo e distância — seis tetos
Tempo de embarque · Tempo total da viagem · Tempo da viagem (sem embarque) ·
Distância de embarque · Distância total · Distância da viagem (sem embarque).
Default `Sem limite`, steppers −/+ e edição direta.

### 4.3 Condições mínimas
Valor mínimo da viagem (`0 = sem limite`) · Lucro líquido mínimo · Porcentagem
de lucro. As duas últimas bloqueadas sem custo/km.

### 4.4 Câmera Secreta + Gravações
Dashcam: qualidade 360p/480p/720p (com recomendação pelo aparelho), lente
frontal/traseira, corte em arquivos de 5 min, buffer circular de 64 GB, pasta
`Rota Pro - Gravações` na galeria. Tela **Gravações** com espaço usado, escolha
do destino e filtros. *"Nada aparece na tela durante as corridas."*

> ⚠️ Gravar áudio/vídeo de passageiro tem implicação legal (LGPD, consentimento).
> Precisa de parecer antes de implementar. Está listado, não recomendado para já.

### 4.5 Jornada
Cronômetro com status (Parada/Online), **Modo Manual ou Automático** — o
automático lê o status (online, busca, embarque, viagem) nos apps —,
"Perguntar se aceitei a corrida" (Na lateral / No topo, com pré-visualização),
e relatório por período. Alimenta as horas do fechamento do dia.

### 4.6 Alertas da viagem
`Usuário iniciante` e `Corridas com parada`, com a definição de "iniciante" por
app (Uber: menos de 5 viagens; 99 e inDrive: nenhuma). O selo aparece no cartão
ao lado da nota.

### 4.7 Notificação da corrida — montável
Notificação que acompanha o cartão, com **slots configuráveis**:
Título 3/3 (Valor · Tempo total · Distância total), Colunas 3/4 (R$/Km ·
R$/Hora · Nota), disponíveis para arrastar (R$/Min · Lucro R$ · Lucro %),
e três interruptores (Endereços, Avisos da corrida, Botões Embarque/Destino).
Tem "Enviar notificação de teste" e "Restaurar o padrão".

### 4.8 Notificação por voz
Fala "Aceitar" / "Analisar" / "Rejeitar" mais duas informações.

### 4.9 Estilo do Cartão
Tipo (Completo / peças soltas), posição do aviso, mostrar motivo, tamanho
PP/P/M/G, posição por app, fixar no centro, tamanho e família da fonte
(Rota Pro / Sistema), tempo em tela (12s), opacidade, 3 temas, prévia nos três
veredictos.

### 4.10 Despesas recorrentes
Nome, valor, categoria, frequência (Semanal / Mensal / Anual / **N dias**), dia
do mês, primeiro vencimento. *"No vencimento a despesa é lançada sozinha (com o
plano ativo). Dá para desfazer."*

### 4.11 Reserva para manutenção
Valor guardado para manutenção, acompanhado à parte.

### 4.12 Alertas de Finanças
Manutenção · Meta · Despesas recorrentes · Avisar no celular ·
**Lembrete para fechar o dia** (21h30, só em dias com movimento e sem
fechamento, e espera a jornada acabar). Mais **Horário dos avisos**
(7h/9h/12h/15h/18h) com a justificativa de quem trabalha de madrugada.

### 4.13 Diagnóstico
Relatório de autoatendimento, a melhor tela de suporte do app:

- N **pontos de atenção**, os que `IMPEDEM O USO` primeiro, agrupados em
  Leitura de corridas · Cartão e avisos · Segundo plano · Configuração — cada
  um com botão de ação ("Ativar", "Permitir", "Resolver", "Ligar", "Calcular")
- **Aparelho:** modelo, Android, versão do app, memória
- **Permissões:** 6 itens com estado (Acessibilidade, Sobrepor, Notificações,
  Canal "Viagens", Bateria, Início automático)
- **Leitura:** Semáforo/Copiloto, apps lidos, ofertas lidas hoje, última lida
- **Semáforo:** perfil em uso, as 3 faixas, limites, custo/km, endereços de risco
- **Conta e plano:** e-mail, plano, aparelhos ativos
- **Aviso de privacidade explícito:** *"Fica fora do envio: endereços, nomes de
  passageiros, quanto você ganhou, CPF e dados de pagamento."*
- `Enviar ao suporte` (WhatsApp, com prévia da mensagem) e `Copiar texto`

### 4.14 Ajuda e suporte
Central de Ajuda com prints · Status do serviço ("4 permissões pendentes") ·
"Meu aparelho fecha o app sozinho" · Diagnóstico · WhatsApp (seg–sex, 9h–18h).
Mais **Ajuda de Finanças**: 18 artigos, busca por palavra-chave, categorias
(Tudo · Começar · Dia a dia · …) e accordion.

### 4.15 Fluxo de permissões (4 passos)
Uma tela por permissão, com: para que serve, **a promessa de privacidade**
(*"Tudo acontece apenas no seu aparelho. O Rota Pro não coleta, não armazena e
não compartilha o conteúdo das suas telas"*), caixa **"Li e autorizo"**, passo
a passo de como ativar, e "Deixar pra depois".
Mais o bottom sheet **"Proteção no seu Xiaomi"** (Xiaomi/Redmi/POCO fecham apps
em segundo plano → Início automático).

### 4.16 Preferências de aparência e idioma
Tema (Claro/Escuro/Auto) · Tamanho da fonte (Pequena/Média/Grande/Extragrande)
· **Idioma** (Padrão do sistema, pt-BR, pt-PT, es, en) · Notificações de
novidades.

### 4.17 Limite de 2 aparelhos
*"Você pode usar o Rota Pro em até 2 aparelhos. Os 2 mais recentes ficam ativos;
ao entrar em um novo, o mais parado sai automaticamente."* Tela **Seus
aparelhos** com modelo, versão do Android e "Visto agora".
Isso é **regra de servidor**, não de cliente: precisa de tabela e RPC.

### 4.18 Outros
- **App de navegação:** Perguntar sempre / Google Maps / Waze
- **Viagem particular:** cotação de corrida fora do app pelo custo/km
- **Melhores Horários**
- **Indique e ganhe:** `rotapro.app/i/CÓDIGO`, +5 dias na primeira corrida
  analisada do amigo
- **Print automático** (álbum na galeria, nada sai do aparelho)
- **Endereços de risco** (palavras-chave por embarque/destino/mercados)
- **Mensagem personalizada** (copia para a área de transferência ao abrir o chat)
- **Excluir minha conta** e **Limpar todos os dados** (duas coisas distintas)
- **"Enviar meus dados ao suporte"** no perfil (nome, e-mail, ID da conta)

---

## 5. ⚠️ Decisão pendente: o fluxo de conta

**O defeito que você relatou** — *"não inicia para o cadastro da conta"* — não é
um bug de rota. É uma **decisão de produto minha, que diverge da referência**.
Eu construí a conta como opcional (local-first puro) e não coloquei nenhum passo
de conta no início. As capturas mostram o contrário.

### O que a referência faz

1. Onboarding de **4 slides**, terminando em *"Teste grátis por 7 dias"*
2. Dois botões: **"Criar conta"** e **"Entrar em uma conta existente"**
3. **Cadastro sem senha:** *"É rápido e sem senha. Use o Google ou receba um
   link de acesso no seu e-mail."*
4. Depois, o fluxo de **4 permissões**

E a conta sustenta coisas que não funcionam sem ela: o **plano** (teste até
20/10/2026), o **limite de 2 aparelhos**, o **Indique e ganhe**, o **ID da conta**
usado pelo suporte, e o e-mail **bloqueado para edição** no perfil.

### O que eu construí

Conta opcional, e-mail + senha (T03), sem lugar no fluxo inicial.
**Duas divergências:** o momento, e o método.

### Recomendação

**Opção A — conta obrigatória, sem senha.** Alinha com a referência e com o que
o produto precisa para monetizar.

- Login só por **Google OAuth** e **magic link** por e-mail. Senha some.
- Isso **remove uma classe inteira de risco**: sem senha não há vazamento de
  senha, não há reuso de senha, não há fluxo de recuperação para invadir — que é
  justamente o buraco aberto hoje por `enable_confirmations = false`.
- O local-first **não muda**: os dados continuam nascendo e vivendo no SQLite.
  A conta passa a ser a porta do sync e do plano, não do app.

Opção B (sugerir conta com "continuar sem conta") e Opção C (manter opcional)
continuam na mesa, mas depois de ver o app inteiro **não as recomendo mais**:
metade das telas pressupõe conta.

> **Responda só isto para eu começar: A, B ou C.** O Bloco H muda conforme.

---

## 6. Subtasks

Blocos independentes entre si, exceto onde indicado. Cada um termina com
`flutter analyze` limpo, `flutter test` verde e migration aplicada.

### Bloco A — Faixas explícitas nas três métricas `[fundação]`
- A1 — `RideBands`: `badBelow`/`goodAbove` para km, hora e **nota**
- A2 — Migration local (Drift v4) com backfill: `goal × (1 − tol)` → `badBelow`, `goal` → `goodAbove`; nota recebe 4,50/4,90
- A3 — Migration Postgres `0010_ride_bands.sql`, mesmo backfill
- A4 — `EvaluateRide` passa a receber `passengerRating`; nova regra: o pior dos três manda
- A5 — Testes: fronteiras exatas, nota ausente, três combinações de veredicto
- A6 — UI: slider de dois polegares + edição numérica, com validação de faixa (§2.1)
- A7 — Tabela "Suas Faixas" na Início

### Bloco B — Ciclo financeiro `[fundação, bloqueia F/G]`
- B1 — Tabela `finance_settings`: `week_starts_on`, `work_days`, `month_starts_on`, `day_rollover` (`midnight` \| `four_am`)
- B2 — `BusinessDate`: função pura `(occurredAt, settings) → date`, com testes de 23h59, 00h01, 03h59, 04h00
- B3 — Coluna `business_date` em expenses, incomes, ride_evaluations, work_sessions — gravada na escrita, **nunca recalculada**
- B4 — Migration Postgres equivalente + ajuste das views de relatório
- B5 — Agregações passam a agrupar por `business_date`
- B6 — Tela Configurações de Finanças → META E CICLO

### Bloco C — Categorias como dados
- C1 — Tabelas `expense_categories` / `income_categories` com seed (12 e 4), `is_system`, `is_enabled`, `icon`, `sort_order`
- C2 — `expenses.category` e `incomes.category` viram FK
- C3 — Migration de dados do enum atual
- C4 — Regra de exclusão: lançamentos migram para "Outros"
- C5 — Migration Postgres + RLS
- C6 — Tela Categorias com interruptores, seletor de ícone e "Adicionar"

### Bloco D — Plataformas como catálogo
- D1 — Tabela `platforms` com seed de 17 + `is_custom`, `is_enabled`, `sort_order`
- D2 — Separação explícita entre catálogo financeiro e apps lidos pelo Semáforo
- D3 — Migration Postgres
- D4 — Tela Plataformas com reordenação e "Nova plataforma"
- D5 — **Não tocar** em `accessibility_config.xml`: a lista de pacotes monitorados continua fechada

### Bloco E — Custo por km direto
- E1 — Bottom sheet "Custo por km rodado" com −/+ e entrada direta
- E2 — Link "Não sabe seu custo? Toque aqui para calcular" → wizard
- E3 — Estado bloqueado "Requer custo" no lucro mínimo e na % de lucro
- E4 — Wizard em 2 variantes: **FINANCIADO (4 passos)** e **ALUGADO (3 passos)**
- E5 — Passo 1 financiado: transporte, o que você faz, nome, valor FIPE, parcela, seguro, IPVA % + calculado, desvalorização % + calculada, outros custos
- E6 — Passo 1 alugado: aluguel Diária/Semanal/Mensal, valor, dias por mês, outros custos
- E7 — Passo 2: combustível com 6 tipos (inclui **Híbrido**), preço/L, consumo km/L
- E8 — Validação de sanidade "Confira os valores" (2–50 km/L) com "Calcular assim mesmo" / "Revisar"
- E9 — Passo 3: metas (km/dia, km/mês, lucro mensal, dias, horas/dia + personalizar) com derivados SEMANA / DIAS-MÊS 5×4,33 / MÊS

### Bloco F — Meta financeira `[depende de B]`
- F1 — Modelo: tipo (líquido \| bruto) × período (diária \| semanal \| mensal \| anual)
- F2 — Derivação por dia útil / semana / ano, usando `work_days`
- F3 — Tela "Sua meta"

### Bloco G — Finanças `[depende de B, C, D]`
- G1 — Reestruturar a aba com períodos Dia/Semana/Mês/Ano/Período + roda
- G2 — Vazio "Seu caixa começa hoje" e **Primeiros passos 0 de 4**
- G3 — FAB `+` → Receita / Despesa / Fechar o dia / Jornada
- G4 — Nova receita (plataforma, corridas, data, descrição 0/120)
- G5 — Nova despesa (categoria, data, descrição, interruptor de recorrente)
- G6 — Despesas recorrentes (frequência, dia, primeiro vencimento, lançamento automático, desfazer)
- G7 — **Fechar o dia**
- G8 — Comparação ▲/▼ com o período anterior e `—` quando falta dado
- G9 — Reserva para manutenção

### Bloco H — Conta `[bloqueado pela decisão §5]`
- H1 — Onboarding de 4 slides terminando em "Teste grátis por 7 dias"
- H2 — Tela Criar conta / Entrar
- H3 — **Google OAuth** + **magic link**; remover e-mail+senha
- H4 — `supabase/config.toml`: provider Google, remover o buraco do `enable_confirmations`
- H5 — Tabela `user_devices` + RPC de registro com a regra dos 2 mais recentes
- H6 — Tela "Seus aparelhos"
- H7 — Minha conta / Editar perfil (foto, nome, telefone, cidade, e-mail bloqueado)
- H8 — Excluir conta (texto da referência, incluindo a ressalva da assinatura)

### Bloco I — Permissões e diagnóstico
- I1 — Fluxo de 4 permissões com promessa de privacidade e "Li e autorizo"
- I2 — Bottom sheet "Proteção no seu Xiaomi" (detecção de OEM)
- I3 — **Diagnóstico** completo (§4.13), com a lista de exclusão de privacidade
- I4 — "Enviar ao suporte" (WhatsApp com prévia) e "Copiar texto"
- I5 — Ajuda e suporte + Status do serviço
- I6 — Ajuda de Finanças: 18 artigos, busca, categorias, accordion

### Bloco J — Histórico `[depende de A]`
- J1 — Navegação por semana, barra de dias, seletor de período
- J2 — Abas Todas / Aceitas / Recusadas / **Confirmar** com contadores
- J3 — **Fluxo "Aceitei"**: marca, move de aba, soma no total e vira sugestão de receita
- J4 — "Fiz todas as N deste dia"
- J5 — Edição completa do registro com recálculo
- J6 — Busca pelo valor
- J7 — Onboarding de 5 slides
- J8 — Menu `···` para limpar corridas

### Bloco K — Parser e cartão `[depende de A]`
- K1 — Extrair nota do passageiro, selo iniciante, paradas, categoria
- K2 — Separar embarque de viagem (tempo e distância)
- K3 — Endereço completo **local**, nunca no sync (confirmar §9)
- K4 — Seis tetos de tempo e distância
- K5 — Condições mínimas (valor, lucro líquido, % de lucro)
- K6 — Estilo do Cartão (§4.9)
- K7 — Notificação da corrida montável (§4.7)
- K8 — Alertas da viagem (§4.6)
- K9 — Notificação por voz

### Bloco L — Jornada
- L1 — Cronômetro e sessões, com estado na foreground service
- L2 — Modo Manual / Automático (leitura de status nos apps)
- L3 — "Perguntar se aceitei a corrida" (lateral / topo + prévia)
- L4 — Relatório por período
- L5 — Ligar horas da jornada ao Fechar o dia

### Bloco M — Preferências e utilidades
- M1 — Tema Claro/Escuro/Auto
- M2 — Tamanho da fonte em 4 níveis
- M3 — Idioma (5 opções) com `flutter_localizations` e ARB
- M4 — App de navegação (Perguntar sempre / Maps / Waze)
- M5 — Alertas de Finanças + Horário dos avisos
- M6 — Indique e ganhe
- M7 — Viagem particular
- M8 — Limpar todos os dados

### Bloco N — Posterior / com ressalva
- N1 — **Câmera Secreta + Gravações** — ⚠️ requer parecer jurídico (§4.4)
- N2 — Melhores Horários
- N3 — Print automático
- N4 — Endereços de risco
- N5 — Mensagem personalizada
- N6 — Central de Ajuda com prints

---

## 7. Monetização — divergência a confirmar

| | Descritivo atual | Referência |
|---|---|---|
| Planos | 3 (mensal, trimestral, anual) | **1, anual** |
| Preço | — | **R$ 97/ano**; R$ 48,50 com 50% no teste |
| Parcelamento | — | Pix ou **10× R$ 5,34** |
| Checkout | in-app | **Web, em rotapro.app** |
| Teste | — | **7 dias** |

O checkout web muda a arquitetura de assinatura (webhook em vez de
RevenueCat/Play Billing) e tem implicação de política das lojas. Não está em
nenhum bloco até você confirmar.

---

## 8. Ordem sugerida

```
1.  §5 — sua decisão sobre a conta
2.  Bloco B (ciclo financeiro)     ─┐ fundação: mexem em migration
3.  Bloco A (faixas)                │ e precisam vir antes do resto
4.  Bloco C (categorias)            │
5.  Bloco D (plataformas)          ─┘
6.  Bloco H (conta)                 ← resolve o defeito relatado
7.  Bloco E (custo por km)
8.  Bloco F + G (meta e Finanças)
9.  Bloco J + K (Histórico e parser)
10. Bloco I (permissões e diagnóstico)
11. Bloco L (jornada)
12. Bloco M (preferências)
13. Bloco N (com ressalva)
```

Blocos B, A, C e D **antes de qualquer tela nova**: são os que custam caro se
feitos depois, porque cada tela construída sobre o modelo velho precisaria ser
refeita.

---

## 9. O que preciso que você confirme

1. **§5 — conta: A, B ou C?** (recomendo **A**) — bloqueia o Bloco H
2. **§2.7 — endereço completo** no banco local, só métricas no sync?
3. **§4.4 — Câmera Secreta**: tem parecer sobre gravar passageiro? Até lá fica no Bloco N
4. **§7 — monetização**: plano anual único com checkout web é a decisão final?

---

## 10. Bloqueadores de go-live (independentes deste plano)

- `supabase/config.toml`: `enable_confirmations = false` — **precisa voltar a
  `true`** antes de qualquer usuário real (a Opção A de §5 resolve isso de vez)
- PITR no Supabase (exige plano Pro)
- iOS nunca foi compilado
- Overlay e parsers **nunca validados** contra layout real de Uber/99
