# CookEasy Web — CRUD de Receitas

Aplicação de receitas culinárias desenvolvida para a disciplina de Desenvolvimento para Dispositivos Web.

O sistema permite cadastrar, visualizar, editar e excluir receitas através de uma interface simples e intuitiva.

---

## Funcionalidades

- Cadastro de receitas
- Busca por nome
- Filtro por categorias
- Visualização detalhada
- Edição de receitas
- Exclusão com confirmação
- Interface responsiva

---

## CRUD — Como foi implementado

| Operação | Funcionalidade |
|----------|----------------|
| **C**reate (Criar) | Criar novas receitas |
| **R**ead (Ler) | Visualizar receitas e detalhes |
| **U**pdate (Atualizar) | Editar receitas existentes |
| **D**elete (Excluir) | Excluir receitas |

---

## Estrutura do Projeto

```text
lib/
├── main.dart
├── models/
│   └── recipe.dart
├── data/
│   └── recipes_data.dart
└── screens/
    ├── home_screen.dart
    ├── recipe_detail_screen.dart
    └── recipe_form_screen.dart
```

---

## Tecnologias Utilizadas

- Flutter
- Dart
- Material Design

---

## Conceitos Aplicados

- `StatefulWidget`
- Gerenciamento de estado com `setState()`
- Navegação entre telas
- Formulários e validação
- `ListView.builder`
- `SliverAppBar`
- `AlertDialog`
- Controllers e gerenciamento de memória

---

## Como Executar

### Requisitos

- Flutter 3.x
- Dart 3.x

### Passos

```bash
# Instalar dependências
flutter pub get

# Executar o projeto
flutter run
```

---

## Organização do Sistema

### `home_screen.dart`

Responsável pela listagem, busca e gerenciamento das receitas.

### `recipe_form_screen.dart`

Tela utilizada para criação e edição das receitas.

### `recipe_detail_screen.dart`

Exibe os detalhes completos da receita selecionada.

---

## Objetivo Acadêmico

Projeto desenvolvido com foco na prática de:

- CRUD completo
- Componentização
- Navegação entre telas
- Gerenciamento de estado
- Estruturação de aplicações Flutter

---

## Integrantes

- Gabriel Augusto Santos Alves
- Nycollas Douglas Soares dos Santos
- Ivanildo José Alves de Holanda da Silva
- Isandra Michelle Lima dos Santos
- Lislanny Silva Alves

---

## Melhorias Futuras

- Persistência com banco de dados
- Login de usuários
- Favoritos
- Upload de imagens
- Integração com API
