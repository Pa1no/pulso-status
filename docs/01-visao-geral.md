# Visão geral do projeto: propósito, direção e caminho

## Para quê?
Ele tem o intuito de monitorar se os serviços de uma aplicação estão funcionando corretamente, relatando qualquer tipo de alteração ou desvio, informando o tempo de queda e qual o tipo de incidente no serviço.

## Para quem?
Desenvolvedores autônomos que gerenciam sites, lojas ou sistemas web e precisam garantir que todos os serviços estejam ativos e funcionando, porém não conseguem entrar a todo momento para verificar se tudo está ocorrendo como o esperado. Assim, o Pulso mantém a transparência para quem vê a página de monitoramento, sendo esse público os clientes.

## 5 coisas que eu copiaria de um pulso já existente (githubstatus.com por exemplo)
1 - Linha do tempo com "sticks" para mostrar o funcionamento durante os dias
2 - histórico do tempo de atividade com os dias disponíveis para visualização
3 - histórico de incidentes
4 - relato sobre os incidentes
5 - duração da degradação/incidência no serviço afetado

## 2 coisas que eu faria diferente
1 - Ao invés de mostrar poucos detalhes sobre o incidente, um agente humano do Pulso irá investigá-los e detalhá-los 
    sem expor dados sensíveis (URLs sensíveis, endpoints internos, detalhes que compartilham senhas, chaves, nomes internos, etc) como parte das informações fornecidas, pois isso traz mais transparência com os usuários
2 - Em vez de apenas mostrar quais páginas estão sendo relatadas pelo Pulso, o mesmo irá dar a possibilidade do usuário entrar nas
    aplicações pelo próprio monitor sem precisar sair dele para conferir se o serviço que ele procura está instável ou saudável
