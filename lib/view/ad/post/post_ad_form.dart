import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_to_form/json_schema.dart';

import 'post_ad_location.dart';

class PostAdForm extends StatefulWidget {
  final int id;
  final String title;
  final Map form;

  PostAdForm(
      {Key key, @required this.id, @required this.title, @required this.form})
      : super(key: key);

  @override
  _PostAdForm createState() => new _PostAdForm(id: id, title: title, form: form);
}

class _PostAdForm extends State<PostAdForm> {
  final int id;
  final String title;
  final Map form;
  final String json_contents;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  _PostAdForm(
      {Key key, @required this.id, @required this.title, @required this.form, @required this.json_contents});

  dynamic reponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title
          //  + " id : " + id.toString()
        ),
        centerTitle: true,
        backgroundColor: Color(0xff0b4e94)
        ,
        actions: <Widget>[],
      ),
      key: scaffoldKey,
      body: new SingleChildScrollView(
        child: new Container(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new Column(children: <Widget>[
            new JsonSchema(
              formMap: form,
              onChanged: (dynamic response) {
                this.reponse = response;
              },
              actionSave: (data) async {

                Map formulaire = data;
                List champs = formulaire['fields'];
                String json_content = jsonEncode(champs).toString();
                //OPENING OF THE LOCATION VIEW OF THE AD WITH PARAMETER ID, JSON CONTENT
                openLocation(id,json_content);
                print(json_content);
              },
              buttonSave: new Container(
                height: 40.0,
                color: Color(0xff0b4e94),
                child: Center(
                  child: Text("Continuer",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }


  //Password control whose length must be greater than 5 characters
  bool validateStructure(String value) {
    if (value.length < 6) {
      return false;
    } else {
      return true;
    }
  }

  //open the view location with two parameters (id , json_content)
  openLocation(int id, String json_content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new PostAdLocation(id: id, json_content: json_content),
      ),
    );
  }


  void _showSnack(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }
}
