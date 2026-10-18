# 📋 Descritivo Completo — App Rota Plus (Flutter + Supabase)

> **Referência visual:** rotapro.app
> **Plataforma-alvo:** Android + iOS (Flutter 3.x)
> **Backend:** Supabase (Postgres 15+, Auth, Storage, Realtime, Edge Functions)
> **Versão do documento:** 2.0 — Outubro 2026
> **Mudança principal vs. v1.0:** migração de Firebase → Supabase, arquitetura *local-first*, modelo de
> segurança formalizado (RLS + LGPD), schema SQL completo e metas mensuráveis de desempenho.

---

## 📌 Visão Geral do Produto

O **Rota Plus** é um aplicativo copiloto financeiro para motoristas de app (Uber, 99 e inDrive). Ele analisa
cada corrida oferecida em tempo real e informa ao motorista se vale a pena aceitar ou recusar, baseando-se em
métricas como **R$/km**, **R$/hora** e **lucro real** (descontando combustível, manutenção e depreciação do veículo).

**Proposta de valor:** *"Pare de aceitar corrida ruim. Saiba se a corrida vale a pena antes de aceitar."*

### Princípios de produto que guiam toda decisão técnica

| # | Princípio | Consequência técnica |
|---|---|---|
| 1 | **O veredicto precisa ser instantâneo** | O cálculo é 100% local. Nenhuma chamada de rede no caminho crítico. Orçamento: **< 120 ms** entre capturar a tela e desenhar o overlay. |
| 2 | **O app precisa funcionar sem internet** | Banco local (Drift) é a *fonte de verdade* de leitura. Supabase é camada de sincronização, não dependência de runtime. |
| 3 | **Dados do motorista são sensíveis** | Capturas de tela nunca saem do dispositivo em formato bruto. Só métricas derivadas sobem. |
| 4 | **Bateria é recurso escasso** | Serviço em foreground enxuto, zero polling, sincronização em lote oportunista. |
| 5 | **O motorista está dirigindo** | Fluidez e TTS não são enfeite: são requisito de segurança viária. 60 fps mínimo, 120 fps onde houver. |

---

## 🏗️ Arquitetura Geral do Projeto

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         APP MOBILE (Flutter)                             │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │ UI LAYER — MVVM                                                    │  │
│  │ Views (lean, sem lógica)  ·  ViewModels (Riverpod Notifier)        │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                   ↕                                      │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │ DOMAIN LAYER                                                       │  │
│  │ Entities imutáveis (freezed)  ·  Use Cases                         │  │
│  │ EvaluateRideUseCase · CalculateCostPerKmUseCase · CloseCashUseCase │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                   ↕                                      │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │ DATA LAYER — Repository Pattern (local-first)                      │  │
│  │                                                                    │  │
│  │   Repository ─► LocalDataSource (Drift/SQLite) ◄ FONTE DE VERDADE  │  │
│  │        │                  │                                        │  │
│  │        │                  └─► Outbox (fila de sync idempotente)    │  │
│  │        └─► RemoteDataSource (Supabase client)                      │  │
│  └────────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
          ↕ Platform Channels                      ↕ HTTPS / WSS
┌─────────────────────────────────┐   ┌────────────────────────────────────┐
│ SERVIÇOS NATIVOS                │   │ SUPABASE (backend)                 │
│                                 │   │                                    │
│ Android:                        │   │ Auth (GoTrue) — e-mail, Google,    │
│  · AccessibilityService         │   │   Apple, PKCE, MFA opcional        │
│  · Window Overlay               │   │                                    │
│  · Foreground Service           │   │ Postgres 15 — RLS em 100% das      │
│                                 │   │   tabelas, particionamento mensal  │
│ iOS:                            │   │                                    │
│  · NotificationServiceExtension │   │ Storage — avatares/recibos         │
│                                 │   │   (buckets privados)               │
│ Ambos:                          │   │                                    │
│  · flutter_tts                  │   │ Realtime — apenas entitlement e    │
│  · flutter_local_notifications  │   │   troca de perfil entre devices    │
└─────────────────────────────────┘   │                                    │
                                      │ Edge Functions (Deno) — webhooks,  │
                                      │   quota, exclusão de conta, push   │
                                      │                                    │
                                      │ pg_cron — retenção, agregações     │
                                      └────────────────────────────────────┘
                                                      ↕
                              ┌───────────────────────────────────────────┐
                              │ TERCEIROS                                 │
                              │ RevenueCat (IAP) · Stripe/MercadoPago     │
                              │ (PIX) · FCM/APNs (push) · Sentry (crash)  │
                              └───────────────────────────────────────────┘
```

### De Firebase para Supabase — mapa de equivalências

| Firebase (v1.0 do descritivo) | Supabase (v2.0) | Observação de migração |
|---|---|---|
| Firebase Auth | **Supabase Auth (GoTrue)** + tabela `profiles` | `auth.users` é gerenciado; dados de aplicação vão em `public.profiles`, ligada por `id`. |
| Login Google / Apple | OAuth nativo com **PKCE** + deep link | `supabase_flutter` com `authFlowType: AuthFlowType.pkce`. |
| Firestore (coleções/documentos) | **Postgres relacional normalizado** | Ganho real: `JOIN`, agregações SQL, constraints. O fechamento de caixa deixa de ser laço no cliente e passa a ser uma *view*. |
| Regras de segurança do Firestore | **Row Level Security (RLS)** | Declarativo, testável via SQL, versionado em migrations. |
| Cloud Functions | **Edge Functions (Deno)** + funções RPC em Postgres | Regra: se é lógica de dados, vira RPC/`plpgsql`; se precisa de rede ou segredo, vira Edge Function. |
| Firebase Storage | **Supabase Storage** (buckets + policies) | Buckets `avatars` e `receipts` privados, acesso por *signed URL*. |
| Listeners `snapshots()` | **Realtime** (`stream()` / channels) | Usado com parcimônia — ver §Desempenho. |
| Firebase Analytics | **PostHog** ou tabela `analytics_events` própria | Mantém o dado no mesmo Postgres, sem SDK extra. |
| Crashlytics | **Sentry** (`sentry_flutter`) | Supabase não cobre crash reporting. |
| FCM | **FCM/APNs mantidos**, disparados por Edge Function | Supabase não tem push próprio; o token fica em `device_push_tokens`. |
| GeoFirestore / geohash | **PostGIS** (`geography(Point,4326)`) | Para o mapa de calor de melhores regiões (Fase 5). |
| `firebase_core`, `cloud_firestore`, … | **`supabase_flutter`** | Um pacote no lugar de cinco. |

---

## 📱 Módulos e Funcionalidades Detalhadas

### 1. 🚦 Sistema Semáforo de Corridas (Core Feature)

A funcionalidade principal. Quando uma chamada de corrida aparece na tela do celular, o app lê as
informações e exibe um cartão flutuante com avaliação instantânea.

#### 1.1 Leitura de Dados da Corrida

| Dado capturado | Fonte | Persistido? |
|---|---|---|
| Valor da corrida (R$) | Tela do app de transporte | ✅ métrica derivada |
| Distância até o passageiro (km) | Tela do app de transporte | ✅ |
| Distância da corrida (km) | Tela do app de transporte | ✅ |
| Tempo estimado até passageiro | Tela do app de transporte | ✅ |
| Nota do passageiro | Tela do app de transporte | ✅ |
| Bairro/região do embarque | Tela do app de transporte | ✅ apenas o nome textual |
| **Texto bruto da tela** | AccessibilityService | ❌ **nunca persistido, nunca transmitido** |

> **Decisão de privacidade (crítica):** o buffer de texto capturado vive em memória pelo tempo do parse e é
> descartado. Nome do passageiro, telefone, placa e endereço completo são descartados *antes* de qualquer
> escrita em disco. Ver §Segurança da Informação.

#### 1.2 Cálculo das Métricas

Com base nos dados capturados + configuração de custos do perfil ativo:

| Métrica | Cálculo |
|---|---|
| `km_total` | `distancia_ate_passageiro + distancia_corrida` |
| `tempo_total_min` | `tempo_ate_passageiro + tempo_corrida_estimado` |
| **R$/km** | `valor_corrida ÷ km_total` |
| **R$/hora** | `valor_corrida ÷ (tempo_total_min ÷ 60)` |
| `custo_operacional` | `km_total × custo_por_km_do_perfil` |
| **Lucro real** | `valor_corrida − custo_operacional` |
| `margem_%` | `lucro_real ÷ valor_corrida × 100` |

O `custo_por_km_do_perfil` é pré-calculado e **cacheado localmente** sempre que o motorista salva custos —
jamais recalculado dentro do caminho crítico do overlay.

#### 1.3 Sistema de Cores (Semáforo)

| Cor | Veredicto | Condição |
|---|---|---|
| 🟢 | **ACEITAR** | `R$/km ≥ meta_rs_km` **e** `R$/hora ≥ meta_rs_hora` **e** `nota ≥ nota_minima` **e** `dist_embarque ≤ max` |
| 🟡 | **PENSE** | Uma das metas no limiar, dentro da tolerância configurável (padrão ±15%) |
| 🔴 | **RECUSAR** | `R$/km < custo_por_km` (prejuízo) **ou** qualquer critério eliminatório violado |

#### 1.4 Cartão Flutuante (Overlay)

- Ícone de semáforo + texto (`ACEITAR` / `PENSE` / `RECUSAR`)
- Barra colorida lateral na cor correspondente
- Grid de 4 métricas: **R$/km · R$/hora · Lucro · Nota**
- Nome do bairro/região do embarque
- Tempo estimado total
- Animação de entrada de 180 ms; auto-dismiss configurável (padrão 8 s)
- Orçamento de performance: **primeiro frame em ≤ 120 ms** após o evento de acessibilidade

---

### 2. ⚙️ Configurações do Veículo e Custos

#### 2.1 Dados do Veículo
- Tipo de combustível: Gasolina, Etanol, Flex, GNV, Diesel, Elétrico
- Consumo médio (km/l ou km/kWh)
- Preço médio do litro/kWh na região

#### 2.2 Custos de Manutenção
Itens com `custo` + `intervalo_km`: troca de óleo, pneus, pastilhas de freio, suspensão, filtros, mais um
**custo genérico de manutenção (R$/km)** para o que não foi detalhado.

#### 2.3 Depreciação do Veículo
- Valor FIPE atual ou valor de aquisição
- Depreciação por km rodado (percentual ou valor fixo)

#### 2.4 Custos Fixos (Rateio)
IPVA, seguro, licenciamento, aluguel ou financiamento do veículo, dias médios trabalhados por mês e
km médios por dia — base do rateio.

#### 2.5 Resultado: Tarifa Mínima

Calculado por `fn_calculate_cost_per_km()`, que existe em **Dart e em SQL** com a mesma fórmula, para que o
cálculo offline e os relatórios do servidor nunca divirjam:

```
custo_variavel_por_km = (preco_combustivel ÷ consumo)
                      + Σ(custo_item ÷ intervalo_km)
                      + manutencao_generica_por_km
                      + depreciacao_por_km

custo_fixo_por_km     = custos_fixos_mensais ÷ (dias_trabalhados_mes × km_por_dia)

custo_total_por_km    = custo_variavel_por_km + custo_fixo_por_km

tarifa_minima_rs_km   = custo_total_por_km × (1 + margem_desejada)
tarifa_minima_rs_hora = meta_diaria ÷ horas_trabalhadas_dia
```

---

### 3. 🎯 Metas e Perfis de Trabalho

#### 3.1 Definição de Metas
R$/km mínimo · R$/hora mínimo · nota mínima do passageiro · distância máxima até o embarque ·
meta diária de faturamento · meta mensal de faturamento · tolerância do "PENSE" (%) · margem desejada (%).

#### 3.2 Perfis de Trabalho (até 10)

| Perfil | Exemplo de uso |
|---|---|
| Diurno | Rodar de dia na cidade |
| Noturno | Tarifas dinâmicas, metas diferentes |
| Carro Próprio | Custos reais do veículo |
| Carro Alugado | Inclui custo de aluguel |
| Moto | Veículo diferente, custos menores |
| Fim de Semana | Metas mais altas, tarifas premium |

Cada perfil referencia um veículo e armazena suas próprias metas. **O limite de 10 é imposto no banco**
por trigger (`trg_enforce_work_profile_limit`), não apenas na UI — regra de negócio não se defende no cliente.

---

### 4. 📊 Histórico e Gestão Financeira

#### 4.1 Registro de Corridas
Log automático de cada corrida avaliada (aceita ou recusada), com data/hora, plataforma, valor,
distâncias, R$/km, R$/hora, lucro e veredicto.

#### 4.2 Fechamento de Caixa
Diário, semanal e mensal — calculado por *views* SQL (`v_daily_summary`, `v_monthly_summary`),
não por iteração no cliente.

#### 4.3 Despesas Adicionais
Alimentação · estacionamento · lavagem · pedágio · multas · manutenção avulsa · combustível (abastecimento real,
com litros e odômetro para aferir o consumo real contra o configurado).

#### 4.4 Gráficos e Estatísticas
Ganho médio por hora (linha) · aceitas vs. recusadas (pizza) · melhores horários (heatmap) ·
faturamento acumulado vs. meta · comparativo entre plataformas.

---

### 5. 🔔 Notificações por Voz (TTS)

- 🟢 "Corrida boa! R$ 2,80 por km"
- 🟡 "Atenção! Corrida na média, avalie"
- 🔴 "Corrida ruim. R$ 1,10 por km, abaixo do custo"

Configurável: ativar/desativar, volume, velocidade. Idioma pt-BR. **Respeita o canal de áudio de
navegação** (*audio focus* transitório, `AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK`) para não atropelar a
instrução do Waze — detalhe de segurança viária, não de conforto.

---

### 6. 🗺️ Integração com Navegação
Botão rápido para Waze e Google Maps, com o destino do passageiro quando disponível
(`waze://?ll=lat,lon&navigate=yes` e `google.navigation:q=`, com fallback para a Play Store se o app não
estiver instalado).

