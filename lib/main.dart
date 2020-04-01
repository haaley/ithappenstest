import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:ithapppens/redux/actions.dart';
import 'package:ithapppens/redux/reducer.dart';
import 'package:ithapppens/model/model.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ithapppens/redux/middleware.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:ithapppens/common/styles.dart';

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
          '/new': (context) => AddProject(_ViewModel()),
          '/edit': (context) => EditProjectWidget(),
        },
      ),
    );
  }
}

class _ViewModel {
  final List<Project> projetos;
  final Function(String, DateTime dataEntrega, List<Tarefa> tarefas)
      onAddProject;
  final Function(Project) onRemoveProject;
  final Function() onRemoveProjects;
  final Function(Project) onUpdateProjects;
  final Function(List<Project> projects, String query) onSearchProjects;

  _ViewModel(
      {this.projetos,
      this.onAddProject,
      this.onRemoveProject,
      this.onRemoveProjects,
      this.onUpdateProjects,
      this.onSearchProjects});

  factory _ViewModel.create(Store<AppState> store) {
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

    return _ViewModel(
      projetos: store.state.projetos,
      onRemoveProject: _onRemoveProject,
      onAddProject: __onAddProject,
      onRemoveProjects: _onRemoveProjects,
      onUpdateProjects: _onUpdateProjects,
      onSearchProjects: _onSearchProjects,
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
      body: StoreConnector<AppState, _ViewModel>(
          converter: (Store<AppState> store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
                body: Column(
                  children: <Widget>[
                    // AddItemWidget(viewModel),
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

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;

  RemoveItemsButton(this.model);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Deletar Todos'),
      onPressed: () => model.onRemoveProjects(),
    );
  }
}

class ProjectListWidget extends StatefulWidget {
  ProjectListWidget(this.model, {Key key}) : super(key: key);
  final _ViewModel model;

  @override
  _ProjectListWidgetState createState() => _ProjectListWidgetState();
}

class _ProjectListWidgetState extends State<ProjectListWidget> {
  final TextEditingController controller = TextEditingController();
  List<Project> searchList;
  List<Project> filteredList = [];

  @override
  void initState() {
    super.initState();
    searchList = widget.model.projetos;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: new BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: new BorderRadius.all(Radius.circular(50))),
            child: TextField(
              onChanged: (text) {
                print(text);
                if (text.length >= 2) {
                  widget.model.projetos.forEach((p) => {
                        if (p.tarefas.indexWhere((t) => t.titulo
                                    .toLowerCase()
                                    .contains(text.toLowerCase())) >=
                                0 ||
                            p.titulo.toLowerCase().contains(text.toLowerCase()))
                          {
                            print(p.titulo),
                            if (!filteredList.contains(p)) {filteredList.add(p)}
                          }
                        else
                          {(filteredList.remove(p))}
                      });
                  setState(() {
                    searchList = filteredList;
                  });
                } else {
                  setState(() {
                    searchList = widget.model.projetos;
                  });
                }
              },
              controller: controller,
              decoration: InputDecoration(
                  hintText: "Buscar",
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(Icons.search), // myIcon is a 48px-wide widget.
                  )),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: searchList.length,
                itemBuilder: (BuildContext context, int index) {
                  final projeto = searchList[index];
                  return Card(
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ProjetoCard(
                          widget.model,
                          projeto,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProjectWidget(
                                                projeto: projeto,
                                                model: widget.model,
                                                key: UniqueKey(),
                                              )));
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    Project project = widget.model.projetos
                                        .firstWhere(
                                            (t) => t.titulo == projeto.titulo);
                                    widget.model.onRemoveProject(project);
                                    this.searchList = widget.model.projetos;
                                  });
                                  // Show a snackbar. This snackbar could also contain "Undo" actions.
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "${projeto.titulo} foi apagado")));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class EditProjectWidget extends StatefulWidget {
  final Project projeto;
  final _ViewModel model;

  EditProjectWidget({this.projeto, this.model, Key key}) : super(key: key);

  @override
  _EditProjectWidgetState createState() => _EditProjectWidgetState();
}

class _EditProjectWidgetState extends State<EditProjectWidget> {
  TextEditingController _titleController;
  TextEditingController _dateController;
  TextEditingController _taskController;
  final format = DateFormat('dd/MM/yyyy');
  final _formKey = GlobalKey<FormState>();
  DateTime _date;

  List<Tarefa> taskList;

