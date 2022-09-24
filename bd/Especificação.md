#Especificação do banco de dados

Definição de tabelas

1. **Usuario** - Lista de usuários do sistema
1. **Funcao** - Definições de funções a serem executadas pelos usuários
1. **Usuario_funcao** - tabela de relacionamento entre usuários e funções. Estabelece que determinado usuário pode realizar alguma função. Como uma pessoa pode ser escalada para diferentes atividades em diferentes missas a relação entre função e usuário será por tabela.
1. **Local** - Local físico da igreja ou capela
1. **Usuario_local** - Relacionamento entre usuário e igreja ou capela que o usuário frequenta.
1. **EquipeMusica** - Equipe de musica responsável pela musica da celebração.
1. **Usuario_EquipeMusica** - Tabela de relacionamento entre os usuários e a equipe de música.
1. **Missa** - Registro de cada missa a ser celebrada. Integra locais, participantes e o que mais for necessário
1. **Horarios** - Registro de horários de celebração realizados em cada local.
