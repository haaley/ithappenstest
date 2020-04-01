import 'package:ithapppens/model/model.dart';

class AddProjectAction {
  static int _id = 0;
  final String titulo;
  final DateTime dataEntrega;
  final List<Tarefa> tarefas;

  AddProjectAction(this.titulo, this.dataEntrega, this.tarefas){
    _id ++;
  }
  int get id => _id;
}

class RemoveProjectAction{
  final Project projeto;
  RemoveProjectAction(this.projeto);
}

class RemoveProjectsAction {}

class SearchProjectsAction {
  final List<Project> projects;
  final String query;
  SearchProjectsAction(this.projects, this.query);
}


class GetProjectsAction {

}

class LoadedProjectsAction {
  final List<Project> projects;
  LoadedProjectsAction(this.projects);
}

class UpdateProjectAction{
  final Project project;
  UpdateProjectAction(this.project);
}

