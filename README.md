# Rota Plus

Copiloto financeiro para motoristas de app (Uber, 99, inDrive). Avalia cada corrida oferecida em tempo
real e informa se vale a pena aceitar, com base em R$/km, R$/hora e lucro real.

A especificação completa está em [descritivo_rota_plus.md](descritivo_rota_plus.md) — inclusive o schema
SQL, as policies de RLS e os orçamentos de desempenho que o código precisa cumprir.

## Estado atual

| Área | Situação |
|---|---|
| Núcleo de cálculo (custo/km, métricas, veredicto) | ✅ implementado e testado |
| Cartão do semáforo | ✅ implementado (light/dark, responsivo, `textScaler` 2.0) |
| Simulador e dashboard | ✅ navegáveis |
| Tema, breakpoints, formatação pt-BR | ✅ |
| Migrations Supabase (schema + RLS + views + cron) | ✅ escritas, **ainda não aplicadas** |
| Banco local (Drift): corridas, despesas, sessões, outbox | ✅ implementado e testado |
| Motor de sincronização (corridas e despesas) | ✅ implementado e testado, inclusive offline e falha parcial |
| Registro de corrida e resumo do dia na UI | ✅ funcionando |
| **Despesas ponta a ponta (T11)**: criar, editar, excluir, total do dia | ✅ funcionando |
| Supabase Auth e login | ⏳ aguarda projeto provisionado |
| Telas de histórico (T09) e fechamento de caixa (T10) | ⏳ próximo passo |
| AccessibilityService + overlay (Kotlin) | ⏳ Fase 1 |

`flutter analyze` sem avisos e **89 testes** passando.

### Como a camada local-first funciona

```
UI → Repository ─┬→ Drift (fonte de verdade de leitura)
                 └→ Outbox (fila)  →  SyncEngine  →  rpc_sync_rides
```

- A escrita grava no banco **e** enfileira o envio na mesma transação: ou os dois acontecem, ou nenhum.
- A UI nunca espera a rede. O `clientId` é um UUID gerado no dispositivo, o que torna o reenvio
  idempotente.
- Sem backend ou sem conexão, o `SyncEngine` devolve `SyncResult.offline` e deixa a fila intacta — a fila
  é o mecanismo de resiliência, não um estado de erro.
- O dashboard mostra quantos registros aguardam conexão, para o motorista saber que o dado está salvo.
- Cada tipo de entidade tem fila própria: a falha de um lote de despesas não impede as corridas de subirem.

Resolução de conflito por entidade:

| Entidade | Estratégia | Por quê |
|---|---|---|
| Corridas | *Insert-only*, idempotente por `client_id` | Fato histórico: não muda depois de gravado |
| Despesas | Last-write-wins por `updated_at` | O motorista corrige o valor digitado errado |
| Exclusão de despesa | *Soft delete* propagado como `deleted_at` | Ausência de linha não é informação: o servidor nunca saberia que foi removida |

## Requisitos

- **Flutter 3.47.7 (Dart 3.13.5)** ou superior
- Android SDK Platform 37, AGP 9.1.0, Kotlin 2.4.0, Gradle 9.3.1 (já fixados em `android/`)
- Para iOS: Xcode e macOS

## Rodando

```bash
flutter pub get
flutter run
```

Sem credenciais do Supabase o app roda em **modo local**: o cálculo e a UI funcionam e nada de rede é
tentado. É o que permite trabalhar na feature principal antes de o backend existir.

Com backend:

```bash
cp env/example.json env/dev.json   # preencha com os dados do seu projeto
flutter run --dart-define-from-file=env/dev.json
```

Instruções de cada chave em [env/README.md](env/README.md).

> ⚠️ **Nunca** passe `SUPABASE_SERVICE_ROLE_KEY`, chave secreta do Stripe ou do RevenueCat por
> `--dart-define`. Tudo que é compilado no app pode ser extraído do APK. Privilégio de servidor vive em
> Edge Function.

## Backend

```bash
supabase start                 # Postgres local
supabase db push               # aplica supabase/migrations/ na ordem
```

As migrations são a fonte única de verdade do schema. **Nunca edite uma migration já aplicada** — crie
uma nova.

## Verificação

Obrigatório antes de considerar qualquer alteração concluída:

