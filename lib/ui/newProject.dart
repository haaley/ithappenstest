import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:ithapppens/model/model.dart';
import 'package:intl/intl.dart';
import 'package:ithapppens/common/styles.dart';
import 'package:ithapppens/controller/ViewModel.dart';
import 'package:ithapppens/common/formFields.dart';

class AddProject extends StatelessWidget {
  final ViewModel model;

  AddProject(this.model);

  @override
  Widget build(BuildContext context) {
    return ProjectForm(model);
  }
}

class ProjectForm extends StatefulWidget {
  final ViewModel model;

  ProjectForm(this.model);

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  List<Tarefa> lista = [];
  String title;
  String tarefa;
  DateTime date;
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
                      child: ProjectDateField(
                        initialDate: DateTime.now(),
                        format: DateFormat('dd/MM/yyyy'),
                        onSaved: (value) {
                          date = value;
                        },
                      ),
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
                          Tarefa task = new Tarefa(titulo: tarefa, id: DateTime.now().millisecondsSinceEpoch);
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