---

## 📲 Telas do Aplicativo

### Fluxo de Onboarding
`Splash → Boas-vindas (3 slides) → Cadastro/Login → Veículo → Metas → Permissões → Home`

### Mapa de Telas

| ID | Tela | Conteúdo |
|---|---|---|
| **T01** | Splash | Logo animado, verificação de sessão (`onAuthStateChange`), redirecionamento |
| **T02** | Onboarding | 3–4 slides, "Próximo"/"Pular"/"Começar" |
| **T03** | Login / Cadastro | E-mail+senha, Google, Apple (iOS), recuperação de senha, trial de 7 dias |
| **T04** | Home / Dashboard | Toggle do serviço, resumo do dia, faturamento vs. meta, perfil ativo, últimas corridas, "Iniciar Trabalho" |
| **T05** | Overlay (Semáforo) | ⚠️ *Widget flutuante sobre outros apps, não é tela do app* |
| **T06** | Config. do Veículo | Dados, consumo, combustível, manutenção, depreciação, custos fixos, custo/km calculado |
| **T07** | Config. de Metas | R$/km, R$/hora, nota mínima, distância máxima, metas diária/mensal |
| **T08** | Perfis de Trabalho | Lista, criar/editar/duplicar/excluir, seletor de ativo |
| **T09** | Histórico | Lista cronológica paginada, filtros por data/plataforma/veredicto |
| **T10** | Fechamento de Caixa | Período, cards de bruto/despesas/líquido/corridas/horas/R$-hora, 3 gráficos |
| **T11** | Registro de Despesas | FAB "+", categorias, valor/data/descrição, lista do período |
| **T12** | Estatísticas | Heatmap por hora, comparativo de plataformas, evolução, taxa de aceitação |
| **T13** | Config. Gerais | Conta, assinatura, notificações, voz, overlay, apps monitorados, navegação, tema, permissões, sobre, sair/excluir conta |
| **T14** | Paywall | Trial, 3 planos, métodos de pagamento, garantia, lista de benefícios |
| **T15** | Permissões e Setup | Acessibilidade, overlay, bateria, notificações, localização — cada um com status, botão e justificativa |

---

## 🔧 Detalhamento Técnico

### Plataforma Android — Serviços Nativos

**AccessibilityService**
```
- Classe: RideCaptureAccessibilityService
- Função: capturar eventos de tela dos apps de transporte
- Dados lidos: apenas textos de valor, distância, tempo, nota e região
- Packages monitorados (lista fechada):
  - com.ubercab.driver        (Uber Driver)
  - com.nineninetaxi.driver   (99 Motorista)
  - com.indrive.passenger     (inDrive)
- Eventos: TYPE_WINDOW_CONTENT_CHANGED | TYPE_WINDOW_STATE_CHANGED
- Filtro: android:packageNames no accessibility_config.xml
          (não escutar o sistema inteiro — é requisito de política, não otimização)
- Implementação: MethodChannel (comandos) + EventChannel (stream de ofertas)
```

**Window Overlay (SYSTEM_ALERT_WINDOW)**
```
- Permissão: SYSTEM_ALERT_WINDOW
- Widget: WindowManager com TYPE_APPLICATION_OVERLAY
- Posição: configurável (topo/centro/inferior), arrastável com persistência
- Interação: FLAG_NOT_TOUCH_MODAL — touch-through fora da área do cartão
- Engine: flutter_overlay_window usa um FlutterEngine separado (ver §Desempenho)
```

**Foreground Service**
```
- Tipo: FOREGROUND_SERVICE_SPECIAL_USE (obrigatório no Android 14+)
- Notificação: "Rota Plus está ativo — Monitorando corridas"
- Bateria: REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, pedido com justificativa na T15
- Restart: START_STICKY; RECEIVE_BOOT_COMPLETED opcional e opt-in
```

### Plataforma iOS — Adaptações

| Android | iOS equivalente |
|---|---|
| AccessibilityService | ❌ indisponível — `UNNotificationServiceExtension` |
| System Overlay | ❌ indisponível — Rich Push Notification + Live Activity (iOS 16.1+) |
| Foreground Service | Background Modes (limitado) |

Fluxo iOS: o motorista recebe a notificação da plataforma → o Rota Plus intercepta via
`UNNotificationServiceExtension` → processa e devolve um cartão rico na notificação expandida.

> ⚠️ **Limitação iOS:** a experiência é estruturalmente inferior à do Android por restrição da Apple.
> Requer **iOS 17+**. A extensão tem orçamento de ~30 s e memória apertada (~24 MB): o cálculo precisa
> ser trivial e os custos do perfil precisam estar num **App Group** compartilhado, já pré-calculados.
> Nada de abrir o banco Drift nem o cliente Supabase dentro da extensão.

### Stack Tecnológico

| Camada | Tecnologia | Por quê |
|---|---|---|
| Framework | Flutter 3.x (Dart 3.x) | — |
| State Management | **Riverpod 2.x** (`Notifier`/`AsyncNotifier`) | `select` granular evita rebuild desnecessário |
| Navegação | **GoRouter** | Rotas declarativas, deep link do OAuth, guards |
| Backend | **Supabase** (Auth, Postgres, Storage, Realtime, Edge Functions) | — |
| Banco local | **Drift** (SQLite) | SQL tipado, *streams* reativos, migrations versionadas, roda em isolate |
| Modelos | **freezed** + `json_serializable` | Imutabilidade e `copyWith` |
| Pagamentos | **RevenueCat** (IAP) + Stripe/MercadoPago (PIX/cartão) | — |
| Push | FCM + APNs via Edge Function | — |
| Crash/Perf | **Sentry** (`sentry_flutter`) | Substitui Crashlytics |
| Analytics | PostHog **ou** tabela própria | Sem SDK proprietário |
| TTS | `flutter_tts` | — |
| Gráficos | `fl_chart` | — |
| Secrets locais | `flutter_secure_storage` | Keystore/Keychain para a sessão |
| Platform Channels | `MethodChannel` + `EventChannel` | — |
| Overlay Android | `flutter_overlay_window` | — |
| Acessibilidade Android | Kotlin nativo via Platform Channel | — |
| Temas | Material 3 (Material You) | — |
| Fontes | Sora (**empacotada** no app, não baixada em runtime) | Evita FOUT e dependência de rede |
| CI/CD | Codemagic ou Fastlane + GitHub Actions | — |
| Testes | `flutter_test`, `integration_test`, `mocktail` | — |

### Estrutura de Pastas

```
lib/
├── main.dart
├── bootstrap.dart                   # init Supabase, Drift, Sentry, DI
│
├── app/
│   ├── app.dart                     # MaterialApp.router + tema
│   ├── router.dart                  # GoRouter + guards de auth/entitlement
│   └── theme/
│       ├── app_theme.dart
│       ├── colors.dart
│       ├── typography.dart
│       └── breakpoints.dart         # ⬅ NOVO — responsividade
│
├── core/
│   ├── constants/
│   ├── utils/
│   ├── extensions/
│   ├── error/                       # ⬅ NOVO — Failure, Result<T>
│   ├── sync/                        # ⬅ NOVO — outbox, reconciliação
│   │   ├── outbox_repository.dart
│   │   ├── sync_engine.dart
│   │   └── conflict_resolver.dart
│   └── services/
│       ├── supabase_service.dart    # ⬅ substitui firebase_service
│       ├── tts_service.dart
│       ├── overlay_service.dart
│       ├── accessibility_bridge.dart
│       ├── navigation_launcher.dart
│       ├── connectivity_service.dart
│       └── entitlement_service.dart # ⬅ NOVO — free vs premium
│
├── data/
│   ├── local/                       # ⬅ NOVO — Drift
│   │   ├── database.dart
│   │   ├── tables/
│   │   └── daos/
│   └── remote/
│       └── supabase/                # mapeadores row ⇄ model
│
├── features/
│   ├── auth/            { data, domain, presentation }
│   ├── onboarding/      { presentation }
│   ├── dashboard/       { data, domain, presentation }
│   ├── semaphore/                   # CORE
│   │   ├── data/models/{ride_offer, ride_evaluation}.dart
│   │   ├── domain/usecases/{evaluate_ride, calculate_metrics}.dart
│   │   └── presentation/{overlay_card.dart, controllers/}
│   ├── vehicle/         { data, domain, presentation }
│   ├── goals/           { data, domain, presentation }
│   ├── profiles/        { data, domain, presentation }
│   ├── history/         { data, domain, presentation }
│   ├── financial/       { data, domain, presentation }
│   ├── expenses/        { data, domain, presentation }
│   ├── statistics/      { data, domain, presentation }
│   ├── subscription/    { data, domain, presentation }
│   └── settings/        { data, domain, presentation }
│
├── overlay/                         # ⬅ NOVO — entrypoint do engine do overlay
│   └── overlay_main.dart            # @pragma('vm:entry-point')
│
└── shared/
    ├── widgets/{semaphore_badge, metric_card, platform_icon, adaptive_scaffold}.dart
    └── models/

supabase/                            # ⬅ NOVO
├── config.toml
├── migrations/
│   ├── 0001_extensions_and_enums.sql
│   ├── 0002_core_schema.sql
│   ├── 0003_rls_policies.sql
│   ├── 0004_functions_and_triggers.sql
│   ├── 0005_views_and_reports.sql
│   └── 0006_cron_and_retention.sql
├── functions/
│   ├── revenuecat-webhook/
│   ├── stripe-webhook/
│   ├── check-ride-quota/
│   ├── delete-account/
│   ├── export-my-data/
│   ├── send-push/
│   └── _shared/
└── seed.sql

android/app/src/main/
├── kotlin/.../
│   ├── RideCaptureAccessibilityService.kt
│   ├── OverlayServiceImpl.kt
│   ├── MonitoringForegroundService.kt
│   └── parsers/{UberParser, NoveNoveParser, InDriveParser}.kt
├── res/xml/accessibility_config.xml
└── AndroidManifest.xml

ios/
├── Runner/
└── NotificationServiceExtension/
```

---

## 🔐 Segurança da Informação

> Esta seção é normativa. Nenhum item marcado **OBRIGATÓRIO** pode ir para produção pendente.

### S1. Modelo de confiança

O app é **cliente não confiável**. Toda regra que proteja receita ou dados de terceiros vive no Postgres
ou numa Edge Function. O que roda no dispositivo é conveniência de UX, nunca a fonte de autoridade.

| Regra | Onde é imposta | Por quê |
|---|---|---|
| Usuário só vê os próprios dados | RLS no Postgres | O cliente pode ser modificado |
| Limite de 3 corridas/dia no Free | RPC `rpc_consume_ride_quota` | Contagem no cliente é burlável |
| Limite de 10 perfis de trabalho | Trigger no Postgres | Idem |
| Status da assinatura | Tabela `subscriptions`, escrita **só** por `service_role` via webhook assinado | O cliente não pode se auto-promover a premium |
| Retenção de 7 dias no Free | `pg_cron` + filtro por entitlement | Evita custo de storage e respeita o plano |

### S2. Chaves e segredos — **OBRIGATÓRIO**

| Chave | Pode ir no app? | Onde fica |
|---|---|---|
| `SUPABASE_URL` | ✅ | `--dart-define` |
| `SUPABASE_ANON_KEY` (publishable) | ✅ — ela **só** é segura se a RLS estiver correta | `--dart-define` |
| `SUPABASE_SERVICE_ROLE_KEY` | 🚫 **NUNCA** | Secrets da Edge Function / CI |
| Stripe secret key | 🚫 **NUNCA** | Edge Function |
| RevenueCat secret API key | 🚫 **NUNCA** | Edge Function |
| RevenueCat *public* SDK key | ✅ | `--dart-define` |

- Nenhum segredo em `pubspec.yaml`, `strings.xml`, `Info.plist` ou commit. `.env` em `.gitignore`.
- CI injeta via `--dart-define-from-file=env/prod.json`, gerado a partir de *secrets* do runner.
- Varredura de segredos no pipeline (`gitleaks`) bloqueando o merge.

### S3. Autenticação

