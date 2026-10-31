# Decisões tomadas para construção da arquitetura do projeto

## Decisões Back-end

### 31/10
- O Worker será executado em um processo independente da API, comunicando-se com ela por meio do banco. 
  Essa separação permite que tarefas demoradas sejam processadas em segundo plano. Além disso, proporciona isolamento de falhas e facilidade de escalabilidade.
- Utilização do padrão ES Modules, tendo em vista os custos aceitos ('tsconfig' alinhado, imports com extensão) e benefícios
  (padrão atual e mesmo estilo de import do front-end)
- Express 5 como framework para o Node.js pelo gerenciamento automático do fluxo de erros assíncronos. Aviso: tutoriais
  antigos assumem versão 4

## Decisões estrutura

### 31/10
- A implementação do Docker ficará para a fase 6 do projeto, sendo acrescentado depois de quase tudo ter sido concluído
- Sem usuários até a Fase 6

## Decisões PostgreSQL

### 31/10
- Uso de ON DELETE RESTRICT para não apagar o histórico por descuido
- Sem coluna 'status' em "incidentes", pois o estado é deduzido de 'resolvido_em'
- Índice parcial: a regra “um aberto por monitor” vive no banco
- Utilização de TIMESTAMPTZ para data com fuso horário
- Uso de BIGINT no id de "resultados"
- Separação de 'migrations/' e 'tests/'
- Constraints nomeadas
- Padrão VARCHAR(256) para 'nome'

## Em aberto

### 31/10
- Lento conta ou não como disponível

## Decisões futuras

### 31/10
- Fila fica como uma implementação futura
- Uma coluna ou duas (URL de checagem e URL pública)?