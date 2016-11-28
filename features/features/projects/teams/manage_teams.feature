# language: pt

Funcionalidade: Gerenciamento de times em um projeto

  Cenário: Usuário adiciona time em projeto
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um time chamado "Time_1" com os seguintes membros
      | email                |
      | usuario2@example.com |
    E ele possui um projeto privado chamado "Projeto_1"
    Quando ele adicionar o seguinte time ao projeto
      | nome   | permissao |
      | Time_1 | Reader    |
    Então ele deve ver os seguintes times no projeto
      | nome   | permissao |
      | Time_1 | Reader    |
    E "usuario2@example.com" deve visualizar "Projeto_1" em seus projetos

  Cenário: Usuário remove time de um projeto
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um time chamado "Time_1" com os seguintes membros
      | email                |
      | usuario2@example.com |
    E ele possui um projeto privado chamado "Projeto_1" com os times
      | nome   | permissao |
      | Time_1 | Reader    |
    Quando ele remove o time "Time_1" do "Projeto_1"
    Então ele não deve ver nenhum time no projeto
    E "usuario2@example.com" não deve visualizar "Projeto_1" em seus projetos

  Cenário: Usuário aumenta permissão de um time
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um time chamado "Time_1" com os seguintes membros
      | email                |
      | usuario2@example.com |
    E ele possui um projeto privado chamado "Projeto_1" com os times
      | nome   | permissao |
      | Time_1 | Reader    |
    Quando ele der para o time "Time_1" permissão de "Writer"
    Então ele deve ver os seguintes times no projeto
      | nome   | permissao |
      | Time_1 | Writer    |