- **PKCE obrigatório** no Flutter (`authFlowType: AuthFlowType.pkce`) — sem *implicit flow*.
- Sessão persistida em `flutter_secure_storage` (Keystore/Keychain), **não** em `SharedPreferences`.
- JWT de acesso curto (**1 h**) + *refresh token rotation* habilitada.
- Senha mínima de 10 caracteres + **leaked password protection** (HaveIBeenPwned) ativada no painel.
- Rate limit de login/OTP configurado; CAPTCHA (hCaptcha) ativado no signup.
- `Redirect URLs` restritas a `io.r2b.rotaplus://login-callback` e ao domínio da landing. **Sem wildcard.**
- MFA (TOTP) disponível em Configurações, opcional para o usuário.
- **Apple Sign-In obrigatório** no iOS se houver qualquer login social (regra da App Store).

### S4. Dados sensíveis e LGPD

| Classe de dado | Tratamento |
|---|---|
| Texto bruto da tela de terceiros | Em memória, descartado após o parse. **Nunca** em disco, log ou rede. |
| Nome/telefone do passageiro | Descartado no parser, antes de qualquer persistência. |
| Endereço completo do passageiro | Não persistido. Só o nome do bairro/região. |
| Localização GPS | Opt-in explícito; agregada por *geohash* de 6 dígitos (~1 km²) antes de subir. |
| E-mail e nome do motorista | `public.profiles`, sob RLS. |
| Placa do veículo | Só os **4 últimos caracteres**, para o motorista reconhecer o veículo na lista. |
| Dados de pagamento | **Nunca tocam o nosso backend.** Stripe/RevenueCat/lojas processam. Guardamos só IDs opacos. |

**Direitos do titular (LGPD arts. 18–20):**
- **Exportação:** Edge Function `export-my-data` devolve um ZIP com JSON/CSV de tudo do usuário.
- **Exclusão:** Edge Function `delete-account` → *soft delete* imediato (`deleted_at`), purga definitiva
  em 30 dias por `pg_cron`, incluindo `auth.users` via Admin API. Registro em `audit_log`.
- **Transparência:** a T15 explica *em linguagem simples* por que a acessibilidade é necessária, e a
  *prominent disclosure* exigida pelo Google Play aparece **antes** do pedido de permissão.
- Base legal: execução de contrato (art. 7º, V) para dados de operação; consentimento para localização e marketing.

### S5. Políticas de loja — risco de remoção

> ⚠️ Este é o maior risco do projeto, não um detalhe de compliance.

- **Google Play — AccessibilityService:** o uso precisa ser declarado no formulário de *Permissions*, com
  vídeo demonstrando a funcionalidade. A política exige que a acessibilidade seja a *única* forma viável de
  entregar o recurso e que haja *prominent disclosure* in-app. Manter o `accessibility_config.xml`
  restrito aos 3 packages reduz o risco de ser interpretado como "captura ampla de tela".
- Não usar `canRetrieveWindowContent` em pacotes fora da lista; **não logar nada capturado**, nem em debug.
- Manter uma versão de contingência com **entrada manual** dos dados da corrida, caso a permissão seja
  revogada — é o que mantém o app publicável se a política mudar.

### S6. Hardening do backend — **OBRIGATÓRIO**

```sql
-- Nada é acessível por padrão; só o que for explicitamente concedido.
revoke all on schema public from anon, authenticated;
grant usage on schema public to anon, authenticated;
alter default privileges in schema public revoke all on tables from anon, authenticated;
```

- RLS **habilitada em 100% das tabelas** de `public`, inclusive as de apoio. O CI falha se existir tabela
  com `relrowsecurity = false` (consulta de verificação em §Testes).
- Toda função `security definer` declara `set search_path = ''` e usa nomes qualificados (`public.x`,
  `auth.uid()`) — defesa contra *search_path hijacking*.
- `anon` não tem `INSERT`/`UPDATE`/`DELETE` em nenhuma tabela.
- Edge Functions validam a **assinatura** do webhook (Stripe `Stripe-Signature`, RevenueCat
  `Authorization`) antes de qualquer efeito, e são idempotentes por `external_id` em `webhook_events`.
- `pg_net`/`http` não expostos a `authenticated`.
- Backups: PITR habilitado (plano Pro). Teste de restauração trimestral, documentado.
- Observabilidade: alerta em taxa de 4xx/5xx das Edge Functions e em `pg_stat_statements` para query lenta.

### S7. Segurança no dispositivo

- `flutter_secure_storage` para sessão e tokens.
- **`android:allowBackup="false"`** — sem isso o banco financeiro local vaza num backup ADB.
- `FLAG_SECURE` nas telas de paywall e de conta (evita screenshot por outros apps).
- Ofuscação: `flutter build --obfuscate --split-debug-info=build/symbols`.
- Sem `print()` em release — lint `avoid_print` como **erro**; logging por wrapper que é no-op em release.
- Certificate pinning: **opcional**, avaliado contra o custo de rotação de certificado do Supabase.
- Checagem de root/jailbreak: **não implementar** — falso positivo alto e ganho baixo para este modelo de ameaça.

---

## 🗄️ Banco de Dados — Modelagem

### Convenções

| Convenção | Decisão |
|---|---|
| Nomes | `snake_case`, tabelas no plural |
| Chaves primárias | `uuid` com `gen_random_uuid()` — geráveis no cliente, essencial para offline |
| Dinheiro | `numeric(12,2)` — exato. **Nunca `float`/`double`** |
| Distância / consumo | `numeric(10,3)` |
| Timestamps | `timestamptz`, sempre UTC; conversão para `America/Boa_Vista` só na borda de apresentação |
| Dono do registro | Coluna `user_id uuid not null` em **toda** tabela de usuário, para a RLS não precisar de `JOIN` |
| Auditoria | `created_at`, `updated_at` (trigger), `deleted_at` (soft delete) |
| Idempotência de sync | `client_id uuid` único por usuário, gerado no app |
| Enums | tipos `enum` nativos do Postgres — compactos e validados no banco |

### Diagrama de relacionamentos

```
auth.users (gerenciado pelo Supabase)
   │ 1:1
   ▼
profiles ──1:N──► vehicles ──1:N──► maintenance_items
   │                  │
   │                  └──1:N──► fixed_costs
   │
   ├──1:N──► work_profiles (máx. 10) ──► vehicle_id (FK)
   │              │
   │              └──1:N──► ride_evaluations
   │
   ├──1:N──► work_sessions
   ├──1:N──► expenses
   ├──1:N──► ride_evaluations      (particionada por mês)
   ├──1:1──► subscriptions         (escrita só por service_role)
   ├──1:1──► ride_quota_usage      (por dia)
   ├──1:N──► device_push_tokens
   ├──1:N──► coupon_redemptions ──► coupons
   └──1:N──► audit_log

Views: v_daily_summary · v_monthly_summary · v_platform_comparison · v_hour_heatmap
```

### Por que relacional ganha do Firestore aqui

O fechamento de caixa mensal no Firestore exigia baixar todas as corridas do mês e somar no cliente —
custo de leitura, de dados móveis e de bateria. Em Postgres é uma única `GROUP BY` que volta ~30 linhas.
Para um motorista com milhares de corridas por mês, essa é a diferença entre um relatório instantâneo e
uma tela de *loading* de vários segundos sobre dados móveis.

---
## 📜 Schema SQL Inicial e Policies de RLS

> Os blocos abaixo são o conteúdo literal dos arquivos em `supabase/migrations/`, que são a
> fonte única de verdade. Aplicar com `supabase db push` (ou `supabase start` no ambiente local).
> A ordem dos arquivos importa: enums antes do schema, schema antes das policies.

### `0001_extensions_and_enums.sql`

```sql
-- ============================================================================
-- Rota Plus · 0001 · Extensões, enums e utilidades
-- ============================================================================

create extension if not exists "pgcrypto";             -- gen_random_uuid()
create extension if not exists "pg_cron";              -- jobs de retenção/agregação
create extension if not exists "pg_stat_statements";   -- diagnóstico de query lenta
-- create extension if not exists "postgis";           -- Fase 5: heatmap de regiões

-- ---------------------------------------------------------------- enums ----
create type public.fuel_type as enum (
  'gasoline', 'ethanol', 'flex', 'cng', 'diesel', 'electric'
);

create type public.ride_platform as enum (
  'uber', 'ninety_nine', 'indrive', 'other'
);

create type public.ride_verdict as enum ('accept', 'think', 'reject');

create type public.ride_outcome as enum (
  'accepted', 'rejected', 'expired', 'unknown'
);

create type public.expense_category as enum (
  'fuel', 'food', 'car_wash', 'parking', 'maintenance', 'toll', 'fine', 'rent', 'other'
);

create type public.maintenance_kind as enum (
  'oil_change', 'tires', 'brake_pads', 'suspension', 'filters', 'generic'
);

create type public.fixed_cost_kind as enum (
  'ipva', 'insurance', 'licensing', 'vehicle_rent', 'financing', 'other'
);

create type public.subscription_plan as enum ('free', 'monthly', 'quarterly', 'annual');

create type public.subscription_status as enum (
  'trialing', 'active', 'past_due', 'canceled', 'expired'
);

create type public.payment_provider as enum (
  'revenuecat', 'stripe', 'mercadopago', 'manual'
);

-- -------------------------------------------- trigger utilitária: touch ----
create or replace function public.fn_touch_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- --------------------------------- hardening: nada liberado por padrão ----
revoke all on schema public from anon, authenticated;
grant usage on schema public to anon, authenticated;
alter default privileges in schema public revoke all on tables from anon, authenticated;
```

### `0002_core_schema.sql`

