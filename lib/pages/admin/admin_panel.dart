import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:totfet/models/Report.dart';
import 'package:totfet/pages/admin/report_list.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Administració"),
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
      ),
      body: FutureBuilder<List<QuerySnapshot>>(
        future: DatabaseService().getAllTablesInfo(),
        builder: (BuildContext context,
            AsyncSnapshot<List<QuerySnapshot>> snapshot) {
          if (snapshot.hasError) {
            return SomeErrorPage(
              error: snapshot.error.toString(),
            );
          }

          if (snapshot.hasData) {
            return AdminPanelView(
              data: snapshot.data,
              rebuildParent: () => setState(() {}),
            );
          }

          return Scaffold(
            body: Loading(
              msg: "Carregant panell d'administració...",
              esTaronja: false,
            ),
          );
        },
      ),
    );
  }
}

class AdminPanelView extends StatelessWidget {
  final List<QuerySnapshot> data;
  final Function rebuildParent;
  AdminPanelView({this.data, this.rebuildParent});
  @override
  Widget build(BuildContext context) {
    int nUsuaris = data[0].docs.length;
    int nLlistes = data[1].docs.length;
    int nCompres = data[2].docs.length;
    int nTasques = data[3].docs.length;
    int nInformes = data[4].docs.length;

    TableRow buildTableRow(String titol, int quantitat) {
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(titol),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "$quantitat",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(),
            children: [
              buildTableRow("Nombre d'usuaris", nUsuaris),
              buildTableRow("Nombre de llistes", nLlistes),
              buildTableRow("Nombre de compres", nCompres),
              buildTableRow("Nombre de tasques", nTasques),
              buildTableRow("Nombre d'informes", nInformes),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 3,
            onPressed: () async {
              List<Report> informes = data[4]
                  .docs
                  .map((e) => Report.fromDB(e.data(), e.id))
                  .toList();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportList(informes: informes),
                ),
              );
              rebuildParent();
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
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
