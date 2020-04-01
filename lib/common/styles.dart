import 'package:flutter/material.dart';
import 'package:ithapppens/model/model.dart';



class TaskListComponent extends StatefulWidget {
  final List<Tarefa> taskList;
  final TextEditingController taskController;
  TaskListComponent({this.taskController, this.taskList, Key key}) : super(key: key);

  @override
  _TaskListComponentState createState() => _TaskListComponentState();
}

class _TaskListComponentState extends State<TaskListComponent> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Flexible(
        child: Container(
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
                      decoration:
                          CommonStyle.textFieldStyle(hintTextStr: "Tarefa", labelTextStr: "Tarefa"),
                      controller: widget.taskController,
                    ),
                  ),
                  Builder(
                    builder: (context) => RawMaterialButton(
                      onPressed: () {
                        formKey.currentState.save();
                        Tarefa task = new Tarefa(titulo: widget.taskController.text);
                        if (widget.taskList
                                .indexWhere((t) => t.titulo == task.titulo) <
                            0) {
                          if (widget.taskController.text.length > 2) {
                            setState(() {
                              widget.taskList.add(task);
                             widget.taskController.text = '';
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
                    itemCount: widget.taskList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tarefa = widget.taskList[index];
                      TextEditingController _taskController;
                      bool enable = true;
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                key: UniqueKey(),
                                enabled: enable,
                                controller: _taskController,
                                decoration: InputDecoration(
                                    hintText: "${tarefa.titulo}",
                                    hintStyle: TextStyle(color: Colors.black)),
                                onSubmitted: (value) {
                                  setState(() {
                                    print(tarefa.titulo);
                                    print("setou");

                                    var index = widget.taskList.indexWhere(
                                        (t) => t.titulo == tarefa.titulo);

                                    print("o index é" + index.toString());

                                    widget.taskList.removeAt(index);

                                    widget.taskList
                                        .add(new Tarefa(titulo: value));

                                    widget.taskList
                                        .map((f) => f.titulo == tarefa.titulo
                                            ? f.copyWith(titulo: value)
                                            : f)
                                        .toList();
                                    print("depois");
                                    print(widget.taskList);
                                    enable = !enable;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  var index = widget.taskList.indexWhere(
                                      (t) => t.titulo == tarefa.titulo);

                                  print("o index é" + index.toString());

                                  widget.taskList.removeAt(index);
                                });
                              },
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonStyle {
  static InputDecoration textFieldStyle(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(5.0)),
            borderSide:
            BorderSide(color: Colors.redAccent)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.blue)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.red)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.green)),
      hintText: "Adicionar Nova Tarefa",
      contentPadding: EdgeInsets.all(15.0),
    );
  }
}
