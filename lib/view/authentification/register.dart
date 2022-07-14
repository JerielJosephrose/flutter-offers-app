import 'package:annonce/database/crypt.dart';
import 'package:annonce/model/contact.dart';
import 'package:annonce/widgets/bezierContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:annonce/database/database.dart';
import 'package:annonce/model/user.dart';
import 'dart:async';
import 'package:annonce/model/country/country_list_pick.dart';
import 'package:annonce/model/country/code_country.dart';

import 'login.dart';

class Register extends StatefulWidget {
  Register(
      {Key key, @required this.mobileNumber})
      : super(key: key);
  final String mobileNumber;

  @override
  _RegisterState createState() => _RegisterState(mobileNumber: mobileNumber);
}

class _RegisterState extends State<Register> {
  Crypt cript = new Crypt();
  final _controller = TextEditingController();
  final _controller_password = TextEditingController();
  final _controllerp_password_confirm = TextEditingController();
  String mobileNumber;
  List userList;
  bool userexist=false;
  CountryCode country;
  String code = '33';
  bool passwordVisible=true;
   void getall() async {
    Future<List<User>> list = DBProvider.db.getAllUsers();
    userList = await list;
  }



  @override
  void initState() {
    _controller.value = TextEditingValue(text: mobileNumber);
    getall();
    super.initState();
  }


  _RegisterState(
      {Key key, @required this.mobileNumber});






  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        openLoginPage(_controller.text);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Vous avez déjà un compte?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Se connecter',
              style: TextStyle(
                  color: Color(0xff639ed8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _controller_password,
            obscureText: passwordVisible,//This will obscure text dynamically
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              labelText: 'Mot de passe',
              hintText: 'Saisir votre mot de passe',
              // Here is key idea
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Color(0xff34495e),
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _passwordField2({bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Text(
            'Confirmation du mot de passe',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),*/
      TextFormField(
        keyboardType: TextInputType.number,
        controller: _controllerp_password_confirm,
        obscureText: passwordVisible,//This will obscure text dynamically
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true,
          labelText: 'Confirmation du mot de passe',
          hintText: 'confirmer votre mot de passe',
          // Here is key idea
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              passwordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Color(0xff34495e),
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
        ),
      )

        /*  TextFormField(
              controller: _controllerp_password_confirm,
              obscureText: isPassword,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => _controllerp_password_confirm.clear(),
                    icon: Icon(Icons.clear),
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true)
          )*/
        ],
      ),
    );
  }

  openLoginPage(String mobileNumber) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => new Login(mobileNumber: mobileNumber),
       // builder: (context) => new usersList(),
      ),
    );
  }


  Widget _submitButton() {

    return InkWell(
      onTap: () {

        if (_controller.text != '' && _controller_password.text !='' && _controllerp_password_confirm.text !='') {

          if (_controller_password.text.length<6 && _controllerp_password_confirm.text.length<6){
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('saisir un mot de passe de plus de 5 chiffres '),
                );
              },
            );
          }
          else  if (_controller_password.text != _controllerp_password_confirm.text){
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Veuillez saisir un mot de passe identique'),
                );
              },
            );
          }

          else {
            String phone = code + _controller.text ;
              for (int i = 0; i < userList.length; i++) {

                if (userList[i].id ==  cript.encrypt(phone)) {
                  userexist = true;
                  print(userexist);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('Utilisateur existant'),
                      );
                    },
                  );
                }
              }
              print(userexist);
              if (userexist==false) {

                var now = new DateTime.now();
                String date = now.toString();
                DBProvider.db.addUserToDatabase(new User(
                    id: cript.encrypt(phone),
                    password: _controller_password.text,
                    date_insert: date
                )


                );

                String iduser = cript.encrypt(phone).toString();

                DBProvider.db.addContactToDatabase(
                    new Contact(
                        id_user: iduser,
                        phone: "",
                        email: "",
                        facebook: "",
                        skype: "",
                        instagram: "",
                        twitter: "",
                        linkedin: ""
                    ));
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Inscription validée'),
                    );
                  },
                );
                openLoginPage(_controller.text);

              }
              userexist = false;
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff639ed8), Color(0xff7a8ea2)])),
        child: Text(
          'S\'enregistrer',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Flutter offers',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff639ed8),
          ),
          children: [
            TextSpan(
              text: 'nn',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'onces',
              style: TextStyle(color: Color(0xff7a8ea2), fontSize: 30),
            ),
          ]),
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CountryList(
                                isShowFlag: true,
                                isShowTitle: false,
                                isShowCode: true,
                                isDownIcon: true,
                                initialSelection: '+33',
                                onChanged: (CountryCode ccode) {
                                  setState(() {
                                    // _controller.text = code.dialCode;
                                    code = ccode.dialCode ;
                                    country = ccode;
                                  });
                                },
                              ),
                              Expanded(child:

                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _controller,//This will obscure text dynamically
                                decoration: InputDecoration(
                                  hintText: 'n° de téléphone',
                                  border: InputBorder.none,
                                  fillColor: Color(0xfff3f3f4),
                                  filled: true,
                                ),
                              )

                              ),
                            ],
                          ),
                        ],
                      ),
                      _passwordField(),
                      _passwordField2(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: height * .055),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }


}
