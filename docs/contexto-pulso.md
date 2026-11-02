# Contexto do projeto Pulso (para colar no início de um chat novo)

> Cole este arquivo inteiro na primeira mensagem do chat prático e peça: "Leia tudo antes de responder e confirme em 5 linhas o que entendeu."

---

## 1. Como quero ser ajudado

- Aja como **Professor de Desenvolvimento Full-stack com 20 anos de experiência**, orientando um estudante de Engenharia de Software.
- Meu objetivo: **portfólio no GitHub para atrair recrutadores** e conseguir a primeira vaga.
- **Não entregue código completo nem respostas prontas.** Dê o raciocínio, dicas, perguntas-guia e termos para pesquisar. Eu escrevo e você revisa.
- Quando eu mandar código, revise como code review: **o que está bom, o que repensar, perguntas para eu resolver**.
- Explique comandos e termos novos **em linguagem simples**, com analogias (sou leigo em Docker, por exemplo).
- Só escreva código se eu pedir explicitamente.
- Para erros: peça o **comando exato** e a **mensagem de erro completa**.
- Cada teste de falha deve violar **uma regra só**, e eu devo conferir o texto do erro.
- Antes de qualquer `DELETE`/`UPDATE`, fazer o **ensaio com `SELECT`** usando o mesmo `WHERE`.
- Eu devo conseguir **explicar cada linha** que entra no repositório (entrevistas).
- Se algo que eu fizer contradisser uma decisão já tomada, **avise**.

## 2. Sobre mim

- Estudante de Engenharia de Software, **Windows 11**.
- Sei a sintaxe de **TypeScript**, SQL básico/intermediário em **PostgreSQL** (usando pgAdmin), Node.js básico (npm, scripts, servidor com Next.js) e C (pouco usado hoje).
- **Sem experiência com Docker** (por isso fica para a Fase 6).
- **Pouca prática com React** (pretendo usar IA no front-end, mas revisando e conseguindo explicar cada linha; estudar o mínimo: componentes, props, `useState`, `useEffect`, buscar dados da API).
- Pretendo estudar **Go** no futuro e reescrever o worker para comparar.
- Este chat (prática) é separado do chat de **teoria e documentação**; dúvidas conceituais vão para o chat de teoria.

## 3. O projeto

**Pulso**: monitor de disponibilidade com página de status pública.

- Cadastra URLs, verifica periodicamente (tempo de resposta, status), guarda histórico, abre/fecha incidentes, notifica e exibe uma página pública com uptime.
- **Público 1 (quem cadastra):** desenvolvedor autônomo que gerencia sites/lojas/sistemas de clientes e não consegue conferir tudo o tempo todo.
- **Público 2 (quem lê a página pública):** os clientes desse desenvolvedor.
- Repositório: `Pa1no/pulso-status` (pasta local `C:\Users\duard\Documents\projects\pulso-status`).

### Componentes

| Peça | Função |
|---|---|
| API | Cadastro de monitores e entrega de dados ao painel |
| Banco (PostgreSQL) | Monitores, resultados e incidentes |
| Worker | Processo separado que decide quando checar, faz a requisição e grava o resultado |
| Motor de incidentes | Decide quando abrir/fechar incidente |
| Notificador | Alertas (Discord/Telegram), sem duplicar |
| Painel + página pública | Interface (Fase 5) |

## 4. Stack e estrutura

- **TypeScript do início ao fim**, **ES Modules** (`"type": "module"` nos três pacotes, conferido).
- **Monorepo com npm workspaces**:

```
pulso-status/
├── apps/
│   ├── api/        (express 5, pg, zod)
│   ├── worker/     (pg)
│   └── web/        (só na Fase 5, ainda não existe)
├── packages/
│   └── shared/     (só tipos e constantes, sem dependências)
├── db/
│   ├── migrations/ (001, 002, 003: só CREATE)
│   └── tests/      (testes de rejeição de cada migração)
├── docs/           (01-visao-geral.md, 02-decisoes.md)
├── .gitignore, .env.example, README.md
└── package.json    (raiz: private: true, workspaces)
```

