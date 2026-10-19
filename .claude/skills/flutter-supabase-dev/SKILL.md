---
name: flutter-supabase-dev
description: Desenvolvimento Flutter + Dart + Supabase com arquitetura em camadas, local-first e RLS. Use ao criar ou alterar qualquer código Dart/Flutter, feature, tela, widget, ViewModel, repository, model, migration SQL, policy de RLS ou teste neste projeto — e ao corrigir erro de análise, overflow de layout, jank ou falha de teste. Cobre MVVM, Riverpod, Drift, supabase_flutter, go_router, layout responsivo, testes e o ciclo obrigatório de verificação.
---

# Flutter + Supabase — Guia de Desenvolvimento

Guia operacional para escrever código Dart/Flutter neste projeto. As regras marcadas **OBRIGATÓRIO**
não são preferência de estilo: violá-las quebra segurança, desempenho ou o funcionamento offline.

Leia `descritivo_rota_plus.md` antes de criar uma feature nova — ele define os orçamentos de
desempenho e as regras de segurança que o código precisa cumprir.

## Restrições de toolchain deste projeto

Flutter 3.47.7 / Dart 3.13.5. Duas decisões saem daqui.

| Decisão | Motivo |
|---|---|
| **Riverpod sem codegen** — sem `@riverpod`, use `NotifierProvider`/`AsyncNotifierProvider` à mão | `riverpod_generator` ≥ 4.0.6 quer `analyzer ≥ 13`; `freezed` 3.2.x quer `analyzer ^12`. Dá para ter um ou o outro, e `freezed` ficou |
| **Entidade de domínio escrita à mão**, com `const` constructor e `@immutable`; `freezed` fica para DTO e estado de tela | O domínio é pequeno e explícito; menos codegen no caminho crítico |

O Android está fixado em AGP 9.1.0, Kotlin 2.4.0, Gradle 9.3.1, `compileSdk 37` e `minSdk 26`.
`minSdk 26` é exigência do `sentry_flutter` 10 e **não deve ser baixado** — ver o README.

Ao mexer em `android/`: o AGP 9 removeu `kotlinOptions` de dentro de `android {}`. Use o bloco
top-level `kotlin { compilerOptions { jvmTarget = ... } }`, e **não** aplique `id("kotlin-android")`.

## Regra zero: o ciclo de verificação — OBRIGATÓRIO

Nenhuma alteração em Dart está concluída antes de passar por isto, **nesta ordem**:

```bash
dart format .
dart fix --apply          # resolve os lints mecânicos sozinho
flutter analyze           # precisa terminar com "No issues found!"
flutter test              # precisa passar
```

- `flutter analyze` com **qualquer** aviso = trabalho não terminado. Não entregue dizendo "só um aviso".
- Se um teste falhar, leia o stack trace, corrija a causa e **rode de novo**. Não desative o teste.
- Se o analyzer reclamar de algo que você julga incorreto, não adicione `// ignore:` sem explicar o
  motivo no mesmo commit. `// ignore:` sem justificativa é dívida silenciosa.
- Gerou código (freezed, drift, json_serializable)? Rode antes de analisar:
  `dart run build_runner build --delete-conflicting-outputs`

## Arquitetura: três camadas, sem atalho

```
UI (View + ViewModel)  →  Domain (Entity + UseCase)  →  Data (Repository → DataSource)
```

**A regra que importa:** renderização nunca se mistura com lógica de negócio ou acesso a dados.

| Camada | Pode depender de | NUNCA pode |
|---|---|---|
| View | ViewModel | Tocar em repository, Supabase, Drift ou `http` |
| ViewModel | UseCase, Repository (via construtor) | Importar `package:flutter/material.dart` para lógica, conhecer widget |
| UseCase | Repository (interface) | Conhecer a UI |
| Repository | DataSources | Conhecer widget ou ViewModel |
| DataSource | SDK externo (`supabase_flutter`, Drift) | Conhecer domínio |

**Teste rápido de violação:** se um arquivo em `features/*/presentation/` importa `supabase_flutter`,
a camada foi furada. Corrija em vez de seguir.

### Estrutura de uma feature

```
features/<feature>/
├── data/
│   ├── models/            # DTOs com fromJson/toJson
│   └── repositories/      # implementação
├── domain/
│   ├── entities/          # modelos imutáveis (freezed), sem JSON
│   └── usecases/          # uma classe, um método call()
└── presentation/
    ├── screens/
    ├── widgets/
    └── controllers/       # ViewModels (Riverpod Notifier)
```

