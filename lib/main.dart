import 'dart:developer';

import 'package:comento_work/List/list.dart';
import 'package:comento_work/Util/user.dart';
import 'package:flutter/material.dart';

import 'Util/utils.dart';

void main() {
  runApp(
      MaterialApp(
        title: 'comento work',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
      )
  );
}


class LoginPage extends StatelessWidget {

  final tfc = TextEditingController();

  Utils utils;

  LoginPage(){
    utils = Utils();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN PAGE"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'LOGIN ID',
                    ),
                    controller: tfc,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child:
                    FlatButton(
                      child: Text('LOGIN', style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        if(tfc.text.isNotEmpty){
                          UserData().id = tfc.text;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ListPage()));
                        } else {
                          utils.showToast("ID is empty");
                        }
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}