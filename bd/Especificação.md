# Convenções de nomenclatura para banco de dados

## Geral

Os nomes das tabelas e colunas devem estar **minúsculas** e as palavras devem ser separadas por **underscore**, seguindo o padrão [snake case](https://en.wikipedia.org/wiki/Snake_case). E todos os termos devem estar em português, porém sem acentuação.
Sempre prefira nomes descritivos, evitando ao máximo contrações.

## Tabelas

Os nomes das tabelas devem estar no **plural**.

Ex:

- **Bom**: `usuarios`, `missas`, `locais`, `funcoes`
- **Ruim**: `usuario`, `missa`, `local`, `funcao`

## Colunas

Os nomes das colunas devem estar no **singular**.

Ex:

- **Bom**: `cpf`, `nome`, `data_nascimento`
- **Ruim**: `enderecos`, `posts`, `funcoes`

## Foreign keys

Todas as foreign keys devem seguir o padrão `nome_da_tabela_no_singular_id`.

Por exemplo, caso a tabela `usuarios` tenha um relacionameto com a tabela `funcoes`, o nome da coluna foreign key da tabela `usuarios` deve ser `funcao_id`.

## Primary keys

A primary key de toda tabela deve ser uma coluna de inteiros com incremento automático (`SERIAL`), chamada `id`.

<!-- ## Timestamps

Toda tabela deve definir duas colunas para colocar os timestamps: `created_at` e `updated_at`. A coluna `created_at` recebe automaticamente o timestamp do momento que o registro for criado. A coluna `updated_at` recebe automaticamente o timestamp do momento que o registro for alterado. -->

## Especificação do banco de dados

Definição de tabelas

1. **usuario** - Lista de usuários do sistema
1. **funcao** - Definições de funções a serem executadas pelos usuários
1. **usuario_funcao** - tabela de relacionamento entre usuários e funções. Estabelece que determinado usuário pode realizar alguma função. Como uma pessoa pode ser escalada para diferentes atividades em diferentes missas a relação entre função e usuário será por tabela.
1. **local** - Local físico da igreja ou capela
1. **usuario_local** - Relacionamento entre usuário e igreja ou capela que o usuário frequenta.
1. **equipe_musica** - Equipe de musica responsável pela musica da celebração.
1. **usuario_equipe_musica** - Tabela de relacionamento entre os usuários e a equipe de música.
1. **missa** - Registro de cada missa a ser celebrada. Integra locais, participantes e o que mais for necessário
1. **horarios** - Registro de horários de celebração realizados em cada local.