```sql
-- ============================================================================
-- Rota Plus · 0002 · Schema principal
-- ============================================================================

-- ----------------------------------------------------------------------------
-- profiles — espelho de auth.users com dados de aplicação
-- ----------------------------------------------------------------------------
create table public.profiles (
  id                uuid primary key references auth.users (id) on delete cascade,
  full_name         text check (length(full_name) <= 120),
  email             text,
  avatar_path       text,                      -- caminho no bucket, não URL pública
  phone             text,
  city              text,
  state_uf          char(2),
  tts_enabled       boolean      not null default true,
  tts_rate          numeric(3,2) not null default 1.00
                      check (tts_rate between 0.50 and 2.00),
  theme_mode        text         not null default 'system'
                      check (theme_mode in ('light', 'dark', 'system')),
  nav_app           text         not null default 'waze'
                      check (nav_app in ('waze', 'google_maps')),
  overlay_position  text         not null default 'top'
                      check (overlay_position in ('top', 'center', 'bottom')),
  overlay_timeout_s smallint     not null default 8
                      check (overlay_timeout_s between 3 and 60),
  onboarding_done   boolean      not null default false,
  accepted_terms_at timestamptz,
  created_at        timestamptz  not null default now(),
  updated_at        timestamptz  not null default now(),
  deleted_at        timestamptz
);

comment on table public.profiles is
  'Dados de aplicação do motorista. Nunca armazena dado de passageiro.';

-- ----------------------------------------------------------------------------
-- vehicles
-- ----------------------------------------------------------------------------
create table public.vehicles (
  id                         uuid primary key default gen_random_uuid(),
  user_id                    uuid not null references public.profiles (id) on delete cascade,
  client_id                  uuid not null,                 -- idempotência de sync
  nickname                   text not null check (length(nickname) between 1 and 60),
  make                       text,
  model                      text,
  model_year                 smallint check (model_year between 1950 and 2100),
  plate_suffix               char(4),       -- só os 4 últimos; nunca a placa cheia
  fuel                       public.fuel_type not null default 'flex',
  consumption_km_per_unit    numeric(10,3) not null
                               check (consumption_km_per_unit > 0),   -- km/l ou km/kWh
  fuel_price                 numeric(12,2) not null check (fuel_price >= 0),
  market_value               numeric(12,2) check (market_value >= 0), -- FIPE
  depreciation_per_km        numeric(12,4) not null default 0
                               check (depreciation_per_km >= 0),
  generic_maintenance_per_km numeric(12,4) not null default 0
                               check (generic_maintenance_per_km >= 0),
  work_days_per_month        smallint not null default 24
                               check (work_days_per_month between 1 and 31),
  km_per_day                 numeric(10,2) not null default 150
                               check (km_per_day > 0),
  is_default                 boolean not null default false,
  created_at                 timestamptz not null default now(),
  updated_at                 timestamptz not null default now(),
  deleted_at                 timestamptz,
  unique (user_id, client_id)
);

create index idx_vehicles_user on public.vehicles (user_id) where deleted_at is null;

-- ----------------------------------------------------------------------------
-- maintenance_items — custo + intervalo, rateado por km
-- ----------------------------------------------------------------------------
create table public.maintenance_items (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  vehicle_id  uuid not null references public.vehicles (id) on delete cascade,
  kind        public.maintenance_kind not null,
  label       text,
  cost        numeric(12,2) not null check (cost >= 0),
  interval_km numeric(10,2) not null check (interval_km > 0),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index idx_maint_vehicle on public.maintenance_items (vehicle_id);
create index idx_maint_user    on public.maintenance_items (user_id);

-- ----------------------------------------------------------------------------
-- fixed_costs
-- ----------------------------------------------------------------------------
create table public.fixed_costs (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references public.profiles (id) on delete cascade,
  vehicle_id     uuid not null references public.vehicles (id) on delete cascade,
  kind           public.fixed_cost_kind not null,
  label          text,
  annual_amount  numeric(12,2) check (annual_amount  >= 0),
  monthly_amount numeric(12,2) check (monthly_amount >= 0),
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  constraint chk_fixed_cost_amount
    check (annual_amount is not null or monthly_amount is not null)
);

create index idx_fixed_vehicle on public.fixed_costs (vehicle_id);
create index idx_fixed_user    on public.fixed_costs (user_id);

-- ----------------------------------------------------------------------------
-- work_profiles — metas + veículo (máx. 10 por usuário, imposto por trigger)
-- ----------------------------------------------------------------------------
create table public.work_profiles (
  id                   uuid primary key default gen_random_uuid(),
  user_id              uuid not null references public.profiles (id) on delete cascade,
  client_id            uuid not null,
  name                 text not null check (length(name) between 1 and 60),
  vehicle_id           uuid references public.vehicles (id) on delete set null,
  goal_rs_per_km       numeric(12,2) not null check (goal_rs_per_km   >= 0),
  goal_rs_per_hour     numeric(12,2) not null check (goal_rs_per_hour >= 0),
  min_passenger_rating numeric(3,2)  not null default 4.50
                         check (min_passenger_rating between 0 and 5),
  max_pickup_km        numeric(10,2) not null default 5 check (max_pickup_km >= 0),
  daily_revenue_goal   numeric(12,2) not null default 0 check (daily_revenue_goal   >= 0),
  monthly_revenue_goal numeric(12,2) not null default 0 check (monthly_revenue_goal >= 0),
  think_tolerance_pct  numeric(5,2)  not null default 15.00
                         check (think_tolerance_pct between 0 and 100),
  target_margin_pct    numeric(5,2)  not null default 30.00
                         check (target_margin_pct between 0 and 500),
  -- custo/km materializado: o overlay precisa de leitura O(1), sem recomputar nada
  cached_cost_per_km   numeric(12,4),
  cached_at            timestamptz,
  is_active            boolean not null default false,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  deleted_at           timestamptz,
  unique (user_id, client_id)
);

create index idx_wp_user on public.work_profiles (user_id) where deleted_at is null;

-- Só um perfil ativo por usuário — garantido por índice parcial, não por app
create unique index uq_wp_one_active
  on public.work_profiles (user_id)
  where is_active and deleted_at is null;

-- ----------------------------------------------------------------------------
-- work_sessions — horas trabalhadas reais (base do R$/hora do fechamento)
-- ----------------------------------------------------------------------------
create table public.work_sessions (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles (id) on delete cascade,
  client_id       uuid not null,
  work_profile_id uuid references public.work_profiles (id) on delete set null,
  started_at      timestamptz not null,
  ended_at        timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (user_id, client_id),
  constraint chk_session_order check (ended_at is null or ended_at > started_at)
);

create index idx_sessions_user_time
  on public.work_sessions (user_id, started_at desc);

-- ----------------------------------------------------------------------------
-- ride_evaluations — maior volume do sistema; PARTICIONADA por mês
-- ----------------------------------------------------------------------------
create table public.ride_evaluations (
  id               uuid not null default gen_random_uuid(),
  user_id          uuid not null references public.profiles (id) on delete cascade,
  client_id        uuid not null,
  work_profile_id  uuid references public.work_profiles (id) on delete set null,
  work_session_id  uuid references public.work_sessions (id) on delete set null,
  platform         public.ride_platform not null,
  occurred_at      timestamptz not null,

  -- dados capturados: apenas numéricos + nome da região
  fare             numeric(12,2) not null check (fare >= 0),
  pickup_km        numeric(10,3) not null check (pickup_km >= 0),
  trip_km          numeric(10,3) not null check (trip_km   >= 0),
  pickup_minutes   numeric(10,2) not null default 0 check (pickup_minutes >= 0),
  trip_minutes     numeric(10,2) not null default 0 check (trip_minutes   >= 0),
  passenger_rating numeric(3,2) check (passenger_rating between 0 and 5),
  pickup_region    text check (length(pickup_region) <= 120),
  surge_multiplier numeric(5,2) check (surge_multiplier >= 0),

  -- métricas derivadas, gravadas para não recalcular em relatório
  total_km         numeric(10,3) generated always as (pickup_km + trip_km) stored,
  total_minutes    numeric(10,2) generated always as (pickup_minutes + trip_minutes) stored,
  rs_per_km        numeric(12,4) not null,
  rs_per_hour      numeric(12,4) not null,
  cost_per_km_used numeric(12,4) not null,
  operating_cost   numeric(12,2) not null,
  real_profit      numeric(12,2) not null,
  margin_pct       numeric(7,2),

  verdict          public.ride_verdict not null,
  outcome          public.ride_outcome not null default 'unknown',

  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),

  primary key (id, occurred_at)
) partition by range (occurred_at);

comment on table public.ride_evaluations is
  'Uma linha por corrida avaliada. Particionada por mês: habilita poda de partição '
  'nos relatórios e DROP instantâneo na retenção, em vez de DELETE de milhões de linhas.';

-- Partições iniciais (as futuras são criadas por pg_cron — ver 0006)
create table public.ride_evaluations_2026_10
  partition of public.ride_evaluations
  for values from ('2026-10-01') to ('2026-11-01');
create table public.ride_evaluations_2026_11
  partition of public.ride_evaluations
  for values from ('2026-11-01') to ('2026-12-01');
create table public.ride_evaluations_2026_12
  partition of public.ride_evaluations
  for values from ('2026-12-01') to ('2027-01-01');

-- user_id SEMPRE primeiro: é a coluna que a RLS filtra
create index idx_rides_user_time
  on public.ride_evaluations (user_id, occurred_at desc);
create index idx_rides_user_platform
  on public.ride_evaluations (user_id, platform, occurred_at desc);
create index idx_rides_user_verdict
  on public.ride_evaluations (user_id, verdict, occurred_at desc);
create unique index uq_rides_user_client
  on public.ride_evaluations (user_id, client_id, occurred_at);

-- ----------------------------------------------------------------------------
-- expenses
-- ----------------------------------------------------------------------------
create table public.expenses (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles (id) on delete cascade,
  client_id       uuid not null,
  vehicle_id      uuid references public.vehicles (id) on delete set null,
  work_session_id uuid references public.work_sessions (id) on delete set null,
  category        public.expense_category not null,
  amount          numeric(12,2) not null check (amount >= 0),
  liters          numeric(10,3) check (liters >= 0),      -- abastecimento real
  odometer_km     numeric(12,1) check (odometer_km >= 0),
  description     text check (length(description) <= 500),
  receipt_path    text,                                   -- bucket privado
  occurred_at     timestamptz not null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  deleted_at      timestamptz,
  unique (user_id, client_id)
);

create index idx_expenses_user_time
  on public.expenses (user_id, occurred_at desc) where deleted_at is null;
create index idx_expenses_user_category
  on public.expenses (user_id, category, occurred_at desc);

-- ----------------------------------------------------------------------------
-- subscriptions — SOMENTE service_role escreve (webhook assinado)
-- ----------------------------------------------------------------------------
create table public.subscriptions (
  user_id              uuid primary key references public.profiles (id) on delete cascade,
  plan                 public.subscription_plan   not null default 'free',
  status               public.subscription_status not null default 'trialing',
  provider             public.payment_provider,
  provider_customer_id text,
  provider_sub_id      text,
  trial_ends_at        timestamptz,
  current_period_end   timestamptz,
  cancel_at_period_end boolean not null default false,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

create index idx_subs_status on public.subscriptions (status, current_period_end);

comment on table public.subscriptions is
  'Fonte única de verdade do entitlement. O cliente só LÊ. Qualquer escrita vem de '
  'Edge Function com service_role, após validar assinatura do webhook.';

-- ----------------------------------------------------------------------------
-- ride_quota_usage — contador diário do plano Free
-- ----------------------------------------------------------------------------
create table public.ride_quota_usage (
  user_id    uuid not null references public.profiles (id) on delete cascade,
  usage_date date not null,
  used_count integer not null default 0 check (used_count >= 0),
  primary key (user_id, usage_date)
);

-- ----------------------------------------------------------------------------
-- coupons / coupon_redemptions
-- ----------------------------------------------------------------------------
create table public.coupons (
  code            text primary key check (code = upper(code)),
  description     text,
  discount_pct    smallint check (discount_pct between 1 and 100),
  free_days       smallint check (free_days between 1 and 365),
  max_redemptions integer,
  redeemed_count  integer not null default 0,
  valid_from      timestamptz not null default now(),
  valid_until     timestamptz,
  influencer_tag  text,
  is_active       boolean not null default true,
  created_at      timestamptz not null default now(),
  constraint chk_coupon_benefit
    check (discount_pct is not null or free_days is not null)
);

create table public.coupon_redemptions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  coupon_code text not null references public.coupons (code),
  redeemed_at timestamptz not null default now(),
  unique (user_id, coupon_code)
);

-- ----------------------------------------------------------------------------
-- device_push_tokens
-- ----------------------------------------------------------------------------
create table public.device_push_tokens (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references public.profiles (id) on delete cascade,
  token        text not null unique,
  platform     text not null check (platform in ('android', 'ios')),
  app_version  text,
  last_seen_at timestamptz not null default now(),
  created_at   timestamptz not null default now()
);

create index idx_tokens_user on public.device_push_tokens (user_id);

-- ----------------------------------------------------------------------------
-- webhook_events — idempotência; nunca exposta ao cliente
-- ----------------------------------------------------------------------------
create table public.webhook_events (
  id           uuid primary key default gen_random_uuid(),
  provider     public.payment_provider not null,
  external_id  text not null,
  payload      jsonb not null,
  processed_at timestamptz,
  error        text,
  received_at  timestamptz not null default now(),
  unique (provider, external_id)
);

-- ----------------------------------------------------------------------------
-- audit_log — rastro de ações sensíveis
-- ----------------------------------------------------------------------------
create table public.audit_log (
  id         bigserial primary key,
  user_id    uuid,
  action     text not null,
  table_name text,
  record_id  text,
  metadata   jsonb,
  created_at timestamptz not null default now()
);

create index idx_audit_user_time on public.audit_log (user_id, created_at desc);

-- ----------------------------------------------------------------------------
-- updated_at automático
-- ----------------------------------------------------------------------------
do $$
declare
  t text;
begin
  foreach t in array array[
    'profiles', 'vehicles', 'maintenance_items', 'fixed_costs', 'work_profiles',
    'work_sessions', 'ride_evaluations', 'expenses', 'subscriptions'
  ]
  loop
    execute format(
      'create trigger trg_touch_%1$s before update on public.%1$s
         for each row execute function public.fn_touch_updated_at()', t);
  end loop;
end $$;
```

### `0003_rls_policies.sql`

