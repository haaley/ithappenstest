import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ithapppens/ui/editProjects.dart';
import 'package:ithapppens/redux/actions.dart';
import 'package:ithapppens/redux/reducer.dart';
import 'package:ithapppens/model/model.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ithapppens/redux/middleware.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:ithapppens/ui/listProject.dart';
import 'package:ithapppens/controller/ViewModel.dart';
import 'package:ithapppens/ui/newProject.dart';
import 'package:ithapppens/common/removeProject.dart';

DateTime date;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware(),
    );
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'ItHappens Projects',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(GetProjectsAction()),
          builder: (BuildContext context, Store<AppState> store) =>
              MyHomePage(store),
        ),
        routes: {
          '/new': (context) => AddProject(ViewModel()),
          '/edit': (context) => EditProjectWidget(),
        },
      ),
    );
  }
}
class MyHomePage extends StatelessWidget {
  final DevToolsStore<AppState> store;

  MyHomePage(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('itHappens'),
      ),
      body: StoreConnector<AppState, ViewModel>(
          converter: (Store<AppState> store) => ViewModel.create(store),
          builder: (BuildContext context, ViewModel viewModel) => Scaffold(
                body: Column(
                  children: <Widget>[
                    ProjectListWidget(viewModel, key: UniqueKey()),
                    RemoveItemsButton(viewModel),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProject(viewModel)));
                  },
                ),
              )),
      drawer: Container(
        child: ReduxDevTools(store),
      ),
    );
  }
}