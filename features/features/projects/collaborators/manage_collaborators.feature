# language: pt

Funcionalidade: Gerenciamento de colaboradores de um projeto

  Cenário: Usuário adicionar colaborador em projeto
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um projeto privado chamado "Projeto_1" com os seguintes colaboradores
      | email                | permissao |
      | usuario1@example.com | Owner     |
    Quando ele adicionar o seguinte colaborador
      | email                | permissao |
      | usuario2@example.com | Reader    |
    Então ele deve ver os seguintes colaboradores no projeto
      | email                | permissao |
      | usuario1@example.com | Owner     |
      | usuario2@example.com | Reader    |
    E "usuario2@example.com" deve visualizar "Projeto_1" em seus projetos

  Cenário: Usuário remove colaborador de um projeto
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um projeto privado chamado "Projeto_1" com os seguintes colaboradores
      | email                | permissao |
      | usuario1@example.com | Owner     |
      | usuario2@example.com | Reader    |
    Quando ele remove o colaborador "usuario2@example.com"
    Então ele deve ver os seguintes colaboradores no projeto
      | email                | permissao |
      | usuario1@example.com | Owner     |
    E "usuario2@example.com" não deve visualizar "Projeto_1" em seus projetos

  Cenário: Usuário aumenta permissão de um colaborador
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um projeto privado chamado "Projeto_1" com os seguintes colaboradores
      | email                | permissao |
      | usuario1@example.com | Owner     |
      | usuario2@example.com | Reader    |
    Quando ele der para o "usuario2@example.com" permissão de "Writer"
    Então ele deve ver os seguintes colaboradores no projeto
      | email                | permissao |
      | usuario1@example.com | Owner     |
      | usuario2@example.com | Writer    |
