import 'package:annonce/database/database.dart';
import 'package:annonce/database/preferences.dart';
import 'package:annonce/model/contents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home_page.dart';

class PostAdConfirmation extends StatefulWidget {
  final String contentjson;
  final int id;
  final String latitude;
  final String longitude;
  final String date;
  final String contact;

  PostAdConfirmation(
      {Key key,
      @required this.contentjson,
      this.id,
      this.longitude,
      this.latitude,
      this.date,
      this.contact})
      : super(key: key);

  @override
  PostAdConfirmationState createState() => new PostAdConfirmationState(this.id,
      this.latitude, this.longitude, this.date, this.contentjson, this.contact);
}

class PostAdConfirmationState extends State<PostAdConfirmation> {
  final String contentjson;
  final int id;
  final String latitude;
  final String longitude;
  final String date;
  final String contact;
  Contents content;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Geolocator _geolocator = Geolocator();
  String codepostal = "";
  String locality = "";
  String title;
  String price;
  String description;
  String criteres;
  preferences pref = new preferences();

  //String pseudo = '';
  String iduser = "";

  PostAdConfirmationState(this.id, this.latitude, this.longitude, this.date,
      this.contentjson, this.contact);

  openConfirm(int id, String contentjson, String latitude, String longitude,
      String date, String contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new PostAdConfirmation(
            id: id,
            contentjson: contentjson,
            latitude: latitude,
            longitude: longitude,
            date: date,
            contact: contact),
      ),
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      iduser = prefs.get('user').toString();
      print(iduser);
    });
  }

  dynamic reponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Confirmer l'annonce",
        ),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          child: Text(
            'Valider votre annonce',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () {
            try {
              DBProvider.db.addContentsToDatabase(new Contents(
                  id_form: id,
                  json_content: contentjson,
                  latitude: latitude,
                  longitude: longitude,
                  id_user: iduser,
                  contact: contact,
                  date_insert: date));
            } catch (e) {
              print(e);
            }
            return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
            //Navigator.of(context).popUntil(ModalRoute.withName('/root'));
          },
        ),
      ),
    );
  }
}
