```mermaid
---
title: FiscalBox - Caso de uso
---

flowchart TD
    User((Usuário)) --> |Se estiver logado| HomePage(Tela principal)
    User --> |Se não estiver logado| WelcomePage(Tela de boas-vindas)
    WelcomePage --> RegisterPage(Tela de registro)
    RegisterPage --> |Inserir certificado digital| HomePage
    HomePage --> ShowContent([Visualizar CPFs e CNPJs])
    HomePage --> Register([Cadastrar novo CPF ou CNPJ])
    ShowContent --> ViewContent(Tela de gerenciamento de notas fiscais)
    Register --> |Inserir certificado digital| ViewContent
```