```sql
-- ============================================================================
-- Rota Plus · 0003 · Row Level Security
-- ============================================================================
-- Princípios:
--   1. RLS habilitada em TODAS as tabelas de public, sem exceção.
--   2. Uma policy por comando (select/insert/update/delete) — mais legível e
--      auditável do que uma policy "for all".
--   3. `(select auth.uid())` em vez de `auth.uid()`: o planner trata como
--      InitPlan e avalia UMA vez por query, não uma vez por linha. Em tabela de
--      centenas de milhares de linhas isso muda a ordem de grandeza do tempo.
--   4. `to authenticated` sempre explícito — nunca deixar `anon` cair numa policy.
--   5. Toda coluna usada em policy é indexada (ver 0002).
-- ============================================================================

alter table public.profiles            enable row level security;
alter table public.vehicles            enable row level security;
alter table public.maintenance_items   enable row level security;
alter table public.fixed_costs         enable row level security;
alter table public.work_profiles       enable row level security;
alter table public.work_sessions       enable row level security;
alter table public.ride_evaluations    enable row level security;
alter table public.expenses            enable row level security;
alter table public.subscriptions       enable row level security;
alter table public.ride_quota_usage    enable row level security;
alter table public.coupons             enable row level security;
alter table public.coupon_redemptions  enable row level security;
alter table public.device_push_tokens  enable row level security;
alter table public.webhook_events      enable row level security;
alter table public.audit_log           enable row level security;

-- Defesa extra: nem o dono da tabela escapa da RLS por engano.
alter table public.subscriptions    force row level security;
alter table public.ride_quota_usage force row level security;
alter table public.webhook_events   force row level security;

-- ----------------------------------------------------------------------------
-- Grants: a RLS filtra LINHAS, o grant libera a OPERAÇÃO. Precisa dos dois.
-- ----------------------------------------------------------------------------
grant select, insert, update, delete on
  public.vehicles, public.maintenance_items, public.fixed_costs,
  public.work_profiles, public.work_sessions, public.ride_evaluations,
  public.expenses, public.device_push_tokens
  to authenticated;

grant select, update on public.profiles to authenticated;
grant select on public.subscriptions, public.ride_quota_usage, public.coupons to authenticated;
grant select, insert on public.coupon_redemptions to authenticated;
grant select on public.audit_log to authenticated;

-- `anon` não recebe nada em nenhuma tabela. Login e signup passam por auth.*.

-- ----------------------------------------------------------------------------
-- profiles
-- ----------------------------------------------------------------------------
create policy "profiles_select_own" on public.profiles
  for select to authenticated
  using ((select auth.uid()) = id and deleted_at is null);

create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using ((select auth.uid()) = id and deleted_at is null)
  with check ((select auth.uid()) = id);

-- INSERT não tem policy de propósito: o profile nasce pelo trigger
-- on_auth_user_created (0004). DELETE também não: exclusão passa pela
-- Edge Function delete-account, que faz soft delete + purga agendada.

-- ----------------------------------------------------------------------------
-- Macro para as tabelas cujo dono é simplesmente user_id
-- ----------------------------------------------------------------------------
do $$
declare
  t text;
begin
  foreach t in array array[
    'vehicles', 'maintenance_items', 'fixed_costs', 'work_profiles',
    'work_sessions', 'ride_evaluations', 'expenses', 'device_push_tokens'
  ]
  loop
    execute format($f$
      create policy "%1$s_select_own" on public.%1$s
        for select to authenticated
        using ((select auth.uid()) = user_id);

      create policy "%1$s_insert_own" on public.%1$s
        for insert to authenticated
        with check ((select auth.uid()) = user_id);

      create policy "%1$s_update_own" on public.%1$s
        for update to authenticated
        using ((select auth.uid()) = user_id)
        with check ((select auth.uid()) = user_id);

      create policy "%1$s_delete_own" on public.%1$s
        for delete to authenticated
        using ((select auth.uid()) = user_id);
    $f$, t);
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- subscriptions — leitura própria; escrita é privilégio de service_role
-- ----------------------------------------------------------------------------
create policy "subscriptions_select_own" on public.subscriptions
  for select to authenticated
  using ((select auth.uid()) = user_id);

-- Sem policy de insert/update/delete para `authenticated`:
-- é exatamente isso que impede o usuário de se tornar premium sozinho.
-- service_role ignora RLS por definição e é usado só dentro das Edge Functions.

-- ----------------------------------------------------------------------------
-- ride_quota_usage — o usuário lê o próprio consumo; o incremento é via RPC
-- ----------------------------------------------------------------------------
create policy "quota_select_own" on public.ride_quota_usage
  for select to authenticated
  using ((select auth.uid()) = user_id);

-- ----------------------------------------------------------------------------
-- coupons — só cupom válido é visível, e nunca a contagem de outros
-- ----------------------------------------------------------------------------
create policy "coupons_select_active" on public.coupons
  for select to authenticated
  using (
    is_active
    and valid_from <= now()
    and (valid_until is null or valid_until > now())
    and (max_redemptions is null or redeemed_count < max_redemptions)
  );

create policy "redemptions_select_own" on public.coupon_redemptions
  for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "redemptions_insert_own" on public.coupon_redemptions
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

-- ----------------------------------------------------------------------------
-- audit_log — o titular enxerga o próprio rastro (transparência LGPD)
-- ----------------------------------------------------------------------------
create policy "audit_select_own" on public.audit_log
  for select to authenticated
  using ((select auth.uid()) = user_id);

-- ----------------------------------------------------------------------------
-- webhook_events — nenhuma policy. Tabela cega para o cliente.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Storage: buckets privados, um "diretório" por usuário
-- ----------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('avatars',  'avatars',  false, 2097152,  array['image/jpeg','image/png','image/webp']),
  ('receipts', 'receipts', false, 5242880,  array['image/jpeg','image/png','image/webp','application/pdf'])
on conflict (id) do nothing;

-- Convenção de caminho: <uid>/<arquivo>. A policy compara o primeiro segmento.
create policy "storage_read_own" on storage.objects
  for select to authenticated
  using (
    bucket_id in ('avatars', 'receipts')
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "storage_insert_own" on storage.objects
  for insert to authenticated
  with check (
    bucket_id in ('avatars', 'receipts')
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "storage_update_own" on storage.objects
  for update to authenticated
  using (
    bucket_id in ('avatars', 'receipts')
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "storage_delete_own" on storage.objects
  for delete to authenticated
  using (
    bucket_id in ('avatars', 'receipts')
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

-- ----------------------------------------------------------------------------
-- Verificação de conformidade — roda no CI, falha o build se houver furo
-- ----------------------------------------------------------------------------
-- select c.relname
--   from pg_class c
--   join pg_namespace n on n.oid = c.relnamespace
--  where n.nspname = 'public'
--    and c.relkind = 'r'
--    and not c.relrowsecurity;
-- Resultado esperado: 0 linhas.
```

### `0004_functions_and_triggers.sql`

```sql
-- ============================================================================
-- Rota Plus · 0004 · Funções e triggers
-- ============================================================================
-- Toda função `security definer` declara `set search_path = ''` e qualifica os
-- nomes. Sem isso, um schema malicioso no search_path do chamador pode
-- sequestrar a resolução de nome e executar código com privilégio do dono.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Criação automática de profile + assinatura trial no signup
-- ----------------------------------------------------------------------------
create or replace function public.fn_handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, full_name, avatar_path)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name',
             new.raw_user_meta_data ->> 'name'),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;

  insert into public.subscriptions (user_id, plan, status, trial_ends_at)
  values (new.id, 'free', 'trialing', now() + interval '7 days')
  on conflict (user_id) do nothing;

  insert into public.audit_log (user_id, action, metadata)
  values (new.id, 'account.created', jsonb_build_object('provider',
          new.raw_app_meta_data ->> 'provider'));

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.fn_handle_new_user();

-- ----------------------------------------------------------------------------
-- 2. Limite de 10 perfis de trabalho — regra de negócio no banco
-- ----------------------------------------------------------------------------
create or replace function public.fn_enforce_work_profile_limit()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  total integer;
begin
  select count(*) into total
    from public.work_profiles
   where user_id = new.user_id
     and deleted_at is null;

  if total >= 10 then
    raise exception 'Limite de 10 perfis de trabalho atingido.'
      using errcode = 'check_violation';
  end if;

  return new;
end;
$$;

create trigger trg_enforce_work_profile_limit
  before insert on public.work_profiles
  for each row execute function public.fn_enforce_work_profile_limit();

-- ----------------------------------------------------------------------------
-- 3. Custo por km — a MESMA fórmula que roda em Dart, aqui para relatórios
-- ----------------------------------------------------------------------------
create or replace function public.fn_calculate_cost_per_km(p_vehicle_id uuid)
returns numeric
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
  v            public.vehicles;
  maint_per_km numeric(12,4) := 0;
  fixed_month  numeric(12,2) := 0;
  fixed_per_km numeric(12,4) := 0;
begin
  select * into v from public.vehicles where id = p_vehicle_id;
  if not found then
    return null;
  end if;

  -- manutenção detalhada: soma de custo/intervalo de cada item
  select coalesce(sum(cost / interval_km), 0) into maint_per_km
    from public.maintenance_items
   where vehicle_id = p_vehicle_id;

  -- custos fixos normalizados para o mês
  select coalesce(sum(coalesce(monthly_amount, annual_amount / 12.0)), 0)
    into fixed_month
    from public.fixed_costs
   where vehicle_id = p_vehicle_id;

  fixed_per_km := fixed_month / nullif(v.work_days_per_month * v.km_per_day, 0);

  return round(
      (v.fuel_price / v.consumption_km_per_unit)
    + maint_per_km
    + v.generic_maintenance_per_km
    + v.depreciation_per_km
    + coalesce(fixed_per_km, 0)
  , 4);
end;
$$;

grant execute on function public.fn_calculate_cost_per_km(uuid) to authenticated;

-- ----------------------------------------------------------------------------
-- 4. Invalidação do custo cacheado nos perfis quando o veículo muda
-- ----------------------------------------------------------------------------
-- Duas funções, porque NEW/OLD têm formatos diferentes: em `vehicles` o veículo é
-- `id`, nas tabelas de custo é `vehicle_id`. Uma função só para as duas daria
-- "record new has no field vehicle_id" em tempo de execução.
create or replace function public.fn_invalidate_cost_cache_by_vehicle()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  update public.work_profiles
     set cached_cost_per_km = null,
         cached_at          = null
   where vehicle_id = coalesce(new.id, old.id);
  return coalesce(new, old);
end;
$$;

create or replace function public.fn_invalidate_cost_cache_by_cost_row()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  update public.work_profiles
     set cached_cost_per_km = null,
         cached_at          = null
   where vehicle_id = coalesce(new.vehicle_id, old.vehicle_id);
  return coalesce(new, old);
end;
$$;

create trigger trg_invalidate_cache_vehicle
  after update or delete on public.vehicles
  for each row execute function public.fn_invalidate_cost_cache_by_vehicle();

create trigger trg_invalidate_cache_maint
  after insert or update or delete on public.maintenance_items
  for each row execute function public.fn_invalidate_cost_cache_by_cost_row();

create trigger trg_invalidate_cache_fixed
  after insert or update or delete on public.fixed_costs
  for each row execute function public.fn_invalidate_cost_cache_by_cost_row();

-- ----------------------------------------------------------------------------
-- 5. Entitlement — fonte única de verdade sobre "é premium?"
-- ----------------------------------------------------------------------------
create or replace function public.fn_is_premium(p_user_id uuid default null)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
      from public.subscriptions s
     where s.user_id = coalesce(p_user_id, (select auth.uid()))
       and (
            (s.status = 'active'   and (s.current_period_end is null
                                        or s.current_period_end > now()))
         or (s.status = 'trialing' and s.trial_ends_at is not null
                                   and s.trial_ends_at > now())
       )
  );
$$;

grant execute on function public.fn_is_premium(uuid) to authenticated;

-- ----------------------------------------------------------------------------
-- 6. Quota do plano Free — 3 avaliações/dia, contadas no servidor
-- ----------------------------------------------------------------------------
create or replace function public.rpc_consume_ride_quota()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid     uuid := (select auth.uid());
  v_premium boolean;
  v_used    integer;
  c_limit   constant integer := 3;
begin
  if v_uid is null then
    raise exception 'Não autenticado.' using errcode = '28000';
  end if;

  v_premium := public.fn_is_premium(v_uid);
  if v_premium then
    return jsonb_build_object('allowed', true, 'premium', true, 'remaining', null);
  end if;

  -- UPSERT atômico: duas requisições simultâneas não furam o limite.
  -- O alias `q` é necessário: dentro de ON CONFLICT ... DO UPDATE a referência à
  -- linha existente não aceita nome qualificado por schema.
  insert into public.ride_quota_usage as q (user_id, usage_date, used_count)
  values (v_uid, current_date, 1)
  on conflict (user_id, usage_date) do update
     set used_count = q.used_count + 1
   where q.used_count < c_limit
  returning q.used_count into v_used;

  if v_used is null then
    return jsonb_build_object(
      'allowed',   false,
      'premium',   false,
      'remaining', 0,
      'reason',    'daily_quota_exceeded'
    );
  end if;

  return jsonb_build_object(
    'allowed',   true,
    'premium',   false,
    'remaining', c_limit - v_used
  );
end;
$$;

grant execute on function public.rpc_consume_ride_quota() to authenticated;

-- ----------------------------------------------------------------------------
-- 7. Sync em lote — o outbox do app sobe N corridas numa chamada
-- ----------------------------------------------------------------------------
-- Uma requisição com 50 corridas em vez de 50 requisições: menos handshake TLS,
-- menos wakeup de rádio, menos bateria. Idempotente por (user_id, client_id).
create or replace function public.rpc_sync_rides(p_rides jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_uid      uuid := (select auth.uid());
  v_inserted integer;
begin
  if v_uid is null then
    raise exception 'Não autenticado.' using errcode = '28000';
  end if;

  if jsonb_typeof(p_rides) <> 'array' then
    raise exception 'p_rides deve ser um array JSON.' using errcode = '22023';
  end if;

  if jsonb_array_length(p_rides) > 200 then
    raise exception 'Lote máximo de 200 corridas.' using errcode = '22023';
  end if;

  with payload as (
    select * from jsonb_to_recordset(p_rides) as r(
      client_id        uuid,
      work_profile_id  uuid,
      work_session_id  uuid,
      platform         text,
      occurred_at      timestamptz,
      fare             numeric,
      pickup_km        numeric,
      trip_km          numeric,
      pickup_minutes   numeric,
      trip_minutes     numeric,
      passenger_rating numeric,
      pickup_region    text,
      surge_multiplier numeric,
      rs_per_km        numeric,
      rs_per_hour      numeric,
      cost_per_km_used numeric,
      operating_cost   numeric,
      real_profit      numeric,
      margin_pct       numeric,
      verdict          text,
      outcome          text
    )
  )
  insert into public.ride_evaluations (
    user_id, client_id, work_profile_id, work_session_id, platform, occurred_at,
    fare, pickup_km, trip_km, pickup_minutes, trip_minutes, passenger_rating,
    pickup_region, surge_multiplier, rs_per_km, rs_per_hour, cost_per_km_used,
    operating_cost, real_profit, margin_pct, verdict, outcome
  )
  select
    v_uid, p.client_id, p.work_profile_id, p.work_session_id,
    p.platform::public.ride_platform, p.occurred_at,
    p.fare, p.pickup_km, p.trip_km, coalesce(p.pickup_minutes, 0),
    coalesce(p.trip_minutes, 0), p.passenger_rating,
    -- sanitização defensiva: região é nome de bairro, não endereço
    left(regexp_replace(coalesce(p.pickup_region, ''), '[0-9]{3,}', '', 'g'), 120),
    p.surge_multiplier, p.rs_per_km, p.rs_per_hour, p.cost_per_km_used,
    p.operating_cost, p.real_profit, p.margin_pct,
    p.verdict::public.ride_verdict,
    coalesce(p.outcome, 'unknown')::public.ride_outcome
  from payload p
  on conflict (user_id, client_id, occurred_at) do nothing;

  get diagnostics v_inserted = row_count;

  return jsonb_build_object(
    'received', jsonb_array_length(p_rides),
    'inserted', v_inserted
  );
end;
$$;

grant execute on function public.rpc_sync_rides(jsonb) to authenticated;

-- ----------------------------------------------------------------------------
-- 8. Soft delete de conta (chamada pela Edge Function delete-account)
-- ----------------------------------------------------------------------------
create or replace function public.rpc_request_account_deletion()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Não autenticado.' using errcode = '28000';
  end if;

  update public.profiles set deleted_at = now() where id = v_uid;

  insert into public.audit_log (user_id, action, metadata)
  values (v_uid, 'account.deletion_requested',
          jsonb_build_object('purge_after', now() + interval '30 days'));
end;
$$;

grant execute on function public.rpc_request_account_deletion() to authenticated;
```