Agrupe UI **por feature**; agrupe data/domain **por tipo**. Widget compartilhado vai em `shared/widgets/`.

### Ordem de implementação de uma feature nova

1. Entity imutável no domínio, `const` constructor e `@immutable`.
2. DataSource (Supabase e/ou Drift).
3. Repository, com a decisão local-first explícita (ver abaixo).
4. UseCase — **só se** houver lógica real ou cruzamento de repositories. Não crie UseCase que só repassa.
5. ViewModel.
6. View.
7. Registro no provider/DI.
8. Teste de unidade do ViewModel e do Repository → rodar → corrigir → rodar de novo.

## Estado: Riverpod

Sem codegen (ver §Restrições de toolchain): declare o provider à mão.

```dart
final class DashboardController extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() =>
      ref.watch(dashboardRepositoryProvider).loadToday();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(dashboardRepositoryProvider).loadToday(),
    );
  }
}

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, DashboardState>(
      DashboardController.new,
    );
```

Providers compartilhados ficam em `lib/app/providers.dart`; providers de uma feature ficam no
`presentation/controllers/` dela.

**Regras:**

- **OBRIGATÓRIO** — assine com `select` quando a tela usa só um pedaço do estado:
  ```dart
  // reconstrói a cada mudança de qualquer campo — evite
  final state = ref.watch(dashboardControllerProvider);

  // reconstrói só quando netProfit muda — prefira
  final profit = ref.watch(dashboardControllerProvider.select((s) => s.value?.netProfit));
  ```
- `ref.watch` no `build`; `ref.read` em callback. Nunca `ref.watch` dentro de `onPressed`.
- Erro vai no estado (`AsyncValue.error`), não em `throw` que sobe para a UI.
- Repositories entram por construtor/provider, nunca por singleton global ou `GetIt` acessado direto
  no widget — isso impede o teste.

## Dados: local-first — OBRIGATÓRIO

Este app funciona sem internet. **Drift é a fonte de verdade de leitura; Supabase é sincronização.**

```dart
class ExpenseRepository {
  ExpenseRepository(this._local, this._remote, this._outbox);

  final ExpenseLocalDataSource _local;
  final ExpenseRemoteDataSource _remote;
  final OutboxRepository _outbox;

  // Leitura: SEMPRE do local. Stream reativo, nunca future que espera rede.
  Stream<List<Expense>> watchByPeriod(DateTimeRange range) =>
      _local.watchByPeriod(range);

  // Escrita: local + outbox, na MESMA transação. A UI não espera a rede.
  Future<void> add(Expense expense) async {
    final withId = expense.copyWith(clientId: expense.clientId ?? const Uuid().v4());
    await _local.transaction(() async {
      await _local.insert(withId);
      await _outbox.enqueue(OutboxEntry.expense(withId));
    });
  }
}
```

**Nunca faça:**

```dart
// ERRADO: a tela trava sem sinal e o dado se perde se a chamada falhar
Future<void> add(Expense e) async {
  await supabase.from('expenses').insert(e.toJson());
  await _local.insert(e);
}
```

- Todo registro criado no app recebe um `clientId` UUID **gerado no dispositivo** — é o que torna o
  reenvio idempotente.
- Sync em lote por RPC (`rpc_sync_rides`), nunca um `insert` por linha.
- O caminho crítico do overlay não faz I/O: os parâmetros do perfil ativo ficam em memória.

## Supabase: regras de uso

- Um único cliente, inicializado em `bootstrap.dart` com
  `authFlowType: AuthFlowType.pkce` e `localStorage` em `flutter_secure_storage`.
- **OBRIGATÓRIO** — nunca embuta `service_role`. Só `SUPABASE_URL` e `SUPABASE_ANON_KEY`, via
  `--dart-define`. Se precisar de privilégio, crie uma Edge Function.
- **Sempre** `.select('coluna_a, coluna_b')` com as colunas necessárias. `select()` sem argumento
  baixa a linha inteira e custa dados móveis do motorista.
- **Sempre** pagine: `.range(from, to)` + `.order(...)`. Tabela de corridas cresce para sempre.
- Não confie no cliente para regra de negócio. Quota, limite de perfis e entitlement vêm de RPC:
  ```dart
  final res = await supabase.rpc('rpc_consume_ride_quota');
  if (res['allowed'] != true) return showPaywall();
  ```
- `Realtime` só em `subscriptions` e `work_profiles`. Nunca em tabela de volume.
- Erro: capture `PostgrestException` e `AuthException` separadamente e mapeie para `Failure` do domínio.
  Nunca mostre a mensagem crua do Postgres ao usuário.

### Drift: duas armadilhas já encontradas

1. **`database.g.dart` é uma `part`** e herda os imports de `database.dart`. Todo tipo usado numa coluna
   com conversor (`Decimal`, enums de domínio) e o próprio conversor precisam estar importados **lá**,
   senão o código gerado não compila. O analyzer **não** aponta isso de forma confiável — só o
   compilador. Se `flutter analyze` passa e `flutter test` falha com "X isn't a type", é isto.
2. **`storeDateTimeAsText: true`** está ligado em `AppDatabase.options`. O padrão do Drift guarda epoch
   e devolve `DateTime` **local**, deixando o fuso vazar para o domínio. A convenção do projeto é UTC no
   armazenamento, conversão para `America/Boa_Vista` só na apresentação.

Coluna com conversor se lê com `readWithConverter`, não com `read`.

3. **Nunca use `.watch().first` como leitura pontual.** Cria e destrói uma assinatura a cada chamada e
   **trava** se o stream já tiver sido escutado: a espera nunca termina e a tela fica carregando sem
   erro nenhum. Exponha um método com `.get()` no DAO (`getProfiles`, `getVehicles`).
4. **Para observar várias tabelas juntas**, não combine streams com `.first` dentro de `asyncMap`. Use
   uma consulta trivial declarando as dependências e busque o conjunto com Futures:
   ```dart
   customSelect('SELECT 1', readsFrom: {tabelaA, tabelaB})
       .watch()
       .asyncMap((_) => _buscaTudo(id));
   ```

### Testes com banco: `runAsync` é obrigatório

Dentro de `testWidgets` o relógio é falso. Um `await` direto numa consulta do SQLite **nunca completa** —
o teste trava em vez de falhar. Toda leitura de banco feita no corpo do teste vai dentro de
`tester.runAsync(() async { … })`.

Pelo mesmo motivo, `pumpAndSettle` depois de uma ação que mostra `CircularProgressIndicator` espera por
uma árvore ociosa que não chega. Use um número fixo de `tester.pump(Duration(...))`.

Formulário longo não cabe na viewport padrão de 600×800 e widget fora dela não é construído — o teste
falharia por não achar o campo, não por defeito real. Defina `tester.view.physicalSize` e restaure com
`addTearDown(tester.view.reset)`.

### Overlay e serviço de captura (Android nativo)

- **O overlay roda num `FlutterEngine` separado.** Não enxerga providers, banco
  nem sessão. Recebe um retrato pronto em JSON e **não recalcula nada** — recalcular
  do outro lado abriria espaço para o cartão discordar do histórico.
- **`overlayMain` fica em `main.dart`**, com `@pragma('vm:entry-point')`. O plugin
  procura pelo nome a partir da biblioteca principal, e sem a anotação o tree shaking
  remove a função no build de release: o overlay abre em branco, e só em release.
- **A lista de pacotes monitorados é fechada**, em `accessibility_config.xml` **e** em
  `RideParsers`. As duas precisam coincidir. É o item central da revisão do Google Play.
- **Nada capturado é persistido ou logado.** Nem em debug.
- O parsing das ofertas vive em **Dart**, não em Kotlin: é a parte que mais quebra quando
  os apps mudam de layout, e aqui fica coberta por teste. O nativo manda só as linhas de
  texto visíveis — a árvore de nós nunca cruza o canal.
- Toda captura passa por debounce de 250 ms e descarte por assinatura. Sem isso o app
  reavalia a mesma oferta dezenas de vezes por segundo durante a animação do cartão.

### Alterou o banco?

1. Crie um arquivo novo em `supabase/migrations/` — **nunca edite uma migration já aplicada**.
2. Toda tabela nova: `user_id uuid not null`, RLS habilitada, policies por comando, índice em `user_id`.
3. Policy usa `(select auth.uid())`, não `auth.uid()` — o primeiro é avaliado uma vez por query, o
   segundo uma vez por linha.
