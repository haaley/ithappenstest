# ithapppens

ItHappens test of admission.

## Requisitos:

Gerenciar informações do projeto:
Criar, listar, editar, atualizar e excluir
O projeto deve ter obrigatoriamente id, título e data da previsão de entrega
O projeto deve ter um coleção de tarefas associadas a ele
Não deve ser possível criar projetos com o mesmo título de um projeto já existente
Devem aparecer no topo da listagem, os projetos mais próximos de serem entregues

## Gerenciar informações de tarefas do projeto:
Criar, listar, editar, atualizar e excluir
A tarefa deve ter obrigatoriamente um id e um título.
Não deve ser possível criar uma tarefa com o mesmo título de outra tarefa já existente no
mesmo projeto

## Buscar tarefas por título
Deve ser possível buscar entre todas as tarefas cadastradas. Independente de projeto
Deve mostrar as tarefas que contenham o texto digitado no seu título
Deve buscar somente quando digitar mais de 2 caracteres

## Getting Started

Este projeto foi implementado em flutter, utilizando redux para gerenciamento de estados
e shared preferecnces para persistencia dos dados.

## Executando o app

Para executar o app, é necessário ter um ambiente de Flutter devidamente configurado.
Para mais informações acesse https://flutter.dev/docs/get-started/

Com um ambiente devidamente configurado,
importe o projeto para a sua IDE (no desenvolvimento foi utilizado o Android Studio)

em um terminal execute o comando
flutter pub get

para baixar as dependencias utilizadas no projeto.

Ao final do processo, exute o commando
flutter run

para executar a aplicação.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
