---
name: token-economy
description: Reduz consumo de tokens e de contexto em qualquer tarefa — busca, leitura de arquivo, edição, build, teste, log e resposta. Use ao explorar codebase desconhecida, antes de ler arquivo grande, ao investigar erro em log extenso, ao rodar comando de saída volumosa, quando o contexto estiver enchendo, ou quando o usuário pedir para economizar tokens, ser mais direto ou gastar menos.
---

# Economia de Tokens

Contexto é recurso finito. Cada token gasto em saída inútil é token que falta para raciocinar sobre o
problema — e contexto cheio degrada a qualidade da resposta, não só o custo.

**Princípio único:** *recupere a menor quantidade de informação que ainda responde à pergunta.*

Economia nunca justifica entregar trabalho incompleto ou pular verificação. Se a escolha é entre gastar
tokens e entregar algo não verificado, gaste os tokens.

## A hierarquia de custo

Do mais barato ao mais caro. Suba um nível só quando o anterior não resolver:

| Nível | Ação | Custo típico |
|---|---|---|
| 1 | `Grep` com `output_mode: "count"` ou `files_with_matches` | dezenas de tokens |
| 2 | `Glob` para localizar arquivo por nome | dezenas |
| 3 | `Grep` com `output_mode: "content"` e `-C 3` | centenas |
| 4 | `Read` com `offset` + `limit` | centenas |
| 5 | `Read` do arquivo inteiro | milhares |
| 6 | Subagente de exploração | milhares, mas **fora** do seu contexto |

Pular direto para o nível 5 num arquivo de 3.000 linhas para conferir uma assinatura de função é o
desperdício mais comum que existe.

## Busca antes de leitura

```
# ERRADO: ler 2.000 linhas para achar onde a função é chamada
Read lib/features/semaphore/evaluate_ride.dart

# CERTO: localizar primeiro, ler só o trecho
Grep pattern="evaluateRide" output_mode="content" -n=true -C=3
Read file_path=... offset=142 limit=40
```

Regras:

- **Sempre** `head_limit` em `Grep` quando o padrão pode casar muito (padrão: 250; reduza para 20–50
  numa sondagem).
- `output_mode: "count"` primeiro quando a pergunta é "existe?" ou "quantos?". Só depois peça conteúdo.
- `-o` (`only_matching`) quando você quer o valor casado, não a linha toda.
- Filtre com `glob` ou `type`: `Grep pattern="..." type="dart"` evita varrer `build/`, `.dart_tool/`
  e assets.
- Um `Grep` bem escrito substitui cinco `Read`.

## Leitura de arquivo

- **Nunca releia** um arquivo que você já leu nesta conversa, nem após editá-lo. `Edit` falha se não
  aplicar — se não falhou, aplicou. Reler para "conferir" é puro desperdício.
- Leia por faixa quando sabe a região: `offset` + `limit`.
- Arquivo gerado (`*.g.dart`, `*.freezed.dart`, lockfile, `build/`): não leia. Leia a fonte que o gera.
- Antes de `Read` num arquivo grande, pergunte: *preciso do arquivo ou de três linhas dele?*
- `allow_large: true` só quando o usuário pediu o arquivo todo ou você genuinamente precisa dele.

## Comandos de shell: corte na origem

O caro não é rodar o comando, é a saída voltar inteira para o contexto.

```bash
# ERRADO
flutter test
git log
cat descritivo_rota_plus.md

# CERTO
flutter test 2>&1 | tail -20
git log --oneline -10
sed -n '400,440p' descritivo_rota_plus.md
```

Padrões que valem memorizar:

| Em vez de | Use |
|---|---|
| `cat arquivo` | `sed -n 'I,Fp' arquivo`, `head -n N`, `tail -n N` |
| `ls -R` | `Glob` com padrão, ou `find ... -maxdepth 2` |
| `npm install` / `flutter pub get` verboso | `... 2>&1 \| tail -5` |
| `flutter analyze` | já é enxuto — mas `\| tail -30` se houver dezenas de issues |
| `flutter test` | `--reporter=failures-only`, ou `\| tail -20` |
| `git diff` | `git diff --stat` primeiro; o diff completo só do arquivo relevante |
| `grep -r` no shell | a ferramenta `Grep` (respeita `.gitignore`, mais barata) |
| Dump de JSON grande | `jq '.campo'` para extrair só o que importa |

