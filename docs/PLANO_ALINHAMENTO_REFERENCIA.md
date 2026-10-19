# Plano de alinhamento com a referência (Rota Pro v1.1.60)

> **Status:** análise feita sobre **11 das 123** capturas em `docs/imagens/`.
> As divergências estruturais abaixo já aparecem nessa amostra e não devem
> mudar. O inventário de telas, porém, está incompleto — ver §7.

---

## 1. Veredicto sobre o que já existe

O que construímos está **correto no núcleo e divergente na superfície**.

| Camada | Situação |
|---|---|
| Cálculo (custo/km, R$/km, R$/hora, lucro) | ✅ Correto e testado. Não muda |
| Local-first (Drift + outbox + sync) | ✅ Correto. Não muda |
| Backend (RLS, RPCs, cron) | ✅ Correto. Precisa de **acréscimos**, não correções |
| Captura e overlay (Kotlin) | ✅ Estrutura correta. Parser precisa extrair **mais campos** |
| **Modelo de metas** | ❌ **Conceitualmente diferente** — ver §2.1 |
| **Categorias de despesa** | ❌ Enum fixo vs. tabela configurável — ver §2.2 |
| **Entrada do custo por km** | ❌ Fricção alta demais — ver §2.3 |
| **Modelo de meta de faturamento** | ❌ Rígido demais — ver §2.4 |
| Navegação e nomes das abas | ⚠️ Divergente — ver §3 |

Nada do que foi feito precisa ser jogado fora. As mudanças são de **modelo de
dados e de superfície**, sobre uma base que se sustenta.

---

## 2. Divergências estruturais

### 2.1 Metas: faixas explícitas, não meta + tolerância

**Hoje:** uma meta por métrica (`goal_rs_per_km`) mais uma tolerância global
(`think_tolerance_pct`). O amarelo é derivado: `meta × (1 − tolerância)`.

**Referência:** duas fronteiras explícitas por métrica, editadas diretamente.

| Faixa | Ruim | Atenção | Aceitar |
|---|---|---|---|
| R$/km | < 1,40 | 1,40 – 1,80 | ≥ 1,80 |
| R$/hora | < 30 | 30 – 40 | ≥ 40 |
| Nota do passageiro | < 4,30 | 4,30 – 4,90 | ≥ 4,90 |

A tela chama de **"RUIM ABAIXO DE"** e **"BOM ACIMA DE"**.

**Por que a referência é melhor:** o motorista enxerga e edita exatamente o
número que decide. Com tolerância percentual, ele define 2,00 e o app recusa a
1,69 por uma conta que ele não vê. É o tipo de opacidade que destrói confiança
num app que decide dinheiro.

**Impacto:** troca de `goal_rs_per_km` + `think_tolerance_pct` por
`rs_per_km_bad_below` + `rs_per_km_good_above`, nas três métricas. Afeta
entidade, tabela local, tabela remota, caso de uso `EvaluateRide` e a T07.

### 2.2 Categorias de despesa: tabela, não enum

**Hoje:** `enum ExpenseCategory` com 9 valores fixos.

**Referência:** categorias são **dados**. O motorista liga/desliga, troca o
ícone, cria as próprias e exclui (lançamentos migram para "Outros").
Combustível e Manutenção são "sempre ligadas" — alimentam o custo por km.

Categorias vistas que não tenho: **Seguro, Financiamento, Celular**.

**Impacto:** `expense_categories` vira tabela local e remota, com
`is_system`, `is_enabled`, `icon`, `sort_order`. `expenses.category` passa a
referenciar o `client_id` da categoria.

### 2.3 Custo por km: entrada direta com calculadora opcional

**Hoje:** o único caminho é preencher o formulário de veículo inteiro —
combustível, consumo, manutenção, depreciação, custos fixos, dias e km por dia.

**Referência:** um campo `R$ 0,00 /km` com `−` e `+`, e abaixo:
*"Não sabe seu custo? Toque aqui para calcular"*.

**Por que importa:** o motorista que já sabe seu custo digita em 5 segundos. O
que não sabe usa a calculadora. Hoje eu obrigo os dois ao caminho longo, e
isso é abandono na primeira tela que importa.

**Impacto:** `work_profiles` ganha `manual_cost_per_km`. O veículo passa a ser
opcional, e a T06 vira a calculadora acessória.

### 2.4 Meta de faturamento: uma meta, um período, dias escolhidos

**Hoje:** `daily_revenue_goal` e `monthly_revenue_goal` como números soltos, e
`work_days_per_month` como inteiro.

