import 'package:compres/models/Finestra.dart';
import 'package:compres/shared/constants.dart';
import 'package:compres/shared/sortir_sessio.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final Function canviarFinestra;
  MyDrawer({this.canviarFinestra});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Calaix on es guarden totes les opcions importants.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue[900],
                Colors.blue[400],
              ]),
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(40.0),
                bottomRight: const Radius.circular(40.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.dynamic_feed,
                  size: 60,
                  color: Colors.white,
                ),
                Text(
                  "$appName",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    canviarFinestra(Finestra.Menu);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.apps),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Menu Principal"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    canviarFinestra(Finestra.Llista);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Les meves Compres"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    canviarFinestra(Finestra.Tasques);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.assignment),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Les meves Tasques"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              Divider(),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    canviarFinestra(Finestra.Perfil);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(
                        width: 20,
                      ),
                      Text("El meu Perfil"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              SortirSessio(),
              Divider(),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon:
                          Image.asset("images/favicon.png", height: 50),
                      applicationName: appName,
                      applicationVersion: versionNumber,
                      applicationLegalese: 'Desenvolupat per Aleix Ferré',
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.help),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Més info"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("$appName © Aleix Ferré"),
              Text("Versió $versionNumber"),
            ],
          ),
        ],
      ),
    );
  }
}