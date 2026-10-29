# Decisões tomadas para construção da arquitetura do projeto

## Decisão 1
O worker ficará em um processo separado do Next.js, fazendo com que ele não morra no meio do processo e consiga concluir tudo com
o seu próprio tempo.

## Decisão 2
A implementação do Docker ficará para a fase 6 do projeto, sendo acrescentado depois de quase tudo ter sido concluído.