**Referência:** tela "Sua meta" com:
- alternância **Lucro líquido / Faturamento bruto**;
- período **Diária / Semanal / Mensal / Anual**;
- um valor, e o app **deriva** por dia útil, semana e ano;
- **dias de trabalho** como chips de Seg a Dom.

**Impacto:** `goal_amount`, `goal_period`, `goal_basis` e `work_weekdays`
(máscara de 7 bits) substituem os três campos atuais.

### 2.5 Condições mínimas e limites

A referência tem, além das faixas:

- **Ganhos mínimos:** valor mínimo da viagem, lucro líquido mínimo, lucro
  mínimo em %;
- **Tempo e distância:** limites máximos (hoje só tenho `max_pickup_km`).

### 2.6 Dados que o parser ainda não extrai

A tela "Alertas da viagem" revela campos que a referência lê da oferta:

- **passageiro iniciante** (Uber: menos de 5 viagens; 99 e inDrive: nenhuma);
- **corrida com parada** no caminho.

Ambos viram selo no cartão. Meu parser não os busca.

---

## 3. Navegação e nomenclatura

| Minha aba | Referência | Ação |
|---|---|---|
| Início | **Início** | Reestruturar conteúdo |
| Histórico | **Histórico** | Manter |
| Caixa | **Finanças** | Renomear e ampliar |
| Ajustes | **Perfil** | Renomear e reestruturar |

A tela Início da referência tem, de cima para baixo: cabeçalho escuro com
saudação, cartão de teste grátis/assinatura, **dois interruptores separados**
(`Copiloto` e `Semáforo de Valores`, cada um com engrenagem), permissões,
Jornada, **Suas Faixas**, Condições mínimas, Calcular, e uma grade
**FERRAMENTAS** com 11 atalhos.

Hoje minha Início tem três cartões e dois botões.

---

## 4. Funcionalidades que não existem no meu app

| Funcionalidade | O que é |
|---|---|
| **Estilo do Cartão** | Personalizar aparência do overlay |
| **Melhores Horários** | Existe como T12; falta como atalho |
| **Viagem particular** | Pausar avaliação em viagem pessoal |
| **Alertas da viagem** | Selo de iniciante e de parada |
| **Mensagem personalizada** | Texto automático ao passageiro |
| **Print Automático** | Captura de tela da oferta |
| **Endereços de Risco** | Alerta por região |
| **Copiloto** | Segundo modo, distinto do semáforo |
| **Tamanho da fonte no app** | 4 níveis, independente do sistema |
| **Idioma** | Seleção explícita |
| **Indicação de amigo** | +5 dias grátis |
| **Vincular compra** | Recuperar assinatura existente |
| **Lembretes de Finanças** | Avisos em hora escolhida |
| **Limpar todos os dados** | Reset local |

---

## 5. O defeito relatado: não vai para o cadastro de conta

**Não é bug — é decisão minha que diverge da sua expectativa.**

Implementei a conta como **opcional**: o Splash leva para Apresentação →
Veículo → Dashboard, e o login só existe em Ajustes. O raciocínio foi
local-first: não travar o motorista sem sinal.

A referência aparenta exigir conta (a Início já mostra estado de assinatura e
indicação). Como a monetização depende de identidade, **a conta provavelmente
precisa entrar no fluxo inicial**.

**Decisão pendente sua** — três opções:

| Opção | Efeito |
|---|---|
| **A. Conta obrigatória** | Splash → Apresentação → **Login** → Veículo. Alinha com a referência e com o paywall |
| **B. Conta sugerida** | Mostra a tela de login com "Continuar sem conta" visível |
| **C. Manter opcional** | Como está hoje |

Minha recomendação é **B**: preserva o local-first e coloca a conta no caminho,
em vez de escondê-la em Ajustes onde ninguém acha.

---

## 6. Subtasks

Ordenadas por dependência. Cada bloco termina com `analyze` + `test` + commit.

### Bloco A — Modelo de metas em faixas (fundação)

| # | Tarefa | Arquivos |
|---|---|---|
| A1 | Entidade `MetricBand { badBelow, goodAbove }` e `WorkGoals` com três faixas | `goals/domain/entities/` |
| A2 | `EvaluateRide` passa a classificar por faixa; remover tolerância | `semaphore/domain/usecases/` |
| A3 | Atualizar os 20 testes de `EvaluateRide` para o novo modelo | `test/features/semaphore/` |
| A4 | Migração local v4: colunas de faixa em `local_work_profiles` | `data/local/` |
| A5 | Migração remota `0010`: mesmas colunas em `work_profiles` | `supabase/migrations/` |
| A6 | Reescrever T07 como a tela "Suas Faixas" + "RUIM ABAIXO / BOM ACIMA" | `goals/presentation/` |