  @override
  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: widget.projeto.titulo);
    _dateController = new TextEditingController(
        text: format.format(widget.projeto.dataDaEntrega));
    taskList = widget.projeto.tarefas;
    _taskController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  var projeto = Project(
                      titulo: _titleController.text,
                      dataDaEntrega: _date,
                      id: widget.projeto.id,
                      tarefas: taskList);
                  print(projeto);
                  widget.model.onUpdateProjects(projeto);
                  Navigator.pushNamed(context, '/');
                }
              },
            )
          ],
          title: Text("Editar projeto " + widget.projeto.titulo),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      width: MediaQuery.of(context).size.width - 12,
                      margin: EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty || value.length < 1) {
                                  return 'Informe o titulo';
                                }
                                return null;
                              },
                              maxLength: 50,
                              maxLengthEnforced: true,
                              textCapitalization: TextCapitalization.sentences,
                              controller: _titleController,
                              onSaved: (value) {},
                              decoration: CommonStyle.textFieldStyle(
                                  labelTextStr: "Titulo",
                                  hintTextStr: "Titutlo"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: DateTimeField(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Informe a data';
                                  }
                                  return null;
                                },
                                controller: _dateController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide:
                                          BorderSide(color: Colors.green)),
                                  hintText: "Data de Entrega",
                                  contentPadding: EdgeInsets.all(15.0),
                                ),
                                format: format,
                                onShowPicker: (context, _dateController) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          _dateController ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                                onSaved: (value) => {_date = value}),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 12, top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Tarefas",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  decoration: CommonStyle.textFieldStyle(
                                      hintTextStr: "Tarefa",
                                      labelTextStr: "Tarefa"),
                                  controller: _taskController,
                                ),
                              ),
                              Builder(
                                builder: (context) => RawMaterialButton(
                                  onPressed: () {
                                    _formKey.currentState.save();
                                    Tarefa task = new Tarefa(
                                        titulo: _taskController.text,
                                        id: DateTime.now().millisecondsSinceEpoch);
                                    if (taskList.indexWhere(
                                            (t) => t.titulo == task.titulo) <
                                        0) {
                                      if (_taskController.text.length > 2) {
                                        setState(() {
                                          taskList.add(task);
                                          print(task);
                                          print(taskList);
                                          _taskController.text = '';
                                        });
                                      } else {
                                        final snackBar = SnackBar(
                                          content: Text('Tarefa curta demais'),
                                          action: SnackBarAction(
                                            label: 'Ok',
                                            onPressed: () {
                                              // Some code to undo the change.
                                            },
                                          ),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text('Tarefa já adicionada'),
                                        action: SnackBarAction(
                                          label: 'Ok',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  splashColor: Colors.green,
                                  child: new Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 35.0,
                                  ),
                                  shape: new CircleBorder(),
                                  elevation: 2.0,
                                  fillColor: Colors.green,
                                  padding: const EdgeInsets.all(10.0),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                itemCount: taskList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final tarefa = taskList[index];
                                  TextEditingController _taskController;
                                  bool enable = true;
                                  return Container(
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            enabled: enable,
                                            controller: _taskController,
                                            decoration: InputDecoration(
                                                hintText: "${tarefa.titulo}",
                                                hintStyle: TextStyle(
                                                    color: Colors.black)),
                                            onChanged: (value) {
                                              print(value);
                                              _formKey.currentState.save();
                                              setState(() {
                                                print("antes");
                                                print(taskList);
                                                taskList =  taskList.map((t) => t.id == tarefa.id ? t.copyWith(titulo: value) : t).toList();
                                                print("depois");
                                                print(taskList);
                                                enable = !enable;
                                              });
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              var index = taskList.indexWhere(
                                                  (t) =>
                                                      t.titulo ==
                                                      tarefa.titulo);

                                              print("o index é" +
                                                  index.toString());

                                              taskList.removeAt(index);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}

class ProjectView extends StatelessWidget {
  final Project model;

  ProjectView(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tarefas do Projeto: " + model.titulo),
        ),
        body: Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 12,
                    margin: EdgeInsets.all(0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(18),
                          child: Text(
                            model.titulo,
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Divider(
                          indent: 20,
                          endIndent: 20,
                          color: Colors.red,
                          height: 2,
                          thickness: 2,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Data da Entrega: ",
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                new DateFormat('dd/MM/yyyy')
                                    .format(model.dataDaEntrega)
                                    .toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                                top: BorderSide(color: Colors.red, width: 2))
                            // borderRadius: BorderRadius.circular(12),
                            ),
                        padding: EdgeInsets.only(bottom: 12, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Tarefas",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: model.tarefas.length,
                            itemBuilder: (BuildContext context, int index) {
                              final tarefa = model.tarefas[index];
                              return Container(
                                  decoration: new BoxDecoration(
                                      color: Color.fromRGBO(149, 213, 230, 1),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(10.0))),
                                  height: 50,
                                  margin: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 30),
                                        child: Text(
                                          tarefa.titulo,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ));
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class ProjetoCard extends StatelessWidget {
  final _ViewModel store;
  final Project model;

  ProjetoCard(
    this.store,
    this.model,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 90,
          padding: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 20),
                child: Text(
                  model.titulo,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Data da Entrega: ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(DateFormat('dd/MM/yyyy')
                      .format(model.dataDaEntrega)
                      .toString()),
                  // Text(model.dataDaEntrega.toIso8601String()),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: DateTimeField(
            validator: (value) {
              if (value == null) {
                return 'Informe a data';
              }
              return null;
            },
            decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.red)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.blue)),
                hintText: "Data da Entrega",
                contentPadding: EdgeInsets.all(15.0),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200]),
            format: format,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
            onSaved: (value) => {date = value}),
      ),
    ]);
  }
}

