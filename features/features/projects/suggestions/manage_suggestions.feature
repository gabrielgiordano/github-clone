# language: pt

Funcionalidade: Gerenciamento de sugestões para um projeto

  Cenário: Usuário lista sugestões
    Dado o usuário "usuario@example.com" logado no sistema
    E um projeto público chamado "Projeto_1" com as sugestões
      | Sugestão 1 |
      | Sugestão 2 |
    Quando "usuario@example.com" visualizar as sugestões
    Então ele deve ver as seguintes sugestões na lista de sugestões
      | Sugestão 1 |
      | Sugestão 2 |

  Cenário: Usuário deleta sugestão
    Dado o usuário "usuario@example.com" logado no sistema
    E um projeto público chamado "Projeto_1" com uma sugestão chamada "Sugestão"
    Quando "usuario@example.com" deletar a sugestão "Sugestão"
    Então ele não deve ver nenhuma sugestão na lista de sugestões

  Cenário: Usuário dá sugestão para projeto
    Dado o usuário "usuario@example.com" logado no sistema
    E um projeto público chamado "Projeto_1" com os seguintes arquivos
      | nome    | conteudo |
      | Arquivo | Conteúdo |
    Quando "usuario@example.com" criar uma sugestões com os seguintes dados
      | nome     | descricao | arquivo | conteudo         |
      | Sugestão | Descrição | Arquivo | Conteúdo Editado |
    Então ele deve visualizar a sugestão contendo os seguintes dados
      | nome     | descricao | arquivo |
      | Sugestão | Descrição | Arquivo |

  Cenário: Usuário aceita sugestão
    Dado o usuário "usuario@example.com" logado no sistema
    E um projeto público chamado "Projeto_1" com os seguintes arquivos
      | nome    | conteudo |
      | Arquivo | Conteúdo |
    E "usuario@example.com" cria uma sugestões com os seguintes dados
      | nome     | descricao | arquivo | conteudo         |
      | Sugestão | Descrição | Arquivo | Conteúdo Editado |
    Quando a sugestão chamada "Sugestão" for aceita
    Então o projeto deve conter os seguintes arquivos
      | nome    | conteudo         |
      | Arquivo | Conteúdo Editado |