### Bloco B — Custo por km direto

| # | Tarefa |
|---|---|
| B1 | `manual_cost_per_km` em `work_profiles` (local + remoto) |
| B2 | `costPerKmProvider` prioriza o manual; cai para o cálculo do veículo |
| B3 | Bottom sheet "Custo por km rodado" com `−`/`+` e link para a calculadora |
| B4 | T06 vira calculadora acessória; veículo deixa de ser obrigatório |
| B5 | Ajustar `isConfiguredProvider`: basta custo **ou** veículo |

### Bloco C — Categorias como dados

| # | Tarefa |
|---|---|
| C1 | Tabela `expense_categories` (local v5 + remota `0011`) com seed das 12 categorias |
| C2 | `expenses.category` passa a referenciar categoria; migração dos dados existentes |
| C3 | Tela "Categorias": ligar/desligar, trocar ícone, criar, excluir com migração para "Outros" |
| C4 | Atualizar T11 e os agrupamentos do fechamento |

### Bloco D — Meta de faturamento

| # | Tarefa |
|---|---|
| D1 | `goal_amount`, `goal_period`, `goal_basis`, `work_weekdays` (local + remoto) |
| D2 | Derivação por dia útil / semana / ano a partir dos dias marcados |
| D3 | Tela "Sua meta" com os dois toggles, os quatro períodos e os chips de dia |
| D4 | Dashboard e Finanças passam a comparar contra a meta derivada |

### Bloco E — Condições mínimas e limites

| # | Tarefa |
|---|---|
| E1 | `min_fare`, `min_net_profit`, `min_profit_pct`, `max_trip_km`, `max_trip_minutes` |
| E2 | `EvaluateRide` aplica como critérios eliminatórios |
| E3 | Seções "Ganhos mínimos" e "Tempo e distância" na tela de faixas |

### Bloco F — Reestruturação da Início

| # | Tarefa |
|---|---|
| F1 | Cabeçalho escuro com saudação por horário |
| F2 | Cartão de assinatura/teste com dias restantes |
| F3 | Interruptores separados de Copiloto e Semáforo, cada um com engrenagem |
| F4 | Cartão "Suas Faixas" (leitura) com botão Ajustar |
| F5 | Grade FERRAMENTAS com os 11 atalhos |
| F6 | Renomear abas: Caixa → Finanças, Ajustes → Perfil |

### Bloco G — Parser e cartão

| # | Tarefa |
|---|---|
| G1 | Extrair passageiro iniciante e corrida com parada |
| G2 | Selos no cartão do overlay |
| G3 | Cartão no formato da referência: horizontal, 4 métricas com barra lateral |
| G4 | Trocar "Lucro R$" por "Lucro %" no cartão |
| G5 | Tela "Estilo do Cartão" |

### Bloco H — Decisão sobre conta (§5)

| # | Tarefa |
|---|---|
| H1 | Aplicar a opção escolhida no fluxo do Splash |
| H2 | "Continuar sem conta" se for a opção B |

### Bloco I — Preferências e utilidades

| # | Tarefa |
|---|---|
| I1 | Tamanho da fonte no app (4 níveis) |
| I2 | Seleção de idioma |
| I3 | Lembretes de Finanças com hora escolhida |
| I4 | "Limpar todos os dados" |
| I5 | Excluir conta com o texto da referência |

### Bloco J — Funcionalidades novas (maiores)

Cada uma merece avaliação própria de escopo antes de entrar:

- Viagem particular
- Mensagem personalizada
- Print Automático
- Endereços de Risco
- Copiloto (**preciso entender o que é** — ver §7)
- Indicação de amigo e vincular compra

---

## 7. O que ainda preciso ver

Analisei 11 de 123 imagens. Antes de executar os blocos F, G e J, preciso
revisar as demais para não construir sobre suposição:

- aba **Histórico** completa;
- aba **Finanças** completa;
- aba **Perfil** completa;
- o que é **Copiloto** e como difere do Semáforo;
- tela **Estilo do Cartão**;
- fluxo de **assinatura e paywall**;
- telas de **Melhores Horários** e **Jornada**.

Os blocos A a E não dependem dessa revisão: as divergências de modelo já estão
caracterizadas e são o caminho crítico.

---

## 8. Ordem sugerida

1. **Decidir §5** (conta no fluxo inicial) — bloqueia H e influencia F2.
2. **Blocos A e B** — mudam o núcleo e tudo depende deles.
3. **Revisar as 112 imagens restantes** e completar este plano.
4. **Blocos C, D, E** — modelo de dados.
5. **Blocos F, G** — superfície.
6. **Blocos I, J** — ampliação.
