import 'package:flutter/material.dart';
import 'package:notes/categoria.dart';
import 'package:notes/nota_model.dart';
import 'package:notes/categoria_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'nova_categoria.dart';
import 'nova_nota.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Categoria> categorias;
  List<Nota> notas;
  var db = FirebaseFirestore.instance;
  //StreamSubscription<QuerySnapshot> categoriasinscritos;
  StreamSubscription<QuerySnapshot> notasinscritos;

  @override
  void initState() {
    //iniciaservico();
    super.initState();
    /*categorias = List();
    categoriasinscritos?.cancel();
    categoriasinscritos =
        db.collection("categorias").snapshots().listen((snapshot) {
      final List<Categoria> categoria = snapshot.docs
          .map((documentSnapshot) =>
              Categoria.fromMap(documentSnapshot.data(), documentSnapshot.id))
          .toList();
      setState(() {
        this.categorias = categoria;
      });
    });*/
    notas = List();
    notasinscritos?.cancel();
    notasinscritos = db.collection("notes").snapshots().listen((snapshot) {
      final List<Nota> nota = snapshot.docs
          .map((documentSnapshot) =>
              Nota.fromMap(documentSnapshot.data(), documentSnapshot.id))
          .toList();
      setState(() {
        this.notas = nota;
      });
    });
  }

  @override
  void dispose() {
    notasinscritos?.cancel();
    //categoriasinscritos?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bloco de Notas'),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getListaNotas(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      default:
                        List<DocumentSnapshot> documentos = snapshot.data.docs;
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.10,
                                    crossAxisCount: 2),
                            itemCount: documentos.length,
                            itemBuilder: (_, index) {
                              return Card(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ListTile(
                                              title: Text(notas[index].titulo,
                                                  style:
                                                      TextStyle(fontSize: 24)),
                                              subtitle: Text(
                                                  notas[index].nota.length >=
                                                          100
                                                      ? notas[index]
                                                              .nota
                                                              .substring(
                                                                  0, 20) +
                                                          "..."
                                                      : notas[index].nota,
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              onTap: () => navegarNotas(
                                                  context, notas[index]),
                                            ),
                                            ButtonBar(
                                                  children: <Widget>[
                                                    IconButton(
                                                        icon: const Icon(
                                                            Icons.delete_forever),
                                                        onPressed: () {
                                                          excluiNota(
                                                              context,
                                                              documentos[index],
                                                              index);
                                                        })
                                                  ],
                                                )
                                          ])));
                            });
                    }
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent[600],
        onPressed: () => cadastrarNota(context, Nota(null, "", "")),
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          new Container(
              child: new DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/images/header_background1.png'))),
                  child: Stack(children: <Widget>[
                    Positioned(
                        bottom: 12.0,
                        left: 16.0,
                        child: Text("Bloco de Notas",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500))),
                  ]))),
          ListTile(
            leading: new Icon(Icons.home),
            title: Text("Início"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage()));
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Categorias',
            ),
          ),
          ListTile(
            leading: new Icon(Icons.folder),
            title: Text("Página Dois"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CategoriaPage()));
            },
          ),
          ListTile(
            leading: new Icon(Icons.folder),
            title: Text("Página Três"),
            onTap: () {
              Navigator.of(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CategoriaPage()));
            },
          ),
          ListTile(
            leading: new Icon(Icons.add),
            title: Text("Adicionar nova categoria"),
            onTap: () {
              Navigator.of(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      NovaCategoria(new Categoria(null, null))));
            },
          ),
        ],
      )),
    );
  }

  Stream<QuerySnapshot> getListaNotas() {
    return FirebaseFirestore.instance.collection("notes").snapshots();
  }

  void excluiNota(
      BuildContext context, DocumentSnapshot doc, int posicao) async {
    //iniciaservico();
    db.collection("notes").doc(doc.id).delete();
    setState(() {
      //iniciaservico();
      notas.removeAt(posicao);
    });
  }

  void navegarNotas(BuildContext context, Nota nota) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovaNota(nota)),
    );
  }

  void cadastrarNota(BuildContext context, Nota nota) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovaNota(Nota(null, "", ""))),
    );
  }
}
