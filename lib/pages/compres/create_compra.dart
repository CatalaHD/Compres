import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:compres/models/Compra.dart';
import 'package:compres/models/Prioritat/Prioritat.dart';
import 'package:compres/models/Tipus/Tipus.dart';
import 'package:compres/services/auth.dart';

import 'package:numberpicker/numberpicker.dart';

class CreateCompra extends StatefulWidget {
  @override
  _CreateCompraState createState() => _CreateCompraState();
}

class _CreateCompraState extends State<CreateCompra> {
  Compra compra = Compra.nova(null, AuthService().userId);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Compra"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: TextFormField(
                  validator: (value) {
                    if (value == "") {
                      return "Siusplau, posa un nom";
                    }
                    return null;
                  },
                  initialValue: compra.nom,
                  onChanged: (str) {
                    setState(() {
                      compra.nom = str;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Entra el nom del producte',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Quantitat: ${compra.quantitat}"),
                    Slider(
                      value: compra.quantitat.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      label: "${compra.quantitat}",
                      onChanged: (value) {
                        setState(() {
                          compra.quantitat = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona un tipus de producte"),
                    DropdownButton<Tipus>(
                      hint: Text("Escolleix un tipus"),
                      value: compra.tipus,
                      items: Tipus.values
                          .map<DropdownMenuItem<Tipus>>((Tipus value) {
                        return DropdownMenuItem<Tipus>(
                          value: value,
                          child: Text(value
                              .toString()
                              .substring(value.toString().indexOf('.') + 1)),
                        );
                      }).toList(),
                      onChanged: (Tipus newValue) {
                        setState(() {
                          compra.tipus = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona una prioritat"),
                    DropdownButton<Prioritat>(
                      hint: Text("Escolleix una prioritat"),
                      value: compra.prioritat,
                      items: Prioritat.values
                          .map<DropdownMenuItem<Prioritat>>((Prioritat value) {
                        return DropdownMenuItem<Prioritat>(
                          value: value,
                          child: Text(value
                              .toString()
                              .substring(value.toString().indexOf('.') + 1)),
                        );
                      }).toList(),
                      onChanged: (Prioritat newValue) {
                        setState(() {
                          compra.prioritat = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona una data prevista de compra"),
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            compra.dataPrevista == null
                                ? "Escolleix la data"
                                : compra.dataPrevista
                                        .toDate()
                                        .day
                                        .toString()
                                        .padLeft(2, "0") +
                                    "/" +
                                    compra.dataPrevista
                                        .toDate()
                                        .month
                                        .toString()
                                        .padLeft(2, "0") +
                                    "/" +
                                    compra.dataPrevista
                                        .toDate()
                                        .year
                                        .toString(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: compra.dataPrevista == null
                              ? DateTime.now()
                              : DateTime.fromMillisecondsSinceEpoch(
                                  compra.dataPrevista.millisecondsSinceEpoch),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        setState(() {
                          if (picked == null) {
                            compra.dataPrevista = null;
                          } else {
                            compra.dataPrevista = Timestamp.fromDate(picked);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Selecciona un preu estimat"),
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            compra.preuEstimat == null
                                ? "Escolleix el preu estimat"
                                : compra.preuEstimat.toString() + "€",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.euro),
                        ],
                      ),
                      onPressed: () async {
                        final picked = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return new NumberPickerDialog.integer(
                              title: Text("Preu estimat en €"),
                              minValue: 1,
                              maxValue: 100,
                              initialIntegerValue: compra.preuEstimat ?? 1,
                            );
                          },
                        );

                        setState(() {
                          compra.preuEstimat = picked;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.pop(context, compra);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Afegir',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.add_circle,
                      size: 40,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}