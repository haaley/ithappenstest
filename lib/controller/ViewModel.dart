import 'package:ithapppens/redux/actions.dart';
import 'package:ithapppens/model/model.dart';
import 'package:redux/redux.dart';


class ViewModel {
  final List<Project> projetos;
  final Function(String, DateTime dataEntrega, List<Tarefa> tarefas)
  onAddProject;
  final Function(Project) onRemoveProject;
  final Function() onRemoveProjects;
  final Function(Project) onUpdateProjects;
  final Function(List<Project> projects, String query) onSearchProjects;

  ViewModel(
      {this.projetos,
        this.onAddProject,
        this.onRemoveProject,
        this.onRemoveProjects,
        this.onUpdateProjects,
        this.onSearchProjects});

  factory ViewModel.create(Store<AppState> store) {
    __onAddProject(String titulo, DateTime dataEntrega, List<Tarefa> tarefas) {
      store.dispatch(AddProjectAction(titulo, dataEntrega, tarefas));
    }

    _onRemoveProject(Project projeto) {
      store.dispatch(RemoveProjectAction(projeto));
    }

    _onRemoveProjects() {
      store.dispatch(RemoveProjectsAction());
    }

    _onUpdateProjects(Project projeto) {
      store.dispatch(UpdateProjectAction(projeto));
    }

    _onSearchProjects(List<Project> projects, String query) {
      store.dispatch(SearchProjectsAction(projects, query));
    }

    return ViewModel(
      projetos: store.state.projetos,
      onRemoveProject: _onRemoveProject,
      onAddProject: __onAddProject,
      onRemoveProjects: _onRemoveProjects,
      onUpdateProjects: _onUpdateProjects,
      onSearchProjects: _onSearchProjects,
    );
  }
}