### `0005_views_and_reports.sql`

```sql
-- ============================================================================
-- Rota Plus · 0005 · Views de relatório
-- ============================================================================
-- `security_invoker = true` (Postgres 15+) é OBRIGATÓRIO aqui. Sem isso a view
-- roda com privilégio do dono e ignora a RLS das tabelas base — um vazamento
-- clássico: a tabela está protegida, a view que a lê não está.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Fechamento diário — substitui o laço no cliente que o Firestore exigia
-- ----------------------------------------------------------------------------
create view public.v_daily_summary
with (security_invoker = true) as
with rides as (
  select
    user_id,
    (occurred_at at time zone 'America/Boa_Vista')::date as day,
    count(*)                                              as rides_evaluated,
    count(*) filter (where outcome = 'accepted')           as rides_accepted,
    count(*) filter (where outcome = 'rejected')           as rides_rejected,
    count(*) filter (where verdict = 'accept')             as verdict_accept,
    count(*) filter (where verdict = 'think')              as verdict_think,
    count(*) filter (where verdict = 'reject')             as verdict_reject,
    coalesce(sum(fare)           filter (where outcome = 'accepted'), 0) as gross_revenue,
    coalesce(sum(operating_cost) filter (where outcome = 'accepted'), 0) as operating_cost,
    coalesce(sum(real_profit)    filter (where outcome = 'accepted'), 0) as net_profit,
    coalesce(sum(total_km)       filter (where outcome = 'accepted'), 0) as km_driven,
    avg(rs_per_km)   filter (where outcome = 'accepted')                 as avg_rs_per_km,
    avg(rs_per_hour) filter (where outcome = 'accepted')                 as avg_rs_per_hour
  from public.ride_evaluations
  group by 1, 2
),
extra as (
  select
    user_id,
    (occurred_at at time zone 'America/Boa_Vista')::date as day,
    coalesce(sum(amount), 0)                             as extra_expenses
  from public.expenses
  where deleted_at is null
  group by 1, 2
),
hours as (
  select
    user_id,
    (started_at at time zone 'America/Boa_Vista')::date as day,
    coalesce(sum(
      extract(epoch from (coalesce(ended_at, now()) - started_at)) / 3600.0
    ), 0) as hours_worked
  from public.work_sessions
  group by 1, 2
)
select
  coalesce(r.user_id, e.user_id, h.user_id)                as user_id,
  coalesce(r.day, e.day, h.day)                            as day,
  coalesce(r.rides_evaluated, 0)                           as rides_evaluated,
  coalesce(r.rides_accepted, 0)                            as rides_accepted,
  coalesce(r.rides_rejected, 0)                            as rides_rejected,
  coalesce(r.verdict_accept, 0)                            as verdict_accept,
  coalesce(r.verdict_think, 0)                             as verdict_think,
  coalesce(r.verdict_reject, 0)                            as verdict_reject,
  coalesce(r.gross_revenue, 0)                             as gross_revenue,
  coalesce(r.operating_cost, 0)                            as operating_cost,
  coalesce(e.extra_expenses, 0)                            as extra_expenses,
  coalesce(r.net_profit, 0) - coalesce(e.extra_expenses, 0) as net_profit,
  coalesce(r.km_driven, 0)                                 as km_driven,
  round(coalesce(h.hours_worked, 0)::numeric, 2)           as hours_worked,
  r.avg_rs_per_km,
  r.avg_rs_per_hour,
  case
    when coalesce(h.hours_worked, 0) > 0
    then round((coalesce(r.gross_revenue, 0) / h.hours_worked)::numeric, 2)
  end                                                      as effective_rs_per_hour
from rides r
full join extra e on e.user_id = r.user_id and e.day = r.day
full join hours h on h.user_id = coalesce(r.user_id, e.user_id)
                 and h.day     = coalesce(r.day, e.day);

-- ----------------------------------------------------------------------------
-- Fechamento mensal
-- ----------------------------------------------------------------------------
create view public.v_monthly_summary
with (security_invoker = true) as
select
  user_id,
  date_trunc('month', day)::date       as month,
  sum(rides_evaluated)                 as rides_evaluated,
  sum(rides_accepted)                  as rides_accepted,
  sum(gross_revenue)                   as gross_revenue,
  sum(operating_cost)                  as operating_cost,
  sum(extra_expenses)                  as extra_expenses,
  sum(net_profit)                      as net_profit,
  sum(km_driven)                       as km_driven,
  sum(hours_worked)                    as hours_worked,
  round(avg(avg_rs_per_km), 4)         as avg_rs_per_km,
  case
    when sum(hours_worked) > 0
    then round(sum(gross_revenue) / sum(hours_worked), 2)
  end                                  as effective_rs_per_hour,
  count(*) filter (where rides_evaluated > 0) as active_days
from public.v_daily_summary
group by 1, 2;

-- ----------------------------------------------------------------------------
-- Comparativo entre plataformas
-- ----------------------------------------------------------------------------
create view public.v_platform_comparison
with (security_invoker = true) as
select
  user_id,
  platform,
  count(*)                                            as offers,
  count(*) filter (where outcome = 'accepted')        as accepted,
  round(
    100.0 * count(*) filter (where outcome = 'accepted')
    / nullif(count(*), 0), 1)                         as acceptance_rate_pct,
  round(avg(rs_per_km), 4)                            as avg_rs_per_km,
  round(avg(rs_per_hour), 2)                          as avg_rs_per_hour,
  round(avg(fare), 2)                                 as avg_fare,
  coalesce(sum(real_profit) filter (where outcome = 'accepted'), 0) as total_profit
from public.ride_evaluations
group by 1, 2;

-- ----------------------------------------------------------------------------
-- Heatmap: melhores horas × dia da semana
-- ----------------------------------------------------------------------------
create view public.v_hour_heatmap
with (security_invoker = true) as
select
  user_id,
  extract(dow  from occurred_at at time zone 'America/Boa_Vista')::smallint as weekday,
  extract(hour from occurred_at at time zone 'America/Boa_Vista')::smallint as hour_of_day,
  count(*)                    as offers,
  round(avg(rs_per_km), 4)    as avg_rs_per_km,
  round(avg(rs_per_hour), 2)  as avg_rs_per_hour,
  round(avg(fare), 2)         as avg_fare
from public.ride_evaluations
group by 1, 2, 3;

grant select on
  public.v_daily_summary,
  public.v_monthly_summary,
  public.v_platform_comparison,
  public.v_hour_heatmap
  to authenticated;
```

### `0006_cron_and_retention.sql`

```sql
-- ============================================================================
-- Rota Plus · 0006 · Manutenção automática, retenção e LGPD
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Criação automática da partição do mês seguinte
-- ----------------------------------------------------------------------------
-- Sem isso, no dia 1º do mês todo INSERT falha com "no partition of relation
-- found for row". É o tipo de bug que só aparece em produção, à meia-noite.
create or replace function public.fn_ensure_next_ride_partition()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_start date := date_trunc('month', now() + interval '1 month')::date;
  v_end   date := date_trunc('month', now() + interval '2 month')::date;
  v_name  text := format('ride_evaluations_%s', to_char(v_start, 'YYYY_MM'));
begin
  if not exists (
    select 1 from pg_class c
      join pg_namespace n on n.oid = c.relnamespace
     where n.nspname = 'public' and c.relname = v_name
  ) then
    execute format(
      'create table public.%I partition of public.ride_evaluations
         for values from (%L) to (%L)', v_name, v_start, v_end);
  end if;
end;
$$;

select cron.schedule(
  'ensure-next-ride-partition',
  '0 3 25 * *',                     -- dia 25, 03:00 UTC: folga antes do virar o mês
  $$select public.fn_ensure_next_ride_partition();$$
);

-- ----------------------------------------------------------------------------
-- 2. Retenção do plano Free — histórico de 7 dias
-- ----------------------------------------------------------------------------
create or replace function public.fn_prune_free_tier_history()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  delete from public.ride_evaluations r
   where r.occurred_at < now() - interval '7 days'
     and not public.fn_is_premium(r.user_id);

  insert into public.audit_log (action, metadata)
  values ('retention.free_tier_pruned',
          jsonb_build_object('ran_at', now()));
end;
$$;

select cron.schedule(
  'prune-free-tier-history',
  '30 4 * * *',                     -- diário, 04:30 UTC
  $$select public.fn_prune_free_tier_history();$$
);

-- ----------------------------------------------------------------------------
-- 3. Purga definitiva de contas excluídas (LGPD art. 18, VI)
-- ----------------------------------------------------------------------------
-- Janela de 30 dias para arrependimento/recuperação; depois, apagar de fato.
-- A remoção de auth.users faz o CASCADE limpar todo o resto.
create or replace function public.fn_purge_deleted_accounts()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  r record;
begin
  for r in
    select id from public.profiles
     where deleted_at is not null
       and deleted_at < now() - interval '30 days'
  loop
    delete from auth.users where id = r.id;

    insert into public.audit_log (user_id, action, metadata)
    values (r.id, 'account.purged', jsonb_build_object('purged_at', now()));
  end loop;
end;
$$;

select cron.schedule(
  'purge-deleted-accounts',
  '0 5 * * *',
  $$select public.fn_purge_deleted_accounts();$$
);

-- ----------------------------------------------------------------------------
-- 4. Limpeza de tokens de push mortos e de eventos de webhook antigos
-- ----------------------------------------------------------------------------
select cron.schedule(
  'cleanup-stale-records',
  '15 5 * * 0',                     -- domingos
  $$
    delete from public.device_push_tokens
     where last_seen_at < now() - interval '90 days';

    delete from public.webhook_events
     where processed_at is not null
       and received_at < now() - interval '180 days';

    delete from public.audit_log
     where created_at < now() - interval '2 years';
  $$
);

-- ----------------------------------------------------------------------------
-- 5. Expiração de assinaturas vencidas sem renovação
-- ----------------------------------------------------------------------------
select cron.schedule(
  'expire-stale-subscriptions',
  '0 6 * * *',
  $$
    update public.subscriptions
       set status = 'expired'
     where status in ('active', 'past_due')
       and current_period_end is not null
       and current_period_end < now() - interval '3 days';

    update public.subscriptions
       set status = 'expired'
     where status = 'trialing'
       and trial_ends_at is not null
       and trial_ends_at < now();
  $$
);

-- ----------------------------------------------------------------------------
-- 6. Manutenção estatística — mantém o planner escolhendo bem o índice
-- ----------------------------------------------------------------------------
select cron.schedule(
  'analyze-hot-tables',
  '0 7 * * *',
  $$
    analyze public.ride_evaluations;
    analyze public.expenses;
    analyze public.work_sessions;
  $$
);
```


---

## 🔄 Sincronização e Funcionamento Offline

> Esta é a diferença arquitetural mais importante em relação à v1.0. Motorista de app trabalha em
> estacionamento de shopping, subsolo e periferia com 1 barra de sinal. Um app que depende de rede para
> avaliar corrida é um app que falha exatamente quando é mais necessário.

### Padrão adotado: *local-first* com outbox

```
┌──────────┐  1. grava    ┌───────────────┐  2. enfileira  ┌─────────┐
│   UI     │ ───────────► │ Drift (SQLite)│ ─────────────► │ Outbox  │
└──────────┘              └───────────────┘                └─────────┘
     ▲                            │                             │
     │ 4. stream reativo          │                             │ 3. flush
     └────────────────────────────┘                             ▼
                                                        ┌──────────────┐
                                                        │ Supabase RPC │
                                                        │ rpc_sync_*   │
                                                        └──────────────┘
```

1. A UI **nunca** espera a rede. Escreve no Drift e a tela já reflete.
2. A mesma transação grava uma linha no `outbox` com o `client_id` (UUID v4 gerado no app).
3. O `SyncEngine` faz *flush* quando: volta conectividade, o app vai para foreground, a cada 15 min em
   foreground, ou quando o outbox passa de 50 itens.
