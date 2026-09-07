# TicketFlow

Aplicativo mobile para gerenciamento de chamados de suporte, desenvolvido como continuidade da Atividade Avaliativa 1.

O projeto transforma o protótipo desenvolvido anteriormente em uma aplicação funcional para iOS, permitindo consultar, criar, editar e excluir chamados, além de consultar o histórico de atendimentos.

A aplicação é integrada a uma API REST desenvolvida em Flask, responsável pela comunicação com o banco de dados MySQL.

## 1. Introdução

O TicketFlow é um aplicativo mobile desenvolvido para gerenciamento de chamados de suporte.

O projeto teve como base o protótipo desenvolvido na Atividade Avaliativa 1, mantendo a proposta visual e as principais funcionalidades definidas anteriormente.

Nesta segunda etapa, o protótipo foi transformado em uma aplicação funcional para iOS, permitindo consultar, criar, editar e excluir chamados. O aplicativo também foi integrado a uma API desenvolvida em Flask, responsável pela comunicação com o banco de dados MySQL.

## 2. Objetivos

O principal objetivo do projeto foi desenvolver uma versão funcional do aplicativo TicketFlow a partir do protótipo elaborado na Atividade Avaliativa 1.

### Objetivos específicos

- Desenvolver as telas do aplicativo utilizando Swift e SwiftUI;
- Integrar o aplicativo com uma API REST;
- Utilizar um banco de dados MySQL para armazenamento dos chamados;
- Implementar as operações de criação, consulta, edição e exclusão de chamados;
- Aplicar princípios de UX e manter uma interface simples e intuitiva;
- Disponibilizar o código-fonte do projeto em um repositório no GitHub.

## 3. Tecnologias utilizadas

| Tecnologia | Utilização |
|---|---|
| **Swift** | Linguagem utilizada no desenvolvimento do aplicativo iOS |
| **SwiftUI** | Framework utilizado para construção das interfaces |
| **Xcode** | Ambiente de desenvolvimento utilizado para criação e testes do aplicativo |
| **Python** | Linguagem utilizada no desenvolvimento da API |
| **Flask** | Framework utilizado na criação da API REST |
| **MySQL** | Banco de dados utilizado para armazenamento das informações |
| **Git** | Versionamento do código-fonte |
| **GitHub** | Hospedagem e disponibilização do código-fonte |
| **Figma** | Elaboração do protótipo da Atividade Avaliativa 1 |

> **Observação:** embora o enunciado apresente Android Studio, Java e Gradle como tecnologias possíveis, o projeto foi desenvolvido para iOS utilizando Swift e SwiftUI, conforme a orientação recebida para utilização dessa plataforma.

## 4. Desenvolvimento do aplicativo

O desenvolvimento do aplicativo foi realizado a partir do protótipo elaborado na Atividade Avaliativa 1.

As telas foram implementadas utilizando Swift e SwiftUI, mantendo a estrutura visual definida anteriormente e adaptando os elementos para uma aplicação funcional.

A aplicação foi organizada em diferentes componentes, separando modelos de dados, comunicação com a API e interfaces.

### Organização do projeto

```text
TicketFlow/
├── TicketFlow/
│   ├── Models/
│   │   └── Chamado.swift
│   │
│   ├── Services/
│   │   └── APIService.swift
│   │
│   ├── Views/
│   │   ├── ChamadosView.swift
│   │   ├── ChamadoDetalhesView.swift
│   │   ├── NovoChamadoView.swift
│   │   ├── EditarChamadoView.swift
│   │   ├── HistoricoView.swift
│   │   └── ConfiguracoesView.swift
│   │
│   ├── Assets.xcassets
│   ├── ContentView.swift
│   ├── Theme.swift
│   └── TicketFlowApp.swift
│
└── API/
    ├── app.py
    └── requirements.txt
```
O modelo Chamado representa os dados recebidos do servidor, enquanto o serviço APIService é responsável pelas requisições HTTP realizadas pelo aplicativo.

As telas foram separadas conforme suas funcionalidades, incluindo listagem, cadastro, edição, detalhes, histórico e configurações.

## 5. Funcionalidades

O aplicativo possui as seguintes funcionalidades:

Abertura de chamados

Permite cadastrar um novo chamado informando:

Título;
Descrição;
Categoria;
Prioridade.

O chamado é enviado para a API e armazenado no banco de dados MySQL.

### Acompanhamento

Permite consultar os chamados ativos cadastrados no sistema.

Cada chamado apresenta:

Identificação;
Título;
Data de criação;
Status;
Prioridade.

