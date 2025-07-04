```mermaid
---
title: FiscalBox - Diagrama de classe
---
classDiagram
    class User {
        - id: String
        - nome: String
        - email: String
        - senha: String
        - cpfOuCnpj: String
        - certificado: File
        + autenticar(): bool
    }

    class NotaFiscal {
        - id: String
        - usuarioId: String
        - cnpjEmitente: String
        - numero: String
        - chaveAcesso: String
        - valorTotal: double
        - dataEmissao: DateTime
        + exportarXml(): File
    }

    class AutenticacaoSupabase {
        + login(email, senha): Future<bool>
        + logout(): void
        + deletarConta(): Future<void>
        + cadastrar(email, senha): Future<bool>
    }

    class StorageService {
        + salvarNotaLocal(nota: NotaFiscal): void
        + carregarNotas(): List<NotaFiscal>
        + deletarNota(id: String): void
    }

    User --> AutenticacaoSupabase
    AutenticacaoSupabase --> StorageService
    StorageService --> NotaFiscal
```

O diagrama de classes do aplicativo FiscalBox representa uma arquitetura, onde o usuário (User) é autenticado via Supabase (AutenticacaoSupabase) e possui um certificado digital para consultas fiscais. As notas fiscais (NotaFiscal) são vinculadas ao usuário e podem ser exportadas em formato XML. O armazenamento local das notas é gerenciado pela classe StorageService, que oferece métodos para salvar, carregar e deletar registros. As classes se conectam de forma hierárquica, refletindo a separação de responsabilidades e facilitando a manutenção e escalabilidade do sistema.