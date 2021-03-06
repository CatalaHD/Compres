import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:totfet/models/Finestra.dart';
import 'package:totfet/models/Report.dart';
import 'package:totfet/pages/accounts/image_picker.dart';
import 'package:totfet/pages/admin/admin_panel.dart';
import 'package:totfet/pages/admin/report_list.dart';
import 'package:totfet/pages/compres/stats_compres.dart';
import 'package:totfet/pages/tasques/stats_tasques.dart';
import 'package:totfet/shared/drawer.dart';
import 'package:totfet/models/Llista.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/pages/accounts/edit_profile.dart';
import 'package:totfet/pages/llistes/administracio/admin_llista.dart';
import 'package:totfet/pages/llistes/crear_llista.dart';
import 'package:totfet/pages/llistes/unirse_llista.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class Perfil extends StatefulWidget {
  final Function canviarFinestra;
  Perfil({this.canviarFinestra});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final Stream<DocumentSnapshot> futureSnapshot =
        DatabaseService(uid: _auth.userId).getUserData();

    return WillPopScope(
      onWillPop: () {
        return widget.canviarFinestra(Finestra.Menu);
      },
      child: StreamBuilder(
        stream: futureSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return SomeErrorPage(error: snapshot.error);
          }

          if (snapshot.hasData) {
            DocumentSnapshot doc = snapshot.data;
            Usuari usuari = Usuari.fromDB(
              _auth.userId,
              _auth.userEmail,
              doc.data(),
            );

            return Scaffold(
              drawer: MyDrawer(
                canviarFinestra: widget.canviarFinestra,
                actual: Finestra.Perfil,
              ),
              appBar: AppBar(
                title: Text("Perfil"),
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Colors.blue[400],
                        Colors.blue[900],
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: "Editar perfil",
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      Usuari resposta = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPerfil(usuari: usuari),
                        ),
                      );
                      if (resposta != null) {
                        // Instantaniament al fer rebuild s'actualitza la Query
                        await DatabaseService(uid: usuari.uid)
                            .updateUserData(resposta);
                      }
                    },
                  ),
                  if (usuari.isAdmin)
                    IconButton(
                      tooltip: "Administració",
                      icon: Icon(Icons.admin_panel_settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminPanel(),
                          ),
                        );
                      },
                    ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: "ImgPerfil",
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: FlatButton(
                                onPressed: () async {
                                  String avatarFilePath =
                                      await usuari.avatarFile;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => ImageCapture(
                                        imgPath: avatarFilePath,
                                        nom: usuari.nom,
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: usuari.avatar,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      usuari.nom.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  usuari.isAdmin
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Tooltip(
                                            message: "Administrador",
                                            child: Icon(
                                              Icons.build,
                                              color: Colors.indigo[300],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                usuari.email,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (usuari.bio == null || usuari.bio == "")
                        Text(
                          "No tens bio",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        Text(
                          usuari.bio,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      Divider(),
                      Center(
                        child: Text(
                          "Les meves llistes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tooltip(
                            message: "Crear una nova llista.",
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              elevation: 3,
                              onPressed: () async {
                                Llista result =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CrearLlista(
                                      finestra: Finestra.Perfil,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  await DatabaseService().addList(result);
                                  print("Llista creada correctament!");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "images/create.svg",
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Crear",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Tooltip(
                            message: "Unir-me a una llista.",
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              elevation: 3,
                              onPressed: () async {
                                String id = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UnirseLlista(finestra: Finestra.Perfil),
                                  ),
                                );
                                if (id != null) {
                                  await DatabaseService().addUsuariLlista(id);
                                  print("T'has unit a la llista correctament!");
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "images/join.svg",
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Unir-me",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Tooltip(
                        message:
                            "Administrar les llistes a les que estic inscrit.",
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          elevation: 3,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdminLlistes(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "images/settings.svg",
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Administrar",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 40,
                      ),
                      Center(
                        child: Text(
                          "Les meves estadístiques",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tooltip(
                            message:
                                "Veure estadístiques de les teves compres.",
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              elevation: 3,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StatsCompres(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "images/shop.svg",
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Compres",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Tooltip(
                            message:
                                "Veure estadístiques de les teves tasques.",
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              elevation: 3,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StatsTasques(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "images/todo.svg",
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Tasques",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Divider(
                        height: 40,
                      ),
                      Center(
                        child: Text(
                          "Els meus informes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Tooltip(
                        message: "Veure els meus informes.",
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          elevation: 3,
                          onPressed: () async {
                            QuerySnapshot snapshot =
                                await DatabaseService().getReports();
                            List list = snapshot.docs
                                .map((e) => Report.fromDB(e.data(), e.id))
                                .toList();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ReportList(
                                  informes: list,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "images/report.svg",
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Informes",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Si encara no hi ha dades
          return Scaffold(
            body: Loading(
              msg: "Carregant les dades del perfil...",
              esTaronja: false,
            ),
          );
        },
      ),
    );
  }
}