Ao selecionar um chamado, são apresentados seus detalhes, incluindo categoria, descrição e histórico de atendimento.

### Edição

Permite alterar os dados de um chamado existente, incluindo:

Título;
Descrição;
Categoria;
Prioridade;
Status.
Exclusão

Permite remover um chamado da listagem de chamados ativos.

A exclusão é realizada de forma lógica, alterando o campo ativo no banco de dados para 0, mantendo o registro armazenado.

### Histórico

Permite consultar os chamados que foram removidos da listagem ativa por meio de exclusão lógica.

Configurações de aparência

O aplicativo possui três opções de aparência:

Automático;
Claro;
Escuro.

A preferência selecionada é armazenada no aplicativo e aplicada às telas.

## 6. Integração com API e banco de dados

A comunicação entre o aplicativo e o servidor foi realizada por meio de uma API REST desenvolvida em Flask.

O aplicativo realiza requisições HTTP para consultar e modificar os chamados, enquanto a API processa as solicitações e realiza as operações no banco de dados MySQL.

Para a comunicação com a API, foi utilizado o URLSession do Swift, com os dados transmitidos em formato JSON.

## Arquitetura

┌──────────────────────────────┐
│        Aplicativo iOS        │
│        Swift + SwiftUI       │
└──────────────┬───────────────┘
               │
               │ HTTP / JSON
               ▼
┌──────────────────────────────┐
│          API REST            │
│       Flask + Python         │
└──────────────┬───────────────┘
               │
               │ SQL
               ▼
┌──────────────────────────────┐
│            MySQL             │
│       Banco TicketFlow       │
└──────────────────────────────┘

A API funciona como intermediária entre o aplicativo mobile e o banco de dados, permitindo que o aplicativo realize as operações necessárias sem acessar diretamente o MySQL.

## 7. Endpoints da API

A API REST disponibiliza os seguintes endpoints:

| Método   | Endpoint                  | Função                |
| -------- | ------------------------- | --------------------- |
| `GET`    | `/api/chamados`           | Lista chamados ativos |
| `GET`    | `/api/chamados/<id>`      | Consulta um chamado   |
| `POST`   | `/api/chamados`           | Cria um chamado       |
| `PUT`    | `/api/chamados/<id>`      | Edita um chamado      |
| `DELETE` | `/api/chamados/<id>`      | Exclui um chamado     |
| `GET`    | `/api/chamados/historico` | Consulta o histórico  |

## 8. Experiência do usuário (UX)

A interface foi desenvolvida com base no protótipo elaborado na Atividade Avaliativa 1, buscando manter uma navegação simples e intuitiva.

Foram utilizados elementos visuais como:

Cards para apresentação dos chamados;
Botões de ação destacados;
Indicadores visuais para status e prioridade;
Organização das informações por seções;
Navegação entre as telas por meio de NavigationStack;
Mensagens de carregamento e erro;
Confirmação antes da exclusão de chamados;
Suporte aos modos claro e escuro.

As cores utilizadas nos indicadores facilitam a identificação dos estados dos chamados:

Aberto: azul;
Em andamento: laranja;
Resolvido: verde;
Alta prioridade: vermelho;
Média prioridade: laranja;
Baixa prioridade: verde.

## 9. Banco de dados

O projeto utiliza o banco de dados MySQL, com o banco ticketflow.

A tabela principal utilizada pela aplicação é chamados, responsável pelo armazenamento dos registros de atendimento.

Entre os dados armazenados estão:

ID do chamado;
Título;
Cliente;
Descrição;
Categoria;
Prioridade;
Status;
Indicador de atividade;
Data de criação.

O campo ativo é utilizado para realizar a exclusão lógica dos registros, permitindo que chamados removidos da listagem ativa permaneçam armazenados para consulta no histórico.

## 10. Versionamento

O código-fonte foi versionado utilizando Git e disponibilizado em um repositório público no GitHub.

O repositório contém tanto o aplicativo iOS quanto os arquivos necessários para a API REST utilizada na comunicação com o banco de dados.

### Estrutura geral

```
TicketFlow
│
├── Aplicativo iOS
│   └── Swift + SwiftUI
│
└── API
    ├── app.py
    └── requirements.txt
```

## 11. Conclusão

O desenvolvimento do TicketFlow permitiu transformar o protótipo elaborado na Atividade Avaliativa 1 em uma aplicação mobile funcional.

A integração entre o aplicativo iOS, a API REST em Flask e o banco de dados MySQL possibilitou a implementação das principais operações de gerenciamento de chamados.

O projeto também permitiu aplicar conceitos de desenvolvimento mobile, comunicação com servidores, organização de código e experiência do usuário.
