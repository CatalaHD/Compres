import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:compres/services/database.dart';
import 'package:compres/shared/llista_buida.dart';
import 'package:compres/shared/sortir_sessio.dart';
import 'package:compres/models/Prioritat/PrioritatColors.dart';
import 'package:compres/models/Tipus/TipusEmojis.dart';
import 'package:compres/models/Compra.dart';
import 'package:compres/pages/accounts/profile.dart';
import 'package:compres/pages/compres/create_compra.dart';
import 'package:compres/pages/compres/compra_card.dart';

class LlistaCompra extends StatelessWidget {
  LlistaCompra({
    // llista actual a mostrar
    this.llista,
    // llista de les llistes disponibles pel perfil actual
    this.llistesUsuari,
    // index de la llista actual
    this.indexLlista,
    // Funcio per canviar el valor de l'index de la llista del parent
    this.rebuildParentFiltre,
    // Funcio per canviar el valor Bool de comprat del parent
    this.rebuildParentComprat,
    // Bool per si s'esta mostrant les elements comprats o no
    this.comprat,
  });

  final List<Map<String, dynamic>> llista;
  final List<Map<String, String>> llistesUsuari;
  final int indexLlista;
  final Function rebuildParentComprat;
  final Function rebuildParentFiltre;
  final bool comprat;

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Center(
        child: Text(
          "Compres de ${llistesUsuari[indexLlista]['nom']}",
          overflow: TextOverflow.fade,
        ),
      ),
      actions: [
        PopupMenuButton<int>(
          tooltip: "Selecciona una llista",
          icon: Icon(Icons.filter_list),
          onSelected: (int index) {
            rebuildParentFiltre(index);
          },
          initialValue: indexLlista,
          itemBuilder: (BuildContext context) {
            return llistesUsuari
                .map(
                  (Map<String, String> llista) => PopupMenuItem(
                    value: llistesUsuari.indexOf(llista),
                    child: Text(llista['nom'] + " - " + llista['id']),
                  ),
                )
                .toList();
          },
        ),
      ],
    );

    ListView mostrarLlista = ListView.builder(
      itemCount: llista.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> compra = llista[index];
        final compraKey = compra['key'];
        final Icon tipusIcon = TipusEmojis(tipus: compra['tipus']).toIcon();
        final Color cardColor =
            PrioritatColor(prioritat: compra['prioritat']).toColor();
        final String prioritatString =
            PrioritatColor(prioritat: compra['prioritat']).toString();

        return comprat
            ? CompraCard(
                cardColor: cardColor,
                tipusIcon: tipusIcon,
                compraKey: compraKey,
                compra: compra,
                prioritatString: prioritatString,
                tipus: llistesUsuari,
              )
            : Dismissible(
                key: Key("$compraKey"),
                background: Container(
                  color: Colors.green,
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                onDismissed: (direction) async {
                  await DatabaseService().comprarCompra(compraKey);
                  print("Compra realitzada correctament!");
                },
                child: CompraCard(
                  cardColor: cardColor,
                  tipusIcon: tipusIcon,
                  compraKey: compraKey,
                  compra: compra,
                  prioritatString: prioritatString,
                  tipus: llistesUsuari,
                ),
              );
      },
    );

    BottomAppBar bottomAppBar = BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Colors.blue,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
              flex: 1,
            ),
            FlatButton(
              onPressed: () {
                rebuildParentComprat(false);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    !comprat ? Icons.shop_two : Icons.shop_two_outlined,
                    color: Colors.white,
                    size: !comprat ? 30 : 20,
                  ),
                  Text(
                    "Per comprar",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
              flex: 3,
            ),
            FlatButton(
              onPressed: () {
                rebuildParentComprat(true);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    comprat
                        ? Icons.monetization_on
                        : Icons.monetization_on_outlined,
                    color: Colors.white,
                    size: comprat ? 30 : 20,
                  ),
                  Text(
                    "Comprats",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );

    FloatingActionButton floatingActionButton = FloatingActionButton(
      onPressed: () async {
        final Compra result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateCompra(
              llistesUsuari: llistesUsuari,
              indexLlista: indexLlista,
            ),
          ),
        );

        if (result != null) {
          await DatabaseService().addCompra(result.toDBMap());
          print("Producte afegit correctament!");
        }
      },
      tooltip: 'Afegir un nou element a la llista de la compra',
      child: Icon(Icons.add_shopping_cart),
    );

    Drawer drawer = Drawer(
      semanticLabel: "Calaix on es guarden totes les opcions importants.",
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 100,
                ),
                Text(
                  "Llista de la compra",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
                  elevation: 3,
                  color: Colors.grey[100],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => Perfil()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Perfil"),
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              SortirSessio(),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: RaisedButton(
                  elevation: 3,
                  color: Colors.grey[100],
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon: FlutterLogo(),
                      applicationName: "Compres",
                      applicationVersion: '0.0.1',
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
              Text("Versió 0.0.1"),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      extendBody: true,
      appBar: appBar,
      body: llista.isEmpty ? LlistaBuida() : mostrarLlista,
      bottomNavigationBar: bottomAppBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
    );
  }
}
