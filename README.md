# Microserviço de Autenticação (User Authentication)

- **Nome**: `AuthService`
- **Descrição**: Gerencia a autenticação dos usuários e emite tokens JWT para controle de acesso.
- **Repositório Git**: `auth_service`


## Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas no seu ambiente antes de iniciar:
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- Acesso ao repositório no GitHub

---

## Configuração Inicial

### 1. Clone o Repositório com Submódulos

Use o comando abaixo para clonar o repositório principal juntamente com todos os submódulos de uma só vez:

```shell
git clone git@github.com:joathan/auth_service.git
```

---

### 2. Inicie os Serviços Compartilhados

Os serviços compartilhados são necessários para o funcionamento desse e dos demais projetos. Execute o comando abaixo para inicializá-los:

```shell
docker compose -f docker-compose.shared.yml up -d
```

Este comando irá subir os containers necessários em segundo plano.

---

## Configuração de um Serviço Específico

Para executar um serviço específico, siga os passos abaixo:

### 1. Acesse a Pasta do Serviço

Entre na pasta do serviço que deseja subir. Substitua `<nome_do_service>` pelo nome do serviço correspondente:

```shell
cd <nome_do_service>
```

### 2. Configure o Arquivo de Ambiente

Copie o arquivo de exemplo `.env-example` para `.env`:

```shell
cp .env-example .env
```

---

### 3. Suba os Containers do Serviço

Com o arquivo `.env` configurado, inicie os containers do serviço:

```shell
docker compose up -d
```


# API Authentication Endpoints

A API de autenticação fornece os seguintes endpoints para registro, login e verificação de tokens de usuários.

---

## **Endpoints**

### 1. `POST /api/v1/register`

**Descrição**: Registra um novo usuário na aplicação.

**Exemplo de requisição**:

```json
POST /api/v1/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Respostas**:
- **201**: Usuário criado com sucesso.

  Exemplo de resposta:
  ```json
  {
    "message": "User created successfully"
  }
  ```

- **422**: Parâmetros inválidos.

  Exemplo de resposta:
  ```json
  {
    "error": "Invalid parameters"
  }
  ```

---

### 2. `POST /api/v1/login`

**Descrição**: Realiza o login de um usuário existente e retorna um token JWT.

**Exemplo de requisição**:

```json
POST /api/v1/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Respostas**:
- **200**: Login realizado com sucesso.

  Exemplo de resposta:
  ```json
  {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
  ```

- **401**: Credenciais inválidas.

  Exemplo de resposta:
  ```json
  {
    "error": "Invalid credentials"
  }
  ```

---

### 3. `GET /api/v1/verify_token`

**Descrição**: Verifica a validade de um token JWT e retorna os dados do usuário associado.

**Headers**:
- `Authorization`: Token JWT no formato `Bearer <token>`.

**Exemplo de requisição**:

```json
GET /api/v1/verify_token
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Respostas**:
- **200**: Token válido.

  Exemplo de resposta:
  ```json
  {
    "user_id": 1
  }
  ```

- **401**: Token inválido ou expirado.

  Exemplo de resposta:
  ```json
  {
    "error": "Invalid or expired token"
  }
  ```

- **401**: Token expirado.

  Exemplo de resposta:
  ```json
  {
    "error": "Invalid or expired token"
  }
  ```

- **401**: Usuário não encontrado.

  Exemplo de resposta:
  ```json
  {
    "error": "User not found"
  }
  ```

---

## **Testes**

Os testes para os endpoints estão localizados no arquivo `spec/requests/api/v1/auth_spec.rb`. Eles cobrem cenários para:
1. Registro de novos usuários.
2. Login de usuários existentes.
3. Verificação de tokens JWT.

Os testes utilizam a gem `rswag` para gerar documentação Swagger. Para visualizar a documentação gerada, acesse `/api-docs` (http://localhost:3100/api-docs) enquanto o servidor estiver em execução.

---

## **Observações**

- O token JWT deve ser enviado no cabeçalho `Authorization` para endpoints protegidos.
- Utilize a gem `Faker` para gerar dados fictícios nos testes automatizados.
- As respostas seguem o padrão JSON e devem ser tratadas adequadamente no frontend.