```bash
dart format .
dart fix --apply
flutter analyze        # precisa terminar com "No issues found!"
flutter test
```

## Estrutura

```
lib/
├── app/              # MaterialApp, router, tema, providers compartilhados
├── core/             # config, formatação, utilidades de Decimal
├── features/         # uma pasta por feature: data / domain / presentation
└── shared/widgets/   # widgets reutilizáveis
supabase/migrations/  # schema, RLS, funções, views, pg_cron
.claude/skills/       # guias de desenvolvimento para agentes
```

## Toolchain

O projeto roda em Flutter 3.47.7 / Dart 3.13.5. A pasta `android/` foi alinhada ao template dessa
versão:

| Item | Valor | Por quê |
|---|---|---|
| AGP | 9.1.0 | Template do Flutter 3.47; o AGP 9 removeu `kotlinOptions` de dentro de `android {}` |
| Kotlin Gradle Plugin | 2.4.0 | `permission_handler_android` usa o DSL `kotlin { compilerOptions { } }` |
| Gradle | 9.3.1 | Exigido pelo AGP 9 |
| `compileSdk` | **37** (acima do padrão 36) | Exigido por `permission_handler_android` 14.x |
| `minSdk` | **26** (acima do padrão 24) | Exigido por `sentry_flutter` 10 |
| `id("kotlin-android")` | **removido** do `app/build.gradle.kts` | O AGP 9 já traz suporte a Kotlin; aplicar gera aviso de quebra futura |

### Consequência de produto do `minSdk 26`

Deixa de suportar **Android 7.0 e 7.1**. Em 2026 isso é uma fração pequena da base, e a alternativa era
publicar sem crash reporting — inaceitável. Se a telemetria da loja mostrar volume relevante em Android
7, a saída é trocar o Sentry por uma alternativa com `minSdk 24`, não baixar o `minSdk` de volta.

### Pendência conhecida: `riverpod_generator`

Continua fora, mas por outro motivo. Antes era o Dart < 3.12; agora é um conflito de `analyzer` com o
**`freezed`**:

- `riverpod_generator` ≥ 4.0.6 → `analyzer >=13.0.0 <15.0.0`
- `freezed` 3.2.x → `analyzer ^12.0.0`

Dá para ter um ou o outro. Como os providers escritos à mão funcionam e não custam nada
funcionalmente, o `freezed` fica. Se um dia o codegen de Riverpod virar prioridade, note que
`riverpod_generator` 4.x exige **Riverpod 3.x** — é uma migração com quebras, não uma troca de versão.

### Aviso remanescente no build

```
WARNING: Your app uses the following plugins that apply Kotlin Gradle Plugin (KGP):
flutter_tts, shared_preferences_android, url_launcher_android
```

São pacotes de terceiros, não o nosso código. Some quando eles atualizarem.

### iOS não verificado

O build iOS não foi testado — o ambiente de desenvolvimento é Windows. A pasta `ios/` foi gerada pelo
Flutter 3.41 e provavelmente precisa do mesmo alinhamento (deployment target mínimo, Podfile). Rode
`flutter build ios` num macOS antes de confiar nela.

### Rollback

Se a atualização do Flutter quebrar outro projeto desta máquina:

```bash
cd D:\DevPrograms\flutter
git checkout ff37bef603      # 3.41.4, Dart 3.11.1
flutter --version
```

Para voltar a este projeto à versão antiga também seria preciso reverter `android/` e remover o
`sentry_flutter` — ver o histórico deste README.

## Decisões de arquitetura que não são negociáveis

1. **O cálculo do veredicto é local e puro.** Nenhuma chamada de rede no caminho crítico. Orçamento:
   120 ms do evento de acessibilidade ao primeiro frame.
2. **Dinheiro é `Decimal`, nunca `double`.** `0.1 + 0.2 != 0.3` em fechamento de caixa é bug reportável.
3. **Regra de negócio fica no servidor.** Quota, limite de perfis e entitlement em RPC/trigger — a
   contagem no cliente é burlável.
4. **Texto bruto capturado da tela nunca é persistido nem transmitido.** Só métricas derivadas e o nome
   do bairro.
5. **RLS em 100% das tabelas.** Um furo de RLS vaza o dado financeiro de um motorista para outro.
