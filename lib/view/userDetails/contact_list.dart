import 'package:annonce/database/database.dart';
import 'package:annonce/model/contact.dart';
import 'package:annonce/view/userDetails/contact_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/m'
    'aterial.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';



class contact extends StatefulWidget {
  @override
  contactState createState() => contactState();
}

class contactState extends State<contact> {


  String id_user='';
  bool dialVisible = true;
  Contact contact;
  List<ContactValue> myContacts;
  String twitter = 'Twitter';
  String phone = 'Numéro de téléphone';
  String email = 'Adresse email';
  String facebook = 'Facebook';
  String skype = 'Skype';
  String instagram = 'Compte instagram';
  String linkedin = 'Linkedin';



  @override
  void initState() {
    super.initState();

    getStringValuesSF();
    updateContactList();

  }

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  id_user = prefs.get('user');
  print ('curent user id crypt: ' +id_user);
  setState(() {
    id_user = prefs.get('user').toString();
  });
}

  @override
  Widget build(BuildContext context) {
    if (myContacts == null) {
      myContacts = List<ContactValue>();
      updateContactList();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Vos moyens de contact'),
        backgroundColor: Color(0xff0b4e94),),
      body:
      getNotesList(),
      floatingActionButton: buildSpeedDial(),
    );
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }


  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      backgroundColor: Color(0xff0b4e94),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
            child: Image.asset("images/phone.png"),
            backgroundColor: Colors.transparent,
          onTap: () {
            navigateToDetail(contact.phone,contact, phone);
          },
        ),
        SpeedDialChild(
            child: Image.asset("images/email.png"),
            backgroundColor: Colors.transparent,
          onTap: () {
            navigateToDetail(contact.email,contact, email);
          },
        ),
        SpeedDialChild(
            child: Image.asset("images/facebook.png"),
            backgroundColor: Colors.transparent,
          onTap: () {
            navigateToDetail(contact.facebook,contact, facebook);
          },
        ),
        SpeedDialChild(
            child: Image.asset("images/skype.png"),
            backgroundColor: Colors.transparent,
          onTap: () {
            navigateToDetail(contact.skype,contact, skype);
          },
        ),
        SpeedDialChild(
            child: Image.asset("images/instagram.png"),
            backgroundColor: Colors.transparent,
          onTap: () {
            navigateToDetail(contact.instagram,contact, instagram);
          },
        ),
        SpeedDialChild(
            child: Image.asset("images/twit.png"),
            backgroundColor: Colors.transparent,
          onTap: () {
          navigateToDetail(contact.twitter,contact, twitter);
        },
        ),
         SpeedDialChild(
            child: Image.asset("images/linkedin.png"),
            backgroundColor: Colors.transparent,
             onTap: () {
               navigateToDetail(contact.linkedin,contact, linkedin);
             },
        ),
      ],
    );
  }

  void navigateToDetail(String value, Contact contact, String title ) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailContact(value, contact,title)));
    if (result == true) {
      updateContactList();
    }
  }

  void updateContactList() {

    ContactValue Phone = ContactValue('Numéro de téléphone',  Image.asset("images/phone.png") );
    ContactValue Email = ContactValue('Adresse email',  Image.asset("images/email.png") );
    ContactValue Facebook = ContactValue('Facebook', Image.asset("images/facebook.png") );
    ContactValue Skype = ContactValue('Skype',  Image.asset("images/skype.png") );
    ContactValue Instagram = ContactValue('Compte instagram',  Image.asset("images/instagram.png") );
    ContactValue Linkedin = ContactValue('Linkedin',  Image.asset("images/linkedin.png") );
    ContactValue Twitter = ContactValue('Twitter',  Image.asset("images/twit.png") );

    final Future<dynamic> dbFuture = DBProvider.db.initDB();
    dbFuture.then((database) {
      Future<Contact> contactListFuture = DBProvider.db.getContactById(id_user);
      contactListFuture.then((contact) {
        setState(() {
          myContacts = List<ContactValue>();
          this.contact = contact;

          if (this.contact.instagram!=''){
            Instagram.value = this.contact.instagram;
            print(Instagram);
            myContacts.add(Instagram);
          }

          if (this.contact.twitter!=''){
            Twitter.value = this.contact.twitter;
            myContacts.add(Twitter);
            print (myContacts.toString());
          }

          if (this.contact.skype!=''){
            Skype.value = this.contact.skype;
            print(Skype);
            myContacts.add(Skype);
          }
          if (this.contact.facebook!=''){
            Facebook.value = this.contact.facebook;
            print(Facebook);
            myContacts.add(Facebook);
          }
          if (this.contact.phone!=''){
            Phone.value = this.contact.phone;
            print(Phone.imageicon);
            myContacts.add(Phone);
          }
          if (this.contact.email!=''){
            Email.value = this.contact.email;
            print(Email.title);
            myContacts.add(Email);
          }
          if (this.contact.linkedin!=''){
            Linkedin.value = this.contact.linkedin;
            print(Linkedin.value);
            myContacts.add(Linkedin);
          }
          print('PRINTCONTACTLIST');
          print(myContacts);
        });
      });
    });
  }

  Widget getNotesList() {

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: myContacts.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: ListTile(leading: myContacts[index].imageicon, title: Text(myContacts[index].title.toString() + ": " + myContacts[index].value.toString())),

          onTap: () {
            navigateToDetail(myContacts[index].value,contact,  myContacts[index].title);
          },

        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }


}