4. Função `security definer` declara `set search_path = ''` e qualifica nomes.
4b. **Toda função nova nasce sem `EXECUTE`.** O Postgres concede a `PUBLIC` por padrão
   e o PostgREST expõe o schema `public` — ou seja, cada função vira um endpoint
   `/rest/v1/rpc/<nome>`. A migration `0009` revogou tudo e reconcedeu só as seis RPCs
   que o app chama. Se criar uma função nova e ela precisar ser chamável, conceda
   explicitamente **e** acrescente à lista em `supabase/tests/rls_coverage.sql`.
   Isso não é teoria: na primeira aplicação das migrations, `fn_purge_deleted_accounts`
   e `fn_prune_free_tier_history` ficaram chamáveis **sem autenticação**.
5. View de relatório: `with (security_invoker = true)`, senão ela ignora a RLS das tabelas base.
6. Escreva o teste pgTAP de isolamento antes de considerar pronto.

## Navegação: go_router

- Rotas declaradas em `app/router.dart`, com `redirect` para os guards de auth e de entitlement.
- Nunca `Navigator.push` direto numa tela — use `context.go`/`context.push` com rota nomeada.
- O deep link do OAuth (`io.r2b.rotaplus://login-callback`) tem rota própria.

## Layout responsivo — OBRIGATÓRIO

**Meça a janela, não o aparelho.** Tela dividida, janela flutuante e foldable fazem o "aparelho" mentir.

```dart
// ERRADO: ramifica por orientação ou por "é tablet"
if (MediaQuery.orientationOf(context) == Orientation.landscape) { ... }

// CERTO: ramifica pelo espaço que o pai concedeu
LayoutBuilder(
  builder: (context, constraints) => constraints.maxWidth >= Breakpoints.medium
      ? const _WideLayout()
      : const _NarrowLayout(),
)
```

- `MediaQuery.sizeOf(context)` — nunca `MediaQuery.of(context).size`, que reconstrói quando qualquer
  propriedade muda, inclusive a altura do teclado.
- **Constraints descem, tamanhos sobem, o pai posiciona.** `Expanded` para ocupar o resto,
  `Flexible` para limitar. Não calcule tamanho a partir de `MediaQuery` dentro de uma subárvore.
- Em tela larga, limite: `ConstrainedBox(maxWidth: 560)` dentro de `Center`. Formulário esticado em
  1.200 dp é ilegível.
- **Nunca** `SystemChrome.setPreferredOrientations` — travar orientação causa letterbox em foldable.
- Tela com input: `resizeToAvoidBottomInset: true` + `SingleChildScrollView`.
- Lista longa: `ListView.builder`. Em tela larga, `GridView.builder` com
  `SliverGridDelegateWithMaxCrossAxisExtent`.
- `SafeArea` e `MediaQuery.viewPaddingOf` para notch e barra de gestos.

### Corrigindo overflow

Overflow é sempre um destes três casos. Diagnostique antes de mexer:

1. **Filho maior que o pai numa `Row`/`Column`** → envolva em `Expanded` ou `Flexible`.
2. **Conteúdo mais alto que a tela** → `SingleChildScrollView` ou `ListView`.
3. **Constraint não-limitada** (`ListView` dentro de `Column`, `Row` dentro de `Row`) → dê altura
   explícita, use `Expanded`, ou `shrinkWrap: true` **somente** em lista curta.

Não "resolva" overflow com `FittedBox` encolhendo texto nem com valor fixo chutado: isso quebra em
outro aparelho e com `textScaler` maior.

## Desempenho

Orçamentos do projeto (de `descritivo_rota_plus.md`): overlay ≤ 120 ms p95, cold start ≤ 1.800 ms,
jank < 1%, bateria < 4%/hora.

- `const` em todo widget sem parâmetro variável. Lint `prefer_const_constructors` é erro.
- `RepaintBoundary` em volta do que anima independente (cartão do overlay, gráfico).
- `BackdropFilter`/blur é caro: só na navbar, com `RepaintBoundary`.
- Animação: `FadeTransition`/`AnimatedBuilder`, não `Opacity` animado (força repaint da subárvore).
- Duração de 150–250 ms com `Curves.easeOutCubic`. Acima de 300 ms o app "arrasta".
- `Image` sempre com `cacheWidth`/`cacheHeight`.
- Trabalho pesado (CSV, PDF, parse grande) em `Isolate.run()`.
- Gráfico recebe dado **pré-agregado** (≤ ~90 pontos), nunca mil pontos para o widget decimar.
- Respeite `MediaQuery.disableAnimationsOf(context)`.

