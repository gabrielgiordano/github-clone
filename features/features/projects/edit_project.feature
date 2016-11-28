# language: pt

Funcionalidade: Edição de um projeto

  Cenário: Usuário edita seu projeto
    Dado o seguinte projeto
      | autor        | usuario@example.com |
      | nome         | Projeto_1           |
      | descrição    | Descrição Qualquer  |
      | visibilidade | Público             |
    Quando "usuario@example.com" editar a descrição do projeto para "Outra descrição"
    Então ele deve ser redirecionado para a visualização do projeto
    E o projeto deve conter a nova descrição

  Cenário: Usuário edita seu projeto com dados inválidos
    Dado o seguinte projeto
      | autor        | usuario@example.com |
      | nome         | Projeto_1           |
      | descrição    | Descrição Qualquer  |
      | visibilidade | Público             |
    Quando "usuario@example.com" editar a descrição do projeto para ""
    Então ele deve ser informado a descrição não pode ser vazia
