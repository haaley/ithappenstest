import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ithapppens/controller/ViewModel.dart';

class RemoveItemsButton extends StatelessWidget {
  final ViewModel model;

  RemoveItemsButton(this.model);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.redAccent, shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.red)
    ),

      child: Text('Deletar Todos'),
      onPressed: () => model.onRemoveProjects(),
    );
  }
}
