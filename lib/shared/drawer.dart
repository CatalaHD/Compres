import 'package:compres/models/Finestra.dart';
import 'package:compres/shared/constants.dart';
import 'package:compres/shared/sortir_sessio.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final Function canviarFinestra;
  final Finestra actual;
  MyDrawer({this.canviarFinestra, this.actual});

  bool escenaActual(Finestra finestra) {
    return finestra != actual;
  }

  final Color color = Colors.grey[100];
  final Color disabledColor = Colors.grey[200];
  final Color disabledTextColor = Colors.blue[400];

  final LinearGradient gradient = LinearGradient(colors: [
    Colors.blue[900],
    Colors.blue[400],
  ]);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Calaix on es guarden totes les opcions importants.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.only(
                //bottomLeft: const Radius.circular(18.0),
                bottomRight: const Radius.circular(18.0),
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
                  appName,
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
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
                disabledTextColor: disabledTextColor,
                disabledColor: disabledColor,
                color: color,
                onPressed: escenaActual(Finestra.Menu)
                    ? () {
                        canviarFinestra(Finestra.Menu);
                      }
                    : null,
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
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
                disabledTextColor: disabledTextColor,
                disabledColor: disabledColor,
                color: color,
                onPressed: escenaActual(Finestra.Llista)
                    ? () {
                        canviarFinestra(Finestra.Llista);
                      }
                    : null,
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
              RaisedButton(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                disabledTextColor: disabledTextColor,
                disabledColor: disabledColor,
                color: color,
                onPressed: escenaActual(Finestra.Tasques)
                    ? () {
                        canviarFinestra(Finestra.Tasques);
                      }
                    : null,
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
              Divider(),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
                disabledTextColor: disabledTextColor,
                disabledColor: disabledColor,
                color: color,
                onPressed: escenaActual(Finestra.Perfil)
                    ? () {
                        canviarFinestra(Finestra.Perfil);
                      }
                    : null,
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
              SortirSessio(),
              Divider(),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
                disabledTextColor: disabledTextColor,
                disabledColor: disabledColor,
                color: color,
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon:
                        Image.asset("images/favicon.png", height: 50),
                    applicationName: appName,
                    applicationVersion: versionNumber,
                    applicationLegalese: 'Desenvolupat per $appCreator',
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
              SizedBox(height: 20),
              Text("$appName © ${DateTime.now().year} $appCreator"),
              Text("Versió $versionNumber"),
            ],
          ),
        ],
      ),
    );
  }
}
