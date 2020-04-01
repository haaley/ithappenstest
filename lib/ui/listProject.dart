import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ithapppens/ui/editProjects.dart';
import 'package:ithapppens/model/model.dart';
import 'package:ithapppens/common/projectCard.dart';
import 'package:ithapppens/controller/ViewModel.dart';
import 'package:ithapppens/ui/projectView.dart';


class ProjectListWidget extends StatefulWidget {
  ProjectListWidget(this.model, {Key key}) : super(key: key);
  final ViewModel model;

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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProjectView(projeto)));
                    },
                    child: Card(
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
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
