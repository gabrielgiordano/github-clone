# language: pt

Funcionalidade: Gerenciamento membros dos times de um usuário

  Cenário: Usuário visualiza membros de um time
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um time chamado "Time 1" com os seguintes membros
      | usuario2@example.com |
      | usuario3@example.com |
    Quando ele visualizar os membros do "Time 1"
    Então ele deve ver os seguintes usuários no time
      | usuario2@example.com |
      | usuario3@example.com |

  Cenário: Usuário adicionar membro em um time
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um time chamado "Time 1" com os seguintes membros
      | usuario2@example.com |
      | usuario3@example.com |
    Quando ele adicionar um membro "usuario4@example.com" no time
    Então ele deve ver os seguintes usuários no time
      | usuario2@example.com |
      | usuario3@example.com |
      | usuario4@example.com |

  Cenário: Usuário remove membro de um time
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um time chamado "Time 1" com os seguintes membros
      | usuario2@example.com |
      | usuario3@example.com |
    Quando ele remover o membro "usuario3@example.com" no time
    Então ele deve ver os seguintes usuários no time
      | usuario2@example.com |