## Acessibilidade

- Alvo de toque ≥ 48×48 dp.
- Contraste de texto ≥ 4.5:1. O amarelo `#FF9F0A` **não passa** sobre branco: texto usa `#8A5200`.
- **Nunca cor como único significante** — o semáforo sempre tem ícone + texto.
- `textScaler` até 2.0 sem overflow. Teste isso no widget test.
- `Semantics(label: ...)` em todo botão só-ícone.

## Dart idiomático

- `sealed class` + `switch` exaustivo para estado e resultado:
  ```dart
  sealed class RideVerdict {
    const RideVerdict();
  }
  final class Accept extends RideVerdict { const Accept(); }
  final class Think  extends RideVerdict { const Think();  }
  final class Reject extends RideVerdict { const Reject(); }

  String label(RideVerdict v) => switch (v) {
        Accept() => 'ACEITAR',
        Think()  => 'PENSE',
        Reject() => 'RECUSAR',
      };
  ```
  Switch exaustivo faz o analyzer apontar o caso esquecido quando um estado novo aparece.
- Pattern matching para desestruturar: `final (a, b) = pair;`, `if (json case {'fare': final num f})`.
- `?.`, `??`, `??=` em vez de `if (x != null)` encadeado.
- **Dinheiro nunca em `double` para acumular.** Use `Decimal` ou inteiro de centavos em soma e
  comparação; `numeric` no Postgres. `0.1 + 0.2 != 0.3` em relatório financeiro é bug reportável.
- `final` por padrão; `var` só quando reatribui.
- Caminho de arquivo: `package:path` (`p.join`), nunca concatenar com `/`.
- `///` em toda API pública, começando por frase única no imperativo. Sem `/** */`.

## Testes

| O que mudou | Teste obrigatório |
|---|---|
| Cálculo, use case, parser | Unit test — **≥ 85% nos cálculos financeiros** |
| Widget, tela | Widget test, incluindo `textScaler: 2.0` |
| Cartão do overlay | Golden em light/dark e compact/expanded |
| Fluxo completo | `integration_test` |
| Tabela, policy, função SQL | pgTAP de isolamento — **bloqueia merge** |

```dart
test('rejeita corrida abaixo do custo por km', () {
  final result = EvaluateRide(costPerKm: 1.20)(
    const RideOffer(fare: 8.0, pickupKm: 2.0, tripKm: 5.0, /* ... */),
  );
  expect(result.verdict, isA<Reject>());
  expect(result.realProfit, lessThan(0));
});
```

- Mocks com `mocktail` (sem codegen) ou `mockito` + `build_runner` se o projeto já usa.
- Teste comportamento, não implementação. Não asserte em chamada de método privado.
- Teste de RLS é teste de vazamento de dado financeiro entre motoristas. Não é opcional.

## Antipadrões — recuse escrever assim

| Antipadrão | Por quê |
|---|---|
| `supabase.from(...)` dentro de widget | Fura a arquitetura e impede teste |
| `await` de rede antes de atualizar a UI | Trava a tela sem sinal; o app precisa ser local-first |
| `double` acumulando dinheiro | Erro de arredondamento em relatório financeiro |
| Regra de negócio só no cliente | Burlável; quota e entitlement vão para o servidor |
| `select()` sem colunas / sem `range()` | Gasta dados móveis e trava com histórico grande |
| Ramificar layout por orientação ou "é tablet" | Quebra em tela dividida e foldable |
| `MediaQuery.of(context).size` | Reconstrói demais |
| `print()` | Vaza em release; use o wrapper de log |
| `// ignore:` sem justificativa | Dívida silenciosa |
| `auth.uid()` cru em policy | Reavaliado por linha; use `(select auth.uid())` |
| Editar migration já aplicada | Divergência entre ambientes |
| Desativar teste que falhou | Esconde o bug em vez de corrigi-lo |

## Quando estiver em dúvida

1. Procure um padrão já existente no projeto e siga-o — consistência vence preferência pessoal.
2. Se a dúvida é de regra de negócio ou orçamento de desempenho, a resposta está em
   `descritivo_rota_plus.md`.
3. Se a dúvida é de segurança, o padrão é o mais restritivo: nada exposto por padrão.
