import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:ithapppens/model/model.dart';
import 'package:intl/intl.dart';
import 'package:ithapppens/common/styles.dart';
import 'package:ithapppens/controller/ViewModel.dart';
import 'package:ithapppens/common/formFields.dart';

class EditProjectWidget extends StatefulWidget {
  final Project projeto;
  final ViewModel model;

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
  DateTime date;

  List<Tarefa> taskList;

  @override
  void initState() {
    super.initState();
    _titleController = new TextEditingController(text: widget.projeto.titulo);
    _dateController = new TextEditingController(text: format.format(widget.projeto.dataDaEntrega));
    taskList = widget.projeto.tarefas;
    _taskController = new TextEditingController();
    date = widget.projeto.dataDaEntrega;
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
                      dataDaEntrega: date,
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
                            child: ProjectDateField(
                              controller: _dateController,
                              initialDate: date ?? DateTime.now(),
                              format: DateFormat('dd/MM/yyyy'),
                              onSaved: (value) {
                                date = value;
                              },
                            ),
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