class AddProject extends StatelessWidget {
  final _ViewModel model;

  AddProject(this.model);

  @override
  Widget build(BuildContext context) {
    return ProjectForm(model);
  }
}

class ProjectForm extends StatefulWidget {
  final _ViewModel model;

  ProjectForm(this.model);

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  List<Tarefa> lista = [];
  String title;
  String tarefa;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print("Lista adicionado nova quantidade é: " + lista.length.toString());
  }

  void addItemToList(Tarefa tarefa) {
    setState(() {
      lista.add(tarefa);
    });
  }

  void removeItemFromList(Tarefa tarefa) {
    setState(() {
      lista.remove(tarefa);
    });
  }

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    if (widget.model.projetos
                            .indexWhere((p) => p.titulo == title) <
                        0) {
                      widget.model.onAddProject(title, date, lista);
                      Navigator.pushNamed(context, '/');
                    } else {
                      final snackBar = SnackBar(
                        content: Text('Já existe um projeto com este nome'),
                        action: SnackBarAction(
                          label: 'Ok',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  }
                }),
          )
        ],
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      width: halfMediaWidth,
                      child: ProjectFormFields(
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Informe um titulo';
                          }
                          return null;
                        },
                        hintText: "Nome do Projeto",
                        onSaved: (String value) {
                          title = value;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      width: halfMediaWidth,
                      child: BasicDateField(),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: halfMediaWidth + halfMediaWidth / 2,
                      child: ProjectFormFields(
                        hintText: "Tarefa",
                        onSaved: (String value) {
                          tarefa = value;
                        },
                      ),
                    ),
                    Builder(
                      builder: (context) => RawMaterialButton(
                        onPressed: () {
                          _formKey.currentState.save();
                          Tarefa task = new Tarefa(titulo: tarefa);
                          if (lista.indexWhere((t) => t.titulo == task.titulo) <
                              0) {
                            if (tarefa.length > 2) {
                              setState(() {
                                addItemToList(task);
                              });
                            } else {
                              final snackBar = SnackBar(
                                content: Text('Tarefa curta demais'),
                                action: SnackBarAction(
                                  label: 'Ok',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          } else {
                            final snackBar = SnackBar(
                              content: Text('Tarefa já adicionada'),
                              action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        },
                        splashColor: Colors.green,
                        child: new Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        shape: new CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.green,
                        padding: const EdgeInsets.all(10.0),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: lista.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              decoration: new BoxDecoration(
                                  color: Color.fromRGBO(149, 213, 230, 1),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(10.0))),
                              height: 50,
                              margin: EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text(
                                      lista[index].titulo,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            removeItemFromList(lista[index]),
                                      ),
                                    ],
                                  )
                                ],
                              ));
                        }))
              ],
            ),
          )),
    );
  }
}

class ProjectFormFields extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Function onSaved;
  final Function validator;

  ProjectFormFields(
      {this.hintText, this.onSaved, this.validator, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: CommonStyle.textFieldStyle(
            hintTextStr: hintText, labelTextStr: labelText),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