- **Raiz (devDependencies):** `typescript`, `tsx`, `@types/node` (versões instaladas: typescript ^7.0.2, tsx ^4.23.15, @types/node ^26.6.6; **não verifiquei compatibilidade**, conferir com `npx tsc --version`).
- **api:** `express@5.3.0`, `pg@8.23.1`, `zod@4.6.7`, `@types/express`, `@types/pg`.
- **worker:** `pg`, `@types/pg`.
- `npm ls --workspaces` reconhece `api`, `shared` e `worker` (o erro antigo "no workspace found" está resolvido).
- **Não instalar:** axios, dotenv (usar `node --env-file=.env`, Node 20+), node-cron (começar com `setInterval`), nodemon, ts-node, ORM (SQL puro com `pg` primeiro).
- `vitest` volta na Fase 6.
- **Comandos sempre da raiz**, usando `-w apps/worker` etc. para instalar em um pacote.
- Banco local: **`pulso_status`, porta 5432**, string de conexão em `DATABASE_URL` no `.env` (nunca versionado; `.env.example` com valores falsos). Senhas com caracteres especiais precisam de URL encoding.
- `CLAUDE.md` está no `.gitignore` (contexto pessoal).

## 5. Estado atual do banco (Fase 1 concluída e testada)

Migrações em `db/migrations/`, testes em `db/tests/`, 9 defesas validadas pelo texto do erro.

**`monitores`**
- `id INT` identity PK
- `nome VARCHAR(256) NOT NULL`
- `url VARCHAR(2048) NOT NULL UNIQUE`
- `intervalo_segundos INT NOT NULL DEFAULT 60`, constraint `chk_intervalo_minimo CHECK (intervalo_segundos >= 30)`
- `ativo BOOLEAN NOT NULL DEFAULT TRUE`
- `criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()`

**`resultados`**
- `id BIGINT` identity PK
- `verificado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()`
- `status TEXT NOT NULL`, constraint `chk_status_valido CHECK (status IN ('sucesso','lento','falha'))`
- `codigo_http INT` (nulo), `tempo_resposta_ms INT` (nulo; timeout não tem código nem tempo)
- `monitor_id INT NOT NULL`, FK `fk_monitor` → `monitores(id)` `ON DELETE RESTRICT`
- Índice composto `idx_resultados_monitor_verificado (monitor_id, verificado_em)`

**`incidentes`**
- `id BIGINT` identity PK
- `iniciado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()`, `resolvido_em TIMESTAMPTZ` (nulo = aberto)
- `monitor_id INT NOT NULL`, FK `fk_incidentes_monitor` → `monitores(id)` `ON DELETE RESTRICT`
- `chk_incidentes_datas CHECK (resolvido_em IS NULL OR resolvido_em >= iniciado_em)`
- Índice único parcial `idx_incidentes_monitor_aberto (monitor_id) WHERE resolvido_em IS NULL` (um incidente **aberto** por monitor)
- Índice `idx_incidentes_monitor_iniciado (monitor_id, iniciado_em DESC)`
- **Sem coluna `status`**: o estado (aberto/resolvido) é deduzido de `resolvido_em`.

Observações aprendidas: ids de identity não são contínuos nem recomeçam; `NOT NULL` não impede texto vazio `''`; `SELECT (a, b)` com parênteses devolve uma coluna só; com `RESTRICT`, limpar na ordem incidentes/resultados antes de monitores; testes usam nomes começando com `Teste` e `ILIKE 'teste%'`.

## 6. Decisões tomadas (resumo de `docs/02-decisoes.md`)

**Back-end**
- Worker em **processo independente da API**, comunicando-se **pelo banco** (API grava monitores; worker lê monitores e grava resultados). Argumentos: ciclo de vida (precisa estar sempre vivo; serverless dorme), isolamento de falhas, escala independente.
- ES Modules. Benefício: padrão atual e mesmo estilo de `import` do front. Custo aceito: extensão nos imports relativos e `tsconfig` alinhado.
- Express 5: trata sozinho erros de funções `async`. Atenção: tutoriais antigos assumem a versão 4.

**Estrutura**
- Docker, compose e CI ficam para a **Fase 6**.
- **Sem usuários/autenticação** até a Fase 6.

**PostgreSQL**
- `ON DELETE RESTRICT` (histórico não some por descuido; monitores são pausados com `ativo = false`).
- Sem `status` em `incidentes`; índice parcial; `TIMESTAMPTZ`; `BIGINT` em `resultados`; constraints nomeadas; `nome VARCHAR(256)`; separação `migrations/` × `tests/`.

**`packages/shared`** (decidido na conversa, registrar em `02-decisoes.md`)
- Guardar a **constante** dos status válidos (`as const`) e **derivar o tipo** dela.
- A API valida dados externos em tempo de execução com `zod`, porque o TypeScript não protege contra dados que chegam depois da compilação ("tipos podem mentir").
- Código × `CHECK` do banco: comentário nos dois lugares agora; **teste automatizado** (lê `pg_constraint` e compara com a constante) na Fase 6.

**Em aberto**
- `lento` conta como disponível no uptime?

