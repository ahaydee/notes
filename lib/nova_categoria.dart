import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'categoria_model.dart';

class NovaCategoria extends StatefulWidget {
  final Categoria categoria;
  NovaCategoria(this.categoria);
  @override
  _NovaCategoriaState createState() => _NovaCategoriaState();
}

class _NovaCategoriaState extends State<NovaCategoria> {
  final db = FirebaseFirestore.instance;
  TextEditingController titulocontroller;
  @override
  void initState() {
    super.initState();
    titulocontroller = new TextEditingController(text: widget.categoria.titulo);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Categoria Nova/Alterar'),
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.all(18.0),
          alignment: Alignment.center,
          child: Column(children: [
            TextField(
              controller: titulocontroller,
              decoration: InputDecoration(labelText: "Titulo"),
            ),
            RaisedButton(
                color: Colors.blueGrey,
                child: (widget.categoria.id != null)
                    ? Text("Alterar")
                    : Text(
                        "Novo",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                onPressed: () {
                  if (widget.categoria.id != null) {
                    db
                        .collection("notes")
                        .doc(widget.categoria.id)
                        .set({"titulo": titulocontroller.text});
                  } else {
                    db
                        .collection("notes")
                        .doc(widget.categoria.id)
                        .set({"titulo": titulocontroller.text});
                  }
                  Navigator.pop(context);
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                })
          ])),
    );
  }
}
