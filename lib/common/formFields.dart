
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ithapppens/common/styles.dart';


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
class ProjectDateField extends StatelessWidget{
  final format;
  final DateTime initialDate;
  final Function onSaved;
  final Function validator;
  final controller;
  ProjectDateField({this.initialDate, this.format, this.onSaved, this.validator, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        child: DateTimeField(
          controller: controller,
            validator: (value) {
              if (value == null) {
                return 'Informe a data';
              }
              return null;
            },
            decoration: CommonStyle.textFieldStyle(hintTextStr: "Data do Projeto",labelTextStr: "Data"),
            format: format,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: initialDate ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
            onSaved: onSaved),
      ),
    ]);
  }
}