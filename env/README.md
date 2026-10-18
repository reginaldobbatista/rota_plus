# Configuração de ambiente

Os valores daqui entram no app em tempo de build, por `--dart-define-from-file`.
**Nada deste diretório vai para o repositório**, exceto este README e o
`example.json` — veja o `.gitignore`.

## Como configurar

```bash
cp env/example.json env/dev.json
```

Depois edite `env/dev.json` com os valores do seu projeto Supabase
(**Settings → API**):

| Chave | Onde encontrar | Observação |
|---|---|---|
| `SUPABASE_URL` | "Project URL" | Só o domínio: `https://xxxx.supabase.co`. **Sem** `/rest/v1/` — com o caminho, o login quebra |
| `SUPABASE_ANON_KEY` | "Publishable key" (`sb_publishable_…`) | A chave legada `anon` também funciona, mas está em descontinuação |
| `SENTRY_DSN` | Painel do Sentry | Vazio desliga a telemetria |
| `REVENUECAT_PUBLIC_KEY` | Painel do RevenueCat | Só a chave **pública** do SDK |

## Como rodar

```bash
flutter run --dart-define-from-file=env/dev.json
```

Sem o arquivo, o app roda em **modo local**: cálculo e interface funcionam, e
nenhuma chamada de rede é tentada.

## O que nunca pode entrar aqui

| Chave | Por quê |
|---|---|
| `service_role` / `sb_secret_…` do Supabase | Ignora a RLS por completo. Daria acesso ao banco inteiro de todos os motoristas |
| Chave secreta do Stripe | Permite movimentar cobranças |
| Chave secreta do RevenueCat | Permite conceder assinatura a qualquer um |
| Senha do banco Postgres | Acesso administrativo direto |

Tudo que é compilado no app **pode ser extraído do APK** — basta descompactar.
Não existe "chave escondida no binário". Qualquer segredo de servidor vive em
Edge Function, onde o código não sai do servidor.

A chave publicável é a exceção justamente porque ela **não é um segredo**: ela
só é segura porque toda tabela tem RLS. É por isso que o CI falha o build se
alguma tabela de `public` ficar sem RLS habilitada.
