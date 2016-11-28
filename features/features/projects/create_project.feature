# language: pt

Funcionalidade: Criar projeto para um usuário

  Cenário: Dados inválidos
    Dado um usuário "usuario@example.com" logado no sistema
    Quando "usuario@example.com" criar um projeto com os seguintes dados
      | nome         | Projeto_1 |
      | descrição    |           |
      | visibilidade |           |
    Então ele deve ser informado que existem campos faltando

  Cenário: Projeto público
    Dado um usuário "usuario@example.com" logado no sistema
    Quando "usuario@example.com" criar um projeto com os seguintes dados
      | nome         | Projeto_1          |
      | descrição    | Descrição Qualquer |
      | visibilidade | Público            |
    Então ele deve ser redirecionado para a visualização do projeto
    E o projeto deve conter as mesmas informações fornecidas pelo usuário

  Cenário: Projeto privado
    Dado um usuário "usuario@example.com" logado no sistema
    Quando "usuario@example.com" criar um projeto com os seguintes dados
      | nome         | Projeto_1          |
      | descrição    | Descrição Qualquer |
      | visibilidade | Privado            |
    Então ele deve ser redirecionado para a visualização do projeto
    E o projeto deve conter as mesmas informações fornecidas pelo usuário
