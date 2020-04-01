import 'dart:async';
import 'dart:convert';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ithapppens/model/model.dart';
import 'package:ithapppens/redux/actions.dart';

List<Middleware<AppState>> appStateMiddleware(
    [AppState state = const AppState(projetos: [])
    ]){
      final loadItems = _loadFromPrefs(state);
      final saveItems = _saveToPrefs(state);

      return[
        TypedMiddleware<AppState, AddProjectAction>(saveItems),
        TypedMiddleware<AppState, RemoveProjectsAction>(saveItems),
        TypedMiddleware<AppState, RemoveProjectAction>(saveItems),
        TypedMiddleware<AppState, GetProjectsAction>(loadItems),
        TypedMiddleware<AppState, SearchProjectsAction>(saveItems),
        TypedMiddleware<AppState, UpdateProjectAction>(saveItems),

      ];
}

Middleware<AppState> _loadFromPrefs(AppState state){
  return (Store<AppState> store, action, NextDispatcher next){
    next(action);
    loadFromPrefs()
        .then((state) => store.dispatch(LoadedProjectsAction(state.projetos)));
  };
}

Middleware<AppState> _saveToPrefs(AppState state){
  return (Store<AppState> store, action, NextDispatcher next){
    next(action);
   saveToPrefs(store.state);
  };
}

void saveToPrefs(AppState state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var string = json.encode(state.toJson());
  print(state.toString());
  print("salvando "+ string);
  await preferences.setString('projectsState', string);
}

Future<AppState> loadFromPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var string = preferences.getString('projectsState');
  if (string != null) {
    Map map = jsonDecode(string);
    print("lendo " + map.toString());
    print(map);
    return AppState.fromJson(map);
  } else {
    return AppState.initialState();
  }
}