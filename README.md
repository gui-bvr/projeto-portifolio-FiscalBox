<p align="center">
    <img src="https://github.com/gui-bvr/projeto-portifolio-FiscalBox/blob/main/assets/icons/FiscalBox-icon-rounded.png?raw=true" alt="logo-top" height="150">
</p>
<h1 align="center">FiscalBox</h1>
<p align="center">Seu controle de notas fiscais.<p>

<br>

## Descrição

Este projeto faz parte do meu portfólio para o curso de Engenharia de Software. O sistema foi criado para atender a uma demanda de usuários que enfrentam dificuldades na visualização, e gerenciamento, de notas fiscais em geral.

<br>

## Objetivo

O aplicativo tem como objetivo oferecer uma solução eficiente para organizar, monitorar e facilitar o acesso a notas fiscais, garantindo mais controle sobre elas. Com uma interface intuitiva e recursos voltados à praticidade.

A aplicação foi desenvolvida com uma arquitetura escalável, permitindo posteriormente sua adaptação para desktops com MacOS, Windows e Linux. No entanto, a prioridade foi garantir praticidade para dispositivos móveis, considerando a necessidade dos usuários de acessar as informações de forma rápida e pratica.

<br>

### Requisitos Funcionais:

**RF01:** A aplicação deve permitir o cadastro de usuários.

**RF02:** A aplicação deve permitir o login de usuários cadastrados com autenticação.

**RF03:** A aplicação deve permitir que o usuário delete sua conta.

**RF04:** A aplicação deve permitir que o usuário encerre sua sessão.

**RF05:** A aplicação deve fazer um backup local antes do envio para a nuvem (caso o usuario deseje).

**RF06:** A aplicação deve exportar as notas fiscais para o formato que permita utilização em outros sistemas como ERPs e sistemas de contabilidades (por exemplo).

</br>

### Requisitos Não Funcionais:

**RNF01:** A aplicação deve garantir a segurança dos dados do usuário.

**RNF02:** A aplicação deve ter um bom desempenho na coleta e leitura de dados das notas fiscais.

**RNF03:** A aplicação deve ter uma interface intuitiva e fácil de utilizar.

**RNF04:** A aplicação deve ser modular e bem arquitetada, permitindo atualizações futuras e fácil manutenção.

**RNF05:** A aplicação deve apresentar testes unitários.

**RNF06:** A aplicação deve aumentar o suporte para outros tipos de documentos fiscais, emitidos dentro do território 
Brasileiro, ou por alguma instituição autorizada pelos mesmos, em breve.

<br>

## Instruções de Uso

### Configuração do Supabase

```env
create table public.pastas (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  tipo text,
  numero text,
  created_at timestamp with time zone default now()
);
```

```env
-- Ativar RLS na tabela
ALTER TABLE pastas ENABLE ROW LEVEL SECURITY;

-- Política de SELECT
CREATE POLICY "Usuario pode ver suas pastas"
ON pastas
FOR SELECT
USING (user_id = auth.uid());

-- Política de INSERT
CREATE POLICY "Usuario pode inserir suas pastas"
ON pastas
FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Política de UPDATE
CREATE POLICY "Usuario pode atualizar suas pastas"
ON pastas
FOR UPDATE
USING (user_id = auth.uid());

-- Política de DELETE
CREATE POLICY "Usuario pode deletar suas pastas"
ON pastas
FOR DELETE
USING (user_id = auth.uid());
```

### Aplicação Flutter

Para compilar e executar o aplicativo, você precisa ter o [Flutter](https://flutter.dev/) instalado no dispositivo que irá executa-lo, e um emulador, ou dispositivo físico (Android ou IOS) disponível.
Alem de uma conta, e um projeto criado, e configurado, no [Supabase](https://supabase.com/).

Após isso, siga os seguintes passos:

1 - Crie um arquivo `.env` na pasta raíz/root do projeto Flutter com os seguintes dados:

```env
SUPABASE_URL="SUA URL"
SUPABASE_ANON_KEY="SUA CHAVE"
```

2 - Instale as dependências do projeto principal com o comando abaixo:

```bash
flutter pub get
```

3 - Execute o aplicativo com o comando abaixo:

```bash
flutter run
```

<br>

---
_FiscalBox foi criado por Guilherme Banzati Viana Ribeiro, para o projeto de portifólio de finalização do curso de Engenharia de Software, do Centro Universitario Católica de Santa Catarina._