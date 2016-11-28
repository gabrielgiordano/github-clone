# language: pt

Funcionalidade: Deletar um projeto

  Cenário: Usuário deleta seu projeto
    Dado o seguinte projeto
      | autor        | usuario@example.com |
      | nome         | Projeto_1           |
      | descrição    | Descrição Qualquer  |
      | visibilidade | Público             |
    Quando "usuario@example.com" deletar seu projeto
    Então ele deve ser redirecionado para a listagem de projetos
    E a listagem não deve conter o projeto
