import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Project {
  final int id;
  final String titulo;
  final DateTime dataDaEntrega;
  final List<Tarefa> tarefas;
  String searchField;

  Project(
      {@required this.id,
      @required this.titulo,
      @required this.dataDaEntrega,
      @required this.tarefas});

  Project copyWith(
      {int id, String titulo, DateTime dataDaEntrega, List<Tarefa> tarefas}) {
    return Project(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        tarefas: tarefas ?? this.tarefas,
        dataDaEntrega: dataDaEntrega ?? dataDaEntrega);
  }

  Project.fromJson(Map json)
      : titulo = json['titulo'],
        id = json['id'],
        dataDaEntrega = DateTime.parse(json['dataDaEntrega']),
        tarefas =
            (json['tarefas'] as List).map((f) => Tarefa.fromJson(f)).toList();

  Map toJson() => {
        'id': id,
        'titulo': titulo,
        'dataDaEntrega': dataDaEntrega.toString(),
        'tarefas': tarefas
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Tarefa {
  final int id;
  final String titulo;

  Tarefa({@required this.id, @required this.titulo});

  Tarefa copyWith({int id, String titulo}) {
    return Tarefa(id: id ?? this.id, titulo: titulo ?? this.titulo);
  }

  Tarefa.fromJson(Map json)
      : id = int.tryParse(json['id']),
        titulo = json['titulo'];

  Map toJson() => {'id': id.toString(), 'titulo': titulo};

  @override
  String toString() {
    return toJson().toString();
  }
}

class AppState {
  final List<Project> projetos;

  const AppState({@required this.projetos});

  AppState.initialState() : projetos = List.unmodifiable(<Project>[]);

  AppState.fromJson(Map json)
      : projetos =
            (json['projetos'] as List).map((f) => Project.fromJson(f)).toList();

  Map toJson() => {'projetos': projetos};

  @override
  String toString() {
    return toJson().toString();
  }
}