4. `rpc_sync_rides` é **idempotente** por `(user_id, client_id, occurred_at)` — reenvio não duplica.

### Regras de conflito

| Entidade | Estratégia | Justificativa |
|---|---|---|
| `ride_evaluations` | *Insert-only*, idempotente | Fato histórico: nunca muda depois de gravado |
| `expenses` | Last-write-wins por `updated_at` | Editado em um device por vez, na prática |
| `vehicles`, `work_profiles` | Last-write-wins + aviso na UI se divergiu | Config muda raramente |
| `subscriptions` | **Servidor sempre ganha** | Entitlement não se negocia com o cliente |

### Orçamento de dados móveis
Sincronização em lote, `gzip` no transporte, nada de Realtime em tabela de volume.
Meta: **< 5 MB/mês** de tráfego para um motorista com 1.500 corridas/mês.

---

## ⚡ Desempenho

### Orçamentos mensuráveis (não são metas vagas — são critérios de aceite)

| Métrica | Orçamento | Como medir |
|---|---|---|
| Evento de acessibilidade → primeiro frame do overlay | **≤ 120 ms** (p95) | Trace no DevTools + `Timeline` nativo |
| Cold start até a Home utilizável | **≤ 1.800 ms** | `flutter run --profile --trace-startup` |
| Frames acima de 16 ms (jank) na rolagem do Histórico | **< 1%** | DevTools Performance overlay |
| Queda de bateria com serviço ativo | **< 4%/hora** | Battery Historian |
| Tamanho do APK (arm64, split) | **≤ 25 MB** | `flutter build apk --analyze-size` |
| Memória residente em foreground | **≤ 180 MB** | DevTools Memory |
| Query de fechamento mensal | **≤ 150 ms** no servidor | `explain (analyze, buffers)` |

### Desempenho no caminho crítico do overlay

O overlay é o produto. Tudo nele é otimizado contra o pior caso:

1. **Zero rede.** O veredicto sai de `cached_cost_per_km` + metas, já em memória.
2. **Zero I/O de disco.** Os parâmetros do perfil ativo ficam num objeto imutável em memória, recarregado
   somente no evento de troca de perfil.
3. **Parsing em Kotlin, não em Dart.** O `AccessibilityEvent` é parseado no lado nativo e cruza o
   Platform Channel já como mapa de números — evita serializar a árvore de nós inteira.
4. **Debounce de 250 ms** no `TYPE_WINDOW_CONTENT_CHANGED`: a Uber dispara dezenas de eventos por
   segundo durante a animação do card. Sem debounce, o app queima CPU redesenhando o mesmo veredicto.
5. **Hash do conteúdo** da oferta: se o hash repetir, descarta sem recalcular.
6. **Engine separado:** `flutter_overlay_window` roda num `FlutterEngine` próprio. Ele **não** tem acesso
   aos providers do engine principal — a comunicação é por `IsolateNameServer`/`SendPort`, e o overlay
   recebe um *snapshot* pronto, nunca uma referência ao estado do app.
7. **Widget do cartão**: `const` onde possível, `RepaintBoundary` em volta, sem `Opacity` animado
   (usa `FadeTransition`, que não força repaint da subárvore).

### Desempenho no Flutter

- **Riverpod com `select`**: o Dashboard assina `ref.watch(summaryProvider.select((s) => s.netProfit))`,
  não o objeto inteiro. Trocar uma métrica não reconstrói a tela.
- **Listas sempre `.builder`** com `itemExtent` fixo quando a altura é conhecida — permite ao Flutter
  pular o layout de itens fora da viewport.
- **Paginação de verdade** no Histórico: `range()` do Supabase / `LIMIT/OFFSET` no Drift, 50 itens por página.
  Nunca `select()` sem limite numa tabela que cresce para sempre.
- **Isolate para trabalho pesado**: geração de CSV/PDF do fechamento e migrações de banco vão para
  `Isolate.run()`. Drift já roda em isolate próprio (`driftWorkerIsolate`).
- **Gráficos**: `fl_chart` recebe dados **pré-agregados pela view SQL**, no máximo ~90 pontos. Jamais
  mil pontos para o widget decimar.
- **Imagens**: `cacheWidth`/`cacheHeight` em todo `Image`, avatares servidos por *signed URL* com
  transformação de tamanho no Storage.
- **Fontes empacotadas** (não `google_fonts` em runtime) — elimina request de rede no primeiro frame e o
  flash de fonte.
- **Shader warm-up**: `--bundle-sksl-path` para animações da entrada do overlay, eliminando o jank de
  primeira execução.
- **`const` constructors e `avoid_unnecessary_containers`** como lint de erro, não aviso.

### Desempenho no Postgres

- **RLS otimizada**: `(select auth.uid())` em toda policy. Com `auth.uid()` direto, a função é reavaliada
  **por linha**; o `select` faz o planner tratar como InitPlan e avaliar uma vez por query.
- **Índice em toda coluna de policy**, com `user_id` como primeira coluna do índice composto.
- **Particionamento mensal** em `ride_evaluations`: o relatório do mês lê uma partição; a retenção vira
  `DROP TABLE` em vez de `DELETE` de milhões de linhas com `VACUUM` depois.
- **Colunas geradas** (`total_km`, `total_minutes`) e métricas materializadas: o relatório soma, não recalcula.
- **Views de agregação** no servidor — o cliente baixa ~30 linhas, não 1.500.
- **`analyze` diário** por `pg_cron` nas tabelas quentes.
- **`pg_stat_statements`** monitorado; qualquer query acima de 200 ms de média entra em backlog.
- **Realtime com parcimônia**: assinado **apenas** em `subscriptions` (para refletir compra feita no
  outro device) e `work_profiles` (troca de perfil). Realtime em `ride_evaluations` seria custo de
  WebSocket aberto para zero benefício — o dado nasce no próprio device.

### Desempenho no backend serverless

- Edge Functions com *cold start* minimizado: dependências mínimas, sem bundler pesado.
- Toda Edge Function tem *timeout* explícito e retorna erro estruturado.
- Webhooks respondem **202 imediatamente** e processam depois — provedor de pagamento não espera.

---

## 📐 Fluidez e Responsividade

### Princípio: medir a janela, não o aparelho

Nunca ramificar por "é tablet" ou por orientação. O que importa é o espaço realmente disponível —
em tela dividida, janela flutuante, foldable ou picture-in-picture, o "aparelho" mente e a janela não.

```dart
// errado: decide pelo hardware e pela orientação
if (MediaQuery.orientationOf(context) == Orientation.landscape) { ... }

// certo: decide pelo espaço que o pai concedeu
LayoutBuilder(
  builder: (context, constraints) => constraints.maxWidth >= Breakpoints.medium
      ? const _WideLayout()
      : const _NarrowLayout(),
)
```

### Breakpoints (`app/theme/breakpoints.dart`)

| Nome | Largura | Layout |
|---|---|---|
| `compact` | < 600 dp | Coluna única, `BottomNavigationBar` |
| `medium` | 600–839 dp | `NavigationRail`, grid de 2 colunas nos cards |
| `expanded` | ≥ 840 dp | Rail expandido + painel lateral de detalhe (lista/detalhe) |

### Regras normativas de layout

- **Constraints descem, tamanhos sobem, o pai posiciona.** Usar `Expanded` para ocupar o restante e
  `Flexible` para limitar; nunca calcular tamanho a partir de `MediaQuery.size` dentro de uma subárvore.
- **`MediaQuery.sizeOf(context)`**, não `MediaQuery.of(context).size` — o primeiro só reconstrói quando o
  tamanho muda, o segundo reconstrói quando *qualquer* propriedade do MediaQuery muda (inclusive teclado).
- **Formulários e listas limitados em telas largas**: `ConstrainedBox(maxWidth: 560)` dentro de `Center`.
  Um formulário de custos esticado em 1.200 dp é ilegível.
- **Sem travar orientação.** `SystemChrome.setPreferredOrientations` não é usado — travar causa
  letterbox em foldable e reprovação crescente nas lojas.
- **Teclado**: `resizeToAvoidBottomInset` + `SingleChildScrollView` em toda tela com input. A T06 tem
  ~20 campos: sem isso, metade fica inacessível.
- **Insets seguros**: `SafeArea` e `MediaQuery.viewPaddingOf` para notch e barra de gestos.
- **Overlay responsivo**: o cartão usa `maxWidth: min(constraints.maxWidth * 0.92, 420)` — em tablet não
  vira uma faixa gigante atravessando a tela.

### Fluidez percebida

| Técnica | Aplicação |
|---|---|
| **Skeletons**, não spinners | Dashboard e Histórico mostram a estrutura enquanto o Drift responde |
| **Otimismo na UI** | Despesa aparece na lista no instante do salvar; o sync é assunto do outbox |
| **Hero + transições compartilhadas** | Lista de corridas → detalhe |
| **Haptics discretos** | Confirmação de salvar e mudança de veredicto do semáforo |
| **Animações de 150–250 ms** | `Curves.easeOutCubic`; acima de 300 ms o app "arrasta" |
| **Zero *layout shift*** | Altura reservada para métricas antes do dado chegar |
| **Respeitar `disableAnimations`** | `MediaQuery.disableAnimationsOf(context)` para acessibilidade |

### Acessibilidade — requisito, não extra

- Alvos de toque ≥ 48×48 dp.
- Contraste mínimo **4.5:1** para texto. ⚠️ O amarelo `#FF9F0A` sobre branco **não** passa: o texto do
  estado "PENSE" usa tom escurecido (`#8A5200`) sobre fundo claro, mantendo o `#FF9F0A` apenas na barra
  e no ícone.
- **Nunca cor como único significante**: o semáforo sempre traz ícone + texto, por causa do daltonismo
  (~8% dos homens — e a base de usuários é majoritariamente masculina).
- Escala de texto até **200%** sem quebra: toda `Text` sem `maxLines` rígido, e `textScaler` testado
  no widget test do cartão.
- `Semantics` em todo botão só-ícone; o cartão do overlay anuncia o veredicto por leitor de tela.

---

## ⚡ Edge Functions

| Função | Trigger | Responsabilidade | Chave usada |
|---|---|---|---|
| `revenuecat-webhook` | POST do RevenueCat | Valida `Authorization`, grava em `webhook_events`, atualiza `subscriptions` | `service_role` |
| `stripe-webhook` | POST do Stripe | Verifica `Stripe-Signature`, idempotência, atualiza `subscriptions` | `service_role` |
| `check-ride-quota` | Chamada do app | Alternativa à RPC quando precisa de lógica extra de entitlement | `anon` + JWT do usuário |
| `delete-account` | Chamada do app | `rpc_request_account_deletion` + revoga sessões via Admin API | `service_role` |
| `export-my-data` | Chamada do app | Monta ZIP com todos os dados do titular (LGPD art. 18) | `service_role` |
| `send-push` | `pg_cron` / interno | Dispara FCM/APNs a partir de `device_push_tokens` | `service_role` + chave FCM |

Padrão obrigatório em todas: validar assinatura/JWT → checar idempotência → efeito → resposta
estruturada → registro em `audit_log`.

---

## 🎨 Design System

### Paleta de Cores

| Token | Hex | Uso |
|---|---|---|
| `primary` | `#009D68` | Cor principal da marca (emerald) |
| `primaryDark` | `#007F54` | Variação escura |
| `primaryLight` | `#E5F6EF` | Backgrounds suaves |
| `go` | `#1FB877` | Semáforo — ACEITAR |
| `wait` | `#FF9F0A` | Semáforo — PENSE (barra/ícone) |
| `waitText` | `#8A5200` | Semáforo — PENSE (texto, para contraste 4.5:1) |
| `stop` | `#FF3B30` | Semáforo — RECUSAR |
| `background` | `#E2F0E7` | Fundo do app (light) |
| `surface` | `#FFFFFF` | Cards e superfícies |
| `ink` | `#0B1E19` | Texto principal |
| `ink2` | `#52645D` | Texto secundário |
| `bgDark` | `#0A0F0D` | Fundo (dark mode) |
| `surfaceDark` | `#151C18` | Cards (dark mode) |

As cores são definidas como `ColorScheme` do Material 3 e consumidas por
`Theme.of(context).colorScheme` — **nunca** hex literal dentro do widget.

### Tipografia

Fonte **Sora** (empacotada em `assets/fonts/`), fallback para a fonte do sistema.

| Estilo | Tamanho | Peso |
|---|---|---|
| Display | 62 | 800 |
| H1 | 46 | 700 |
| H2 | 36 | 700 |
| H3 | 24 | 600 |
| Body | 17 | 400 |
| Caption | 14 | 500 |

> Nota de responsividade: a escala de display acima é da landing page. No app, `Display` e `H1` só
> aparecem em `expanded`; em `compact` a hierarquia começa em `H2`, senão o título engole a tela.

### Componentes

