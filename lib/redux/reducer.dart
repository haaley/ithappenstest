import 'package:ithapppens/model/model.dart';
import 'package:ithapppens/redux/actions.dart';
import 'package:redux/redux.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    projetos: projectReducer(state.projetos, action),
  );
}

Reducer<List<Project>> projectReducer = combineReducers<List<Project>>([
  TypedReducer<List<Project>, AddProjectAction>(addProjectReducer),
  TypedReducer<List<Project>, RemoveProjectAction>(removeProjectReducer),
  TypedReducer<List<Project>, RemoveProjectsAction>(removeProjectsReducer),
  TypedReducer<List<Project>, LoadedProjectsAction>(loadProjectsReducer),
  TypedReducer<List<Project>, UpdateProjectAction>(updateProjectReducer),
  TypedReducer<List<Project>, SearchProjectsAction>(searchProjectsReducer),
]);

List<Project> addProjectReducer(
    List<Project> projects, AddProjectAction action) {
  return []
    ..addAll(projects)
    ..add(Project(
        id: action.id,
        dataDaEntrega: action.dataEntrega,
        titulo: action.titulo,
        tarefas: action.tarefas));
}

List<Project> removeProjectReducer(
    List<Project> projects, RemoveProjectAction action) {
  return List.unmodifiable(List.from(projects)..remove(action.projeto));
}

List<Project> loadProjectsReducer(
    List<Project> projects, LoadedProjectsAction action) {
  action.projects.sort((a, b) => a.dataDaEntrega.compareTo(b.dataDaEntrega));
  return action.projects;
}

List<Project> removeProjectsReducer(
    List<Project> projects, RemoveProjectsAction action) {
  return [];
}

List<Project> searchProjectsReducer(
    List<Project> projects, SearchProjectsAction action) {
  return action.projects.where((p) => p.titulo.contains(action.query)).toList();
}

List<Project> updateProjectReducer(
    List<Project> projects, UpdateProjectAction action) {
  print("novo projeto é: ");
  print(action.project);
  var index = projects.indexWhere((p) => p.id == action.project.id);

  print("o index do objeto é:" + index.toString());

  var date = DateTime.now();

  print("data a salver" + date.toString());
  return projects
      .map((p) => p.id == action.project.id
          ? p.copyWith(
              titulo: action.project.titulo,
              id: action.project.id,
              dataDaEntrega: action.project.dataDaEntrega,
              tarefas: action.project.tarefas)
          : p)
      .toList();
}

//  if(action is RemoveProjectAction){
//    return List.unmodifiable(List.from(state)..remove(action.projeto));
//  }
//
//  if(action is RemoveProjectsAction){
//    return List.unmodifiable([]);
//  }
//
//  if(action is LoadedProjectsAction){
//    return action.projects;
//  }
//
//  return state;
//}