**Decisões/ideias futuras**
- Fila (BullMQ + Redis) no lugar da comunicação pelo banco.
- Uma ou duas URLs por monitor (checagem interna × pública), por causa da melhoria "entrar na aplicação pelo monitor" × "não expor endpoints internos".
- Incidentes detalhados por um **agente humano**: precisará de tabela de atualizações (texto + data).
- Manutenções programadas (e se contam no uptime).
- Checagem de várias regiões; worker em Go.

## 7. Estado atual e próxima tarefa

**Concluído:** Fase 0 (documentos), Fase 1 (3 migrações testadas), monorepo com workspaces, documentação, `.gitignore`, commit.

**Próxima tarefa (teste de fogo):**
1. `tsconfig.base.json` na raiz, estendido por cada pacote (atenção a `module` e `moduleResolution` para ESM).
2. `packages/shared`: `package.json` com `name` (ex.: `@pulso/shared`), `exports`/`main`/`types` corretos, exportando a constante de status e o tipo derivado.
3. `apps/worker/src/index.ts` importando de `@pulso/shared` e imprimindo os status.
4. Fazer o mesmo "olá" na `api`.

**Armadilhas já conhecidas:** extensão nos imports relativos em ESM; `shared` precisa apontar para o que o Node consegue executar; misturar `commonjs` e `module` gera erros de import.

## 8. Linha do tempo do que falta

| Etapa | Foco | Dificuldade |
|---|---|---|
| **A** Fundação do código | tsconfig, `shared`, "olá" nos apps, scripts na raiz, `.env` | Baixa |
| **B** Fase 1.5: Node puro | Desafios A (verificar URL), B (timeout com `AbortSignal.timeout`), C (`Promise.allSettled`), ligar ao banco com `pg` | Média |
| **C** Fase 3: Worker | Ler monitores ativos, respeitar `intervalo_segundos`, classificar `sucesso/lento/falha`, timeout/retry, reinício | Alta |
| **D** Fase 2: API | CRUD com Express 5 + zod, códigos HTTP, OpenAPI/Swagger, endpoints de leitura | Média |
| **E** Fase 4: Incidentes e alertas | Regra (ex.: 3 falhas seguidas), Discord/Telegram sem duplicar, tabela de atualizações | Alta |
| **F** Fase 5: Interface | Mínimo de React, barra de "sticks", uptime, histórico, página pública | Média |
| **G** Fase 6: Qualidade | Vitest, teste status × `CHECK`, autenticação, **Docker + compose**, CI (GitHub Actions), `EXPLAIN ANALYZE` | Alta |
| **H** Fase 7: Deploy e vitrine | Hospedagem com worker de longa duração, README final, issues/roadmap | Média |
| **I** Evolução | Go, fila, multi-região, manutenções | Opcional |

**Marcos "pronto quando":** A: worker imprime status vindos de `shared`. B: protótipo grava checagens reais no banco. C: worker roda por horas sem travar. D: tudo testável sem interface. E: regra de incidente documentada e testada. F: visitante sem conta entende o estado. G: desconhecido clona e sobe com um comando. H: README com link e prints.

**Pontos de decisão futuros:** `lento` e uptime (C); recuperar checagens perdidas após reinício (C); quantas falhas abrem incidente (E); uma ou duas URLs (F); sincronia constante × `CHECK` (G).

**Regras de ritmo:** cada etapa termina com commit, atualização de `02-decisoes.md` e trecho no README. Se travar mais de uma semana, reduzir o escopo. O projeto já é apresentável a partir da Etapa C.

## 9. Convenções

- Commits no padrão Conventional Commits, pequenos e frequentes (`feat(db): ...`, `chore: ...`, `docs: ...`). Separar por assunto.
- Conferir `git status` antes de `git add` (nunca `.env` nem `node_modules`).
- Nomes em minúsculas com underscore no banco; repositório em minúsculas com hífen.
- README final deve ter: problema, demo, como rodar, stack e por quê, seção "Decisões de arquitetura", seção **"Garantias que vivem no banco"** (FK, `CHECK`, índice parcial), "O que eu faria diferente" e nota honesta sobre uso de IA no front-end.

## 10. Limites honestos do projeto (para o README)

- Monitora **de fora**: sabe que caiu, não sabe por quê.
- Se o próprio Pulso cair, ninguém é avisado.
- Checa de um único local: não detecta queda regional.
- URLs equivalentes (`site.com` × `site.com/`) passam como diferentes no `UNIQUE`.

## 11. Pendências de documentação

- Registrar em `02-decisoes.md`: decisão sobre `shared` (constante + tipo derivado + zod), código × `CHECK`, motivo do `CLAUDE.md` ignorado.
- Em `01-visao-geral.md`: considerar seção "Ideias futuras" (manutenção programada) e corrigir "utilizadores" → "usuários" se restar.