- Erro em build longo: `2>&1 | grep -iE "error|failed" | head -20`. A pilha inteira raramente agrega.
- Comando longo e irrelevante para o raciocínio imediato: rode em background e siga trabalhando.

## Edição

- `Edit` com `old_string` mínimo e único. Não cole 50 linhas para trocar uma palavra.
- `replace_all: true` em vez de N chamadas `Edit` para a mesma substituição.
- `Write` só para arquivo novo ou reescrita real. Para mudança parcial, `Edit` — `Write` exige ter o
  conteúdo todo em contexto.
- Várias edições no mesmo arquivo: mande as chamadas `Edit` na mesma resposta, em sequência.

## Paralelismo

Chamadas independentes vão **na mesma resposta**. Serializar sem dependência real paga o custo de
contexto de cada rodada sem ganho nenhum:

```
# ERRADO: três rodadas
Grep "Supabase.initialize"  → espera → Read pubspec.yaml → espera → Glob "**/*.sql"

# CERTO: uma rodada
Grep "Supabase.initialize" + Read pubspec.yaml + Glob "**/*.sql"
```

## Delegação (quando houver subagente disponível)

Delegue quando a tarefa é **fan-out com resposta curta**: varrer muitos arquivos, mapear convenções de
nomenclatura, achar onde algo está. O subagente queima o contexto dele e devolve a conclusão.

Não delegue quando: a tarefa é pequena, você já tem o contexto, ou a resposta depende de histórico
desta conversa — o subagente começa do zero e reconstruir custa mais do que fazer.

E não delegue sem o usuário pedir, se as instruções da sessão proibirem.

## Saída para o usuário

A resposta também custa — e a verbosidade custa a atenção de quem lê, o que é pior.

- **Não repita código que você acabou de escrever.** O usuário tem o arquivo. Diga o que mudou e por quê.
- Não narre o processo (`"Vou buscar... agora vou ler... encontrei..."`). Entregue o resultado.
- Sem preâmbulo (`"Ótima pergunta!"`) e sem recapitulação do que já foi dito.
- Tabela ou lista > parágrafo, quando o conteúdo é comparativo ou enumerável.
- Não liste opções que você não vai seguir. Recomende uma.
- Pergunta direta merece resposta direta: uma ou duas frases, sem relatório em volta.
- Não produza resumo de fim de turno que repita o que as mensagens anteriores já disseram.

## Limpeza

- Arquivo temporário vai no diretório de scratchpad da sessão, não no projeto.
- Apagou/terminou de usar um temporário? Remova no mesmo turno — evita reaparecer em busca futura e
  poluir contexto depois.
- Não gere artefato intermediário que ninguém vai ler.

## Antipadrões

| Antipadrão | Custo | Em vez disso |
|---|---|---|
| `Read` do arquivo todo para ver uma função | Milhares de tokens | `Grep` + `Read` com faixa |
| Reler arquivo após `Edit` | Dobra o custo, ganho zero | Confie no resultado do `Edit` |
| `cat` em arquivo grande | Milhares | `sed -n`/`head`/`tail` |
| Saída de teste/build completa | Milhares | `tail -20`, `grep -i error` |
| Chamadas sequenciais sem dependência | N rodadas de contexto | Paralelize na mesma resposta |
| Reproduzir no chat o código escrito | Duplica tudo | Resuma a mudança |
| Explorar "por garantia" sem pergunta definida | Ilimitado | Formule a pergunta, então busque |
| Ler arquivo gerado ou lockfile | Milhares | Leia a fonte |
| Resumo longo repetindo o turno | Centenas | Uma ou duas linhas |

## O limite da economia

Não economize cortando:

- **Verificação** — `flutter analyze` e `flutter test` rodam sempre, mesmo que a saída custe.
- **Leitura de arquivo antes de sobrescrever** — nunca sobrescreva o que você não leu.
- **Escopo pedido pelo usuário** — entregar menos não é economia, é trabalho incompleto.
- **Correção de erro real** — investigue até a causa, não até o orçamento.

Economia é cortar redundância, nunca rigor.
