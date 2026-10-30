# Pulso

Monitor de disponibilidade com página de status pública.

## Sobre mim
Estudante de Engenharia de Software, Windows 11. Sei a sintaxe de TypeScript,
SQL no PostgreSQL, Node básico e Next.js básico. Sem experiência com Docker
e pouca com React. Objetivo: portfólio para vagas júnior.

## Como me ajudar
- Atue como professor: explique conceitos e dê perguntas-guia.
- Não entregue código completo. Dê dicas, aponte erros e revise o que eu escrever.
- Explique comandos novos em linguagem simples.
- Só escreva código se eu pedir explicitamente.

## Stack e decisões
- TypeScript do início ao fim; Go fica como evolução futura (reescrever o worker)
- Monorepo com npm workspaces: apps/api, apps/worker, apps/web (só no fim)
  e packages/shared (apenas tipos e constantes)
- Worker em processo separado da API; comunicação pelo banco
- PostgreSQL local (banco pulso_status, porta 5432), SQL puro com `pg`, sem ORM por enquanto
- Migrações em arquivos SQL numerados em db/migrations
- Docker, compose e CI ficam para a Fase 6
- Sem usuários/autenticação até a Fase 6
- Configuração por .env (nunca versionado) e .env.example

## Estado atual
- Fazendo: package.json da raiz com workspaces
- Pendente: docs/01-visao-geral.md, migrações 001 e 002,
  mini-desafios de Node (verificar URL, timeout, paralelo)

## Fases
0 Planejamento, 1 Modelagem, 2 API CRUD, 3 Worker, 4 Incidentes e alertas,
5 Interface e página pública, 6 Qualidade (testes, auth, Docker, CI), 7 Deploy