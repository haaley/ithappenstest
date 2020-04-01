import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ithapppens/model/model.dart';
import 'package:intl/intl.dart';


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


