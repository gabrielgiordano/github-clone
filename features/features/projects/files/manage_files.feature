# language: pt

Funcionalidade: Gerenciamento de arquivos de um projeto de um usuário

  Cenário: Usuário visualiza arquivo no projeto
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um projeto chamado "Projeto_1" com o seguinte arquivo
      | nome_do_arquivo     | "Arquivo_1"                          |
      | conteudo_do_arquivo | "Conteúdo de exemplo para Arquivo_1" |
    Quando ele visualizar o arquivo chamado "Arquivo_1"
    Então ele deve ver "Conteúdo de exemplo para Arquivo_1"

  Cenário: Usuário visualiza listagem de arquivos no projeto
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um projeto chamado "Projeto_1" com os arquivos
      | "Arquivo_1" |
      | "Arquivo_2" |
    Quando ele visualizar o projeto
    Então ele deve ver uma listagem de arquivos contendo
      | "Arquivo_1" |
      | "Arquivo_2" |

  Cenário: Usuário adiciona arquivo
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um projeto chamado "Projeto_1" com os arquivos
      | "Arquivo_1" |
      | "Arquivo_2" |
    Quando ele adicionar o arquivo
      | nome_do_arquivo     | "Arquivo_3"                          |
      | conteudo_do_arquivo | "Conteúdo de exemplo para Arquivo_3" |
    Então ele deve ver uma listagem de arquivos contendo
      | "Arquivo_1" |
      | "Arquivo_2" |
      | "Arquivo_3" |

  Cenário: Usuário deleta arquivo
    Dado um usuário "usuario1@example.com" logado no sistema
    E ele possui um projeto chamado "Projeto_1" com os arquivos
      | "Arquivo_1" |
      | "Arquivo_2" |
    Quando ele deletar o arquivo "Arquivo_1"
    Então ele deve ver uma listagem de arquivos contendo
      | "Arquivo_2" |
