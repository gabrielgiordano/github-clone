# language: pt

Funcionalidade: Gerenciamento de times de um usuário

  Cenário: Usuário visualiza seus times
    Dado um usuário "usuario@example.com" logado no sistema com os seguintes times
      | Time 1 |
      | Time 2 |
    Quando ele visualizar todos os times
    Então a listagem deve conter os times
      | Time 1 |
      | Time 2 |

  Cenário: Usuário cria time
    Dado um usuário "usuario@example.com" logado no sistema
    Quando Ele criar um time chamado "Time 1"
    Então ele deve ser redirecionado para a listagem de times
    E a listagem deve conter "Time 1"

  Cenário: Usuário edita time
    Dado um usuário "usuario@example.com" logado no sistema com um time chamado "Time 1"
    Quando Ele editar o nome do time para "Time 1 Editado"
    Então ele deve ser redirecionado para a listagem de times
    E a listagem deve conter "Time 1 Editado"

  Cenário: Usuário deleta um time
    Dado um usuário "usuario@example.com" logado no sistema com um time chamado "Time 1"
    Quando Ele deletar o time
    Então ele deve ser redirecionado para a listagem de times
    E a listagem não deve conter "Time 1"