- **Border radius:** 20 px (cards), 28 px (cards grandes), 999 px (pills/badges)
- **Sombras:** 3 níveis (sm/md/lg) com tons esverdeados
- **Animações:** `cubic-bezier(0.2, 0.7, 0.3, 1)`
- **Glassmorphism:** navbar com blur — ⚠️ `BackdropFilter` é caro; aplicar **só** na navbar, com
  `RepaintBoundary`, e desligar em aparelhos de baixo desempenho.

---

## 💰 Modelo de Monetização

### Planos

| Plano | Preço | Equivalente/mês | Flag |
|---|---|---|---|
| 🏆 Anual | R$ 97,00/ano | R$ 8,08/mês | "Mais popular" |
| Trimestral | R$ 39,90/trim | R$ 13,30/mês | — |
| Mensal | R$ 19,90/mês | R$ 19,90/mês | — |

**Trial:** 7 dias grátis com acesso total. `trial_ends_at` é gravado no signup pelo trigger
`on_auth_user_created` e é a referência do `fn_is_premium()`.

### Free vs Premium

| Funcionalidade | Free | Premium | Onde o limite é imposto |
|---|---|---|---|
| Dashboard básico | ✅ | ✅ | — |
| Configuração do veículo | ✅ | ✅ | — |
| Semáforo de corridas | 3/dia | ✅ Ilimitado | `rpc_consume_ride_quota()` |
| Notificação por voz | ❌ | ✅ | `fn_is_premium()` + UI |
| Histórico | 7 dias | ✅ Ilimitado | `fn_prune_free_tier_history()` |
| Fechamento de caixa | ❌ | ✅ | `fn_is_premium()` |
| Perfis de trabalho | 1 | ✅ até 10 | Trigger + `fn_is_premium()` |
| Estatísticas avançadas | ❌ | ✅ | `fn_is_premium()` |
| Suporte prioritário | ❌ | ✅ | — |

### Pagamento
PIX (Stripe ou MercadoPago) · cartão de crédito (Stripe) · In-App Purchase (Google Play / App Store via
RevenueCat) · cupons de desconto para afiliados/influenciadores.

> ⚠️ **Regra das lojas:** conteúdo digital consumido no app **precisa** oferecer IAP. PIX/cartão direto é
> aceitável para compra feita na *landing page* (fora do app), não para um botão dentro do app.
> O paywall no app usa IAP; a oferta por PIX vive no site e reflete no app via webhook.

---

## 📋 Permissões Necessárias (Android)

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_SPECIAL_USE" />
<uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.VIBRATE" />

<application
    android:allowBackup="false"
    android:dataExtractionRules="@xml/data_extraction_rules">

    <!-- Accessibility Service -->
    <service
        android:name=".RideCaptureAccessibilityService"
        android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE"
        android:exported="false">
        <intent-filter>
            <action android:name="android.accessibilityservice.AccessibilityService" />
        </intent-filter>
        <meta-data
            android:name="android.accessibilityservice"
            android:resource="@xml/accessibility_config" />
    </service>

    <!-- Foreground Service (Android 14+ exige o tipo declarado) -->
    <service
        android:name=".MonitoringForegroundService"
        android:foregroundServiceType="specialUse"
        android:exported="false">
        <property
            android:name="android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE"
            android:value="Monitoramento de ofertas de corrida solicitado pelo usuário" />
    </service>
</application>
```

```xml
<!-- res/xml/accessibility_config.xml — lista FECHADA de pacotes -->
<accessibility-service
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:accessibilityEventTypes="typeWindowContentChanged|typeWindowStateChanged"
    android:accessibilityFeedbackType="feedbackGeneric"
    android:canRetrieveWindowContent="true"
    android:notificationTimeout="250"
    android:packageNames="com.ubercab.driver,com.nineninetaxi.driver,com.indrive.passenger"
    android:description="@string/accessibility_description" />
```

> O atributo `android:packageNames` é o que separa "lê 3 apps de transporte" de "lê tudo que o usuário
> faz no telefone". É o item mais importante da revisão do Google Play.

---

## 🧪 Estratégia de Testes

| Camada | Ferramenta | O que cobre | Meta |
|---|---|---|---|
| Unitário | `flutter_test` + `mocktail` | Use cases, cálculo de métricas, custo/km, parsers | **≥ 85%** nos cálculos financeiros |
| Widget | `WidgetTester` | Cartão do semáforo nos 3 estados, formulários, `textScaler` 2.0 | Telas críticas |
| Golden | `matchesGoldenFile` | Cartão do overlay, light/dark, compact/expanded | 8 goldens |
| Integração | `integration_test` | Onboarding completo, salvar veículo, registrar despesa | Fluxos principais |
| Banco | `pgTAP` via `supabase test db` | **RLS: usuário A não lê dado de B**, quota, limite de perfis | 100% das policies |
| Carga | `k6` nas Edge Functions | Webhooks e `rpc_sync_rides` com lote de 200 | p95 < 500 ms |
| Performance | `integration_test` + `--profile` | Jank na rolagem do Histórico com 5.000 linhas | < 1% de frames lentos |

**Teste de RLS é obrigatório e bloqueia merge.** Um bug de RLS não é bug de feature: é vazamento do
dado financeiro de um motorista para outro.

```sql
-- supabase/tests/rls_isolation_test.sql (pgTAP)
begin;
select plan(3);

-- 0 tabelas públicas sem RLS
select is_empty(
  $$select c.relname from pg_class c
      join pg_namespace n on n.oid = c.relnamespace
     where n.nspname = 'public' and c.relkind = 'r' and not c.relrowsecurity$$,
  'Toda tabela em public tem RLS habilitada'
);

-- Usuário A não enxerga corrida do usuário B
set local role authenticated;
set local request.jwt.claims = '{"sub":"<uuid-do-usuario-A>","role":"authenticated"}';
select is_empty(
  $$select 1 from public.ride_evaluations where user_id <> '<uuid-do-usuario-A>'$$,
  'RLS isola ride_evaluations por usuário'
);

-- Usuário não consegue se promover a premium
select throws_ok(
  $$update public.subscriptions set plan = 'annual', status = 'active'$$,
  '42501',
  null,
  'Cliente não escreve em subscriptions'
);

select * from finish();
rollback;
```

---

## 🚀 Roadmap de Desenvolvimento

### Fase 0 — Fundação (1–2 semanas) ⬅ NOVA
- [ ] Projeto Flutter + Supabase (local via `supabase start`, staging e prod)
- [ ] Migrations `0001`–`0006` aplicadas e versionadas
- [ ] Testes de RLS (`pgTAP`) no CI, bloqueando merge
- [ ] Banco local Drift + camada de outbox
- [ ] CI/CD: analyze, format, test, build, `gitleaks`
- [ ] Sentry + `--dart-define` por ambiente

### Fase 1 — MVP Core (8–10 semanas)
- [ ] Autenticação (e-mail, Google, Apple) com PKCE
- [ ] Telas de onboarding
- [ ] Configuração de veículo e custos + cálculo de custo/km
- [ ] Definição de metas
- [ ] Dashboard básico
- [ ] AccessibilityService (Android — leitura Uber)
- [ ] Sistema semáforo + cálculo de métricas (100% offline)
- [ ] Overlay com cartão flutuante (Android)
- [ ] Tela de permissões guiada + *prominent disclosure*
- [ ] **Orçamento de 120 ms do overlay validado em aparelho de entrada**

### Fase 2 — Expansão (4–6 semanas)
- [ ] Suporte a 99 e inDrive
- [ ] Notificação por voz (TTS) com audio focus
- [ ] Histórico de corridas paginado
- [ ] Fechamento de caixa (views SQL)
- [ ] Registro de despesas
- [ ] Perfis de trabalho múltiplos
- [ ] Tema escuro
- [ ] Layouts `medium`/`expanded`

### Fase 3 — Monetização (3–4 semanas)
- [ ] Paywall / tela de assinatura
- [ ] RevenueCat (IAP) + Edge Function de webhook
- [ ] Stripe/MercadoPago (PIX/cartão) na landing
- [ ] Trial de 7 dias e quota do Free via RPC
- [ ] Cupons/afiliados

### Fase 4 — iOS + Polimento (4–6 semanas)
- [ ] `NotificationServiceExtension` + App Group
- [ ] Estatísticas avançadas + gráficos
- [ ] Waze / Google Maps
- [ ] Otimização de performance contra os orçamentos da §Desempenho
- [ ] Exportação e exclusão de conta (LGPD)
- [ ] Testes em dispositivos reais (incluindo um aparelho de entrada)
- [ ] Publicação Play Store e App Store

### Fase 5 — Evolução (contínuo)
- [ ] Push com dicas (Edge Function + FCM)
- [ ] Mapa de calor de melhores regiões (PostGIS)
- [ ] Mais plataformas
- [ ] Widget de home screen
- [ ] Programa de indicação
- [ ] Modo contingência com entrada manual da corrida

---

## ⚠️ Pontos Críticos e Riscos

| # | Risco | Impacto | Probabilidade | Mitigação |
|---|---|---|---|---|
| 1 | **Remoção do Google Play** pela política de AccessibilityService | 🔴 Fatal | Média | Lista fechada de pacotes, *prominent disclosure*, vídeo na submissão, modo manual de contingência pronto |
| 2 | **Quebra do parser** quando Uber/99/inDrive atualizam a UI | 🔴 Alto | **Alta** | Parsers versionados e configuráveis via *remote config* no Supabase, atualizáveis **sem publicar nova versão**; telemetria de "falha de parse" com alerta |
| 3 | **iOS estruturalmente limitado** | 🟡 Médio | Certa | Posicionar o iOS como produto secundário e comunicar isso na loja; precificar igual pode gerar review ruim |
| 4 | **Consumo de bateria** levando a desinstalação | 🟡 Médio | Média | Debounce, zero polling, orçamento de 4%/hora medido no Battery Historian em cada release |
| 5 | **Vazamento de dados entre motoristas** por furo de RLS | 🔴 Fatal (LGPD) | Baixa | RLS em 100% das tabelas, teste pgTAP bloqueando merge, `force row level security` nas tabelas sensíveis |
| 6 | **Fraude de entitlement** (usuário se promovendo a premium) | 🟡 Médio | Média | `subscriptions` sem policy de escrita para `authenticated`; validação de assinatura de webhook |
| 7 | **Dependência de fornecedor** (Supabase) | 🟢 Baixo | Baixa | É Postgres puro: `pg_dump` + migrations versionadas permitem migrar para qualquer Postgres gerenciado |
| 8 | **Imprecisão do cálculo** gerando decisão errada do motorista | 🟡 Médio | Média | `numeric` em todo dinheiro, 85% de cobertura nos cálculos, aferição do consumo real via despesas de combustível |

---

## 📦 Entregáveis Finais

- App Flutter (Android + iOS)
- Projeto Supabase: migrations versionadas, RLS testada, Edge Functions, jobs de `pg_cron`
- Código nativo Android (AccessibilityService, Overlay, Foreground Service em Kotlin)
- Código nativo iOS (`NotificationServiceExtension` em Swift)
- Landing page (site de vendas similar ao rotapro.app)
- Painel administrativo (usuários, assinaturas, cupons, telemetria de parser)
- Documentação técnica, runbook de incidente e política de privacidade/LGPD
- Assets de design (logo, ícones, screenshots das lojas)
- Pipeline de CI/CD com gates de analyze, teste, RLS e varredura de segredos

---

## 📚 Anexo — Checklist de Go-Live

**Segurança**
- [ ] 0 tabelas em `public` sem RLS (consulta de verificação retorna vazio)
- [ ] `service_role` ausente de todo artefato do app (grep no APK/IPA desmontado)
- [ ] PKCE ativo; redirect URLs sem wildcard
- [ ] Leaked password protection e rate limit ativos
- [ ] `allowBackup="false"` e build com `--obfuscate`
- [ ] Exclusão e exportação de conta funcionando ponta a ponta
- [ ] Política de privacidade publicada, cobrindo o uso da acessibilidade

**Desempenho**
- [ ] Overlay ≤ 120 ms p95 em aparelho de entrada
- [ ] Cold start ≤ 1.800 ms
- [ ] Bateria < 4%/hora com o serviço ativo
- [ ] Fechamento mensal ≤ 150 ms no servidor
- [ ] Nenhuma query sem índice em `pg_stat_statements`

**Qualidade**
- [ ] `flutter analyze` sem aviso
- [ ] Cobertura ≥ 85% nos cálculos financeiros
- [ ] Testes de RLS passando
- [ ] Goldens do cartão aprovados em light/dark e compact/expanded
- [ ] Teste com `textScaler` 2.0 sem overflow

**Lojas**
- [ ] Formulário de permissões do Google Play preenchido com vídeo
- [ ] Prominent disclosure antes do pedido de acessibilidade
- [ ] IAP configurado nas duas lojas
- [ ] Apple Sign-In presente (há login social)
- [ ] Modo de contingência manual implementado

---

> **IMPORTANTE:** este documento é a base completa para desenvolver o Rota Plus do zero em Flutter com
> Supabase. As seções de **Segurança da Informação**, **Desempenho** e **Fluidez e Responsividade** são
> normativas: orçamentos e itens obrigatórios são critérios de aceite, não sugestões. Os demais módulos
> podem ser refinados durante o desenvolvimento conforme a necessidade do projeto.
