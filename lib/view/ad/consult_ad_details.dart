import 'package:annonce/model/contents.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'consult_ad_contact.dart';

class ConsultAd extends StatefulWidget {
  JsonContent contentjson;
  Contents content;

  ConsultAd({Key key, @required this.contentjson, this.content})
      : super(key: key);

  @override
  _consult createState() =>
      new _consult(contentjson: contentjson, content: content);
}

class _consult extends State<ConsultAd> {
  JsonContent contentjson;
  Contents content;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Geolocator _geolocator = Geolocator();
  String codepostal = "";
  String locality= "";
  Placemark placemark;
  String titre;
  String prix;
  String description;
  String criteres;
  String pseudo="";
  String contact="";

  @override
  void initState() {
    super.initState();
    _getLocation();
    titre = getTitre(contentjson);
    prix = (getPrix(contentjson) + '€');
    description = getDescription(contentjson);
    criteres = getCriteres(contentjson);
    contact = content.contact;
  }

  _consult({Key key, @required this.contentjson, this.content});

  dynamic reponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:    Color(0xff0b4e94),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Details de l'annonce",
        ),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            SizedBox(height: 10.0),
            Text(
              titre,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              maxLines: 2,
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  Text(
                    prix,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: Color(0xfffed711c),
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  Text(
                    convertDateFromString(content.date_insert),
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10.0),
            Text(
              description,
              style: TextStyle(
                fontSize: 13.0,
                //fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 20.0),
            Divider(
              color: Colors.black54,
            ),
            Text(
              'Critères',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20.0),
            Text(criteres,
                style: TextStyle(
                  fontSize: 13.0,
                )),

             Divider(
              color: Colors.black54,
            ),
            SizedBox(height: 20.0),
            Text(
              'Localisation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 25,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    locality +
                        " (" +
                         codepostal +
                        ")",
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                      fontSize: 17),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 10.0),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(

          child: Text(
            'Contacter',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color:  Color(0xff0b4e94),
          onPressed: () {
            openConfirm(contact);
          },
        ),
      ),
    );
  }

  _getLocation() async {
    await _geolocator
        .placemarkFromCoordinates(
            double.parse(content.latitude), double.parse(content.longitude))
        .then((List<Placemark> p) async {
      setState(() {
        placemark = p[0];
        setState(() {
          codepostal = placemark.postalCode.toString();
          locality = placemark.locality.toString();
        });
      });
    }).catchError((e) {
      print(e);
    });
  }

  String getTitre(JsonContent contentjson) {
    String titre;
    for (int i = 0; i < contentjson.fields.length; i++) {
      if (contentjson.fields[i].key.toString() == 'titre') {
        titre = contentjson.fields[i].value.toString();
      }
    }
    return titre;
  }

  String getPrix(JsonContent contentjson) {
    String prix = '';
    for (int i = 0; i < contentjson.fields.length; i++) {
      if (contentjson.fields[i].key.toString() == 'Prix') {
        prix = contentjson.fields[i].value.toString();
      }
    }
    return prix;
  }

  String getDescription(JsonContent contentjson) {
    String description = '';
    for (int i = 0; i < contentjson.fields.length; i++) {
      if (contentjson.fields[i].key.toString() == 'description') {
        description = contentjson.fields[i].value.toString();
      }
    }
    return description;
  }

  String getCriteres(JsonContent jsoncontent) {
    String data = '';
    for (int i = 0; i < jsoncontent.fields.length; i++) {
      if (jsoncontent.fields[i].key.toString() != 'titre' &&
          jsoncontent.fields[i].key.toString() != 'description' &&
          jsoncontent.fields[i].key.toString() != 'Prix') {
        if (jsoncontent.fields[i].key.toString() == 'switch') {
          // La value est un boolean pour le type switch
          if (jsoncontent.fields[i].value) {
            // if true
            data = data +
                ((jsoncontent.fields[i].label.toString()) + ": OUI" "\n\n");
          } else if (!jsoncontent.fields[i].value) {
            // if false
            data = data +
                ((jsoncontent.fields[i].label.toString()) + ": NON" "\n\n");
          }
        } else {
          data = data +
              ((jsoncontent.fields[i].label.toString()) +
                  ": " +
                  (jsoncontent.fields[i].value.toString()) +
                  "\n\n");
        }
      }
    }
    return data;
  }

  String convertDateFromString(String strDate) {
    DateTime todayDate = DateTime.parse(strDate);
    return strDate =
        formatDate(todayDate, [dd, '/', mm, '/', hh, ':', nn]).toString();
  }

  openConfirm(String contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new AdContact(contact: contact),
      ),
    );
  }


}
