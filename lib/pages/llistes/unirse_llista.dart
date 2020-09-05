import 'package:compres/services/database.dart';
import 'package:compres/shared/loading.dart';
import 'package:flutter/material.dart';

class UnirseLlista extends StatefulWidget {
  @override
  _UnirseLlistaState createState() => _UnirseLlistaState();
}

class _UnirseLlistaState extends State<UnirseLlista> {
  final _formKey = GlobalKey<FormState>();
  String id;
  bool loading = false;
  String errorMsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Unir-se a una llista")),
      ),
      body: loading
          ? Loading("Comprovant la ID...")
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.topCenter,
                      child: TextFormField(
                        validator: (value) {
                          if (value.length != 20) {
                            return "La ID ha de tenir 20 caràcters. Respecta les majúscules i minuscules.";
                          }
                          return null;
                        },
                        initialValue: id,
                        onChanged: (str) {
                          setState(() {
                            id = str;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Entra la ID de la llista',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.blueAccent,
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if (_formKey.currentState.validate()) {
                          // Comprovo si existeix la llista com a tal
                          if (await DatabaseService().existeixLlista(id)) {
                            // Comprovo si no estic ja a dins
                            if (await DatabaseService().pucEntrarLlista(id)) {
                              Navigator.pop(context, id);
                            }
                            setState(() {
                              errorMsg = "Ja estas dins d'aquesta llista";
                            });
                          } else {
                            setState(() {
                              errorMsg = "La llista no existeix";
                            });
                          }
                        }
                        if (this.mounted) {
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Unir-me',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.group_add,
                            size: 40,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    Text(errorMsg),
                  ],
                ),
              ),
            ),
    );
  }
}
