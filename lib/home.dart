import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const url = "https://api.hgbrasil.com/finance?format=json&key=a9f5f8aa";

Future<Map> getData() async {
  http.Response response = await http.get(url);
  return jsonDecode(response.body);  
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realEditController = TextEditingController();
  final dolarEditController = TextEditingController();
  final euroEditController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll(){
    realEditController.text = "";
    dolarEditController.text = "";
    euroEditController.text = "";
  }

  void _realChange(String text){
     if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarEditController.text = (real/dolar).toStringAsFixed(2);
    euroEditController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChange(String text){
     if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realEditController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroEditController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChange(String text){
     if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realEditController.text = (euro * this.euro).toStringAsFixed(2);
    dolarEditController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor de moedas \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting: 
              return Center(
                child: Text(
                  "Carregando dados....",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25
                  ),
                  textAlign: TextAlign.center,
                ),
              );             
              break;    
            case ConnectionState.done:
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              return SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      size: 150,
                      color: Colors.amber,
                    ),
                    bulderTextFiel("Real", "R\$", realEditController, _realChange),
                    Divider(),
                    bulderTextFiel("Dólar", "US\$", dolarEditController, _dolarChange),
                    Divider(),
                    bulderTextFiel("Euro", "UE ", euroEditController, _euroChange),
                  ],
                ),
              );
              break;            
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    "Erro ao carregar",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25
                    ),
                    textAlign: TextAlign.center,
                  ),
                );   
              }
          }
        },
      ),
    );
  }
}

Widget bulderTextFiel(String label, String prefix, TextEditingController textEditingController,
Function func
){
  return TextField(
    controller: textEditingController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber
    ),
    onChanged: func,
  );
}