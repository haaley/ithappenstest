import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ithapppens/model/model.dart';
import 'package:intl/intl.dart';
import 'package:ithapppens/controller/ViewModel.dart';

class ProjetoCard extends StatelessWidget {
  final ViewModel store;
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