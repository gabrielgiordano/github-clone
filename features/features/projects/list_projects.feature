# language: pt

Funcionalidade: Exibir projetos de um usuário
  Descreve as regras básicas de visualização de projetos dentro do sistema
  Basicamente, um usuário não pode ver os projetos privados de outros usuários

  Cenário: Usuário pode visualizar projetos públicos
    Dado o usuário
      | usuario@example.com |
    E os projetos públicos
      | Projeto_1 |
      | Projeto_2 |
    Quando ele visualiza todos os projetos
    Então ele deve ver os seguintes projetos
      | Projeto_1 |
      | Projeto_2 |

  Cenário: Usuários podem visualizar seus projetos privados
    Dado os usuários
      | usuario1@example.com |
      | usuario2@example.com |
    E os projetos
      | autor                | nome      | visibilidade |
      | usuario1@example.com | Projeto_1 | Privado      |
      | usuario2@example.com | Projeto_2 | Público      |
    Quando usuario1@example.com visualizar todos os projetos
    Então ele deve ver os seguintes projetos
      | Projeto_1 |
      | Projeto_2 |

  Cenário: Usuários não podem visualizar projetos privados de outros usuários
    Dado os usuários
      | usuario1@example.com |
      | usuario2@example.com |
    E os projetos
      | autor                | nome      | visibilidade |
      | usuario1@example.com | Projeto_1 | Privado      |
      | usuario2@example.com | Projeto_2 | Público      |
    Quando usuario2@example.com visualizar todos os projetos
    Então ele deve ver os seguintes projetos
      | Projeto_2 |

  Cenário: Usuários visualizando seus projetos
    Dado os usuários
      | usuario1@example.com |
      | usuario2@example.com |
    E os projetos
      | autor                | nome      | visibilidade |
      | usuario1@example.com | Projeto_1 | Privado      |
      | usuario1@example.com | Projeto_2 | Público      |
      | usuario2@example.com | Projeto_3 | Público      |
    Quando usuario1@example.com visualizar seus projetos
    Então ele deve ver os seguintes projetos
      | Projeto_1 |
      | Projeto_2 |
