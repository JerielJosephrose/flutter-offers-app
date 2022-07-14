import 'package:annonce/database/database.dart';
import 'package:annonce/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DetailContact extends StatefulWidget {

  final String contactdetail;
  final Contact contact;
  final String title;
  DetailContact(this.contactdetail, this.contact, this.title);

  @override
  State<StatefulWidget> createState() {
    return DetailContactState(this.contactdetail,this.contact,this.title);
  }
}

class DetailContactState extends State<DetailContact> {
  DBProvider helper = DBProvider();

  String id_user='';

  String twitter = 'Twitter';
  String phone = 'Numéro de téléphone';
  String email = 'Adresse email';
  String facebook = 'Facebook';
  String skype = 'Skype';
  String instagram = 'Compte instagram';
  String linkedin = 'Linkedin';
  String title;
  Contact contact;


  String contactdetail;
  TextEditingController inputController = TextEditingController();
  bool isEdited = false;

  DetailContactState(this.contactdetail,this.contact,this.title);


  @override
  void initState() {
    super.initState();
     getStringValuesSF();
  }


  @override
  Widget build(BuildContext context) {

    inputController.text = contactdetail;


    return WillPopScope(
        onWillPop: () {
          isEdited ? showDiscardDialog(context) : moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  isEdited ? showDiscardDialog(context) : moveToLastScreen();
                }),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  inputController.text.length == 0
                      ? showEmptyInputDialog(context)
                      : _save();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  showDeleteDialog(context);
                },
              )
            ],
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 50,
                      controller: inputController,
                      style: Theme.of(context).textTheme.bodyText2,
                      onChanged: (value) {
                        updateDescription();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Modification?",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text("Etes - vous sur de vouloir effectuer cette modification?",
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("Oui",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Non",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Le champs est vide",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text('Le champs ne peux être vide',
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Supprimer le moyen de contact?",
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text("Etes-vous sur de vouloir supprimer ce moyen contact",
              style: Theme.of(context).textTheme.body2),
          actions: <Widget>[
            FlatButton(
              child: Text("Non",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Oui",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.purple)),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }



  void updateContact() {
    final Future<Database> dbFuture = DBProvider.db.initDB();
    dbFuture.then((database) {
      Future<Contact> noteListFuture = DBProvider.db.getContactById(id_user);
      noteListFuture.then((contact) {
        setState(() {
          this.contact = contact;
        });
      });
    });
  }


  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateDescription() {
    isEdited = true;
    if (title==twitter) {
      contact.twitter = inputController.text;
    }
    else if (title==phone) {
      contact.phone = inputController.text;
    }
    else if (title==email) {
      contact.email = inputController.text;
    }
    else if (title==facebook) {
      contact.facebook = inputController.text;
    }
    else if (title==skype) {
      contact.skype = inputController.text;
    }
    else     if (title==instagram) {
      contact.instagram = inputController.text;
    }
    else     if (title==linkedin) {
      contact.linkedin = inputController.text;
    }
  }

  void _delete() async {
    if (title==twitter) {
      contact.twitter = '';
    }
    else if (title==phone) {
      contact.phone = '';
      print(contact.phone);
    }
    else if (title==email) {
      contact.email = '';
    }
    else if (title==facebook) {
      contact.facebook = '';
    }
    else if (title==skype) {
      contact.skype = '';
    }
    else     if (title==instagram) {
      contact.instagram = '';
    }
    else     if (title==linkedin) {
      contact.linkedin = '';
    }
    _save();
  }

  void _save() async {
    moveToLastScreen();
      await helper.updateContact(contact);
      print(contact);
  }

  bool validateStructure(String value) {
    if (value.length <9) {
      return false;
    } else {
      return true;
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id_user = prefs.get('user');
    print ('curent user id crypt: ' +id_user);
    setState(() {
      id_user = prefs.get('user').toString();

    });
  }

  }


