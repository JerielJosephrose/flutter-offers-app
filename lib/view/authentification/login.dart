import 'package:annonce/database/crypt.dart';
import 'package:annonce/database/database.dart';
import 'package:annonce/model/country/code_country.dart';
import 'package:annonce/model/country/country_list_pick.dart';
import 'package:annonce/model/user.dart';
import 'package:annonce/view/home_page.dart';
import 'package:annonce/widgets/bezierContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register.dart';

class Login extends StatefulWidget {
  Login({Key key, @required this.mobileNumber}) : super(key: key);
  final String mobileNumber;

  @override
  _LoginState createState() => _LoginState(mobileNumber: mobileNumber);
}

class _LoginState extends State<Login> {
  final _controller = TextEditingController();
  final _controllerp = TextEditingController();
  Crypt cript = new Crypt();
  String mobileNumber;
  List userList;
  bool userexist = false;
  bool checkBoxValue = false;
  CountryCode country;
  String code = '33';

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

  _LoginState({Key key, @required this.mobileNumber});

  Widget _phoneField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
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
                    code = ccode.dialCode;
                    country = ccode;
                  });
                },
              ),
              Expanded(
                  child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _controller, //This will obscure text dynamically
                decoration: InputDecoration(
                  hintText: 'n° de téléphone',
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  bool passwordVisible = true;

  Widget _passwordField({bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _controllerp,
            obscureText: passwordVisible, //This will obscure text dynamically
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
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
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

  Widget _loginButton() {
    return InkWell(
      onTap: () async {
        String phone = code + _controller.text;
        String iduser = cript.encrypt(phone).toString();

        if (_controller.text != '' && _controllerp.text != '') {
          for (int i = 0; i < userList.length; i++) {
            if (userList[i].id == cript.encrypt(phone)) {
              if (userList[i].password == _controllerp.text) {
                userexist = true;
              }
            }
          }
        }

        if (userexist == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (checkBoxValue == true) {
            prefs.setString('phone', phone);
            prefs.setString('user', iduser);

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext ctx) => HomePage()));
          } else {
            prefs.setString('user', cript.encrypt(phone));

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext ctx) => HomePage()));
          }
        } else if (userexist == false) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Identifiants invalides'),
              );
            },
          );
        }
        userexist = false;
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
          'Se connecter',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        openSignupPage(mobileNumber);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pas encore de compte?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'S\'inscrire ',
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

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Opi A',
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

  openSignupPage(String mobileNumber) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => new Register(mobileNumber: mobileNumber),
      ),
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
                  _phoneField(),
                  _passwordField(),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: new Text(
                      'Rester connecté',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    value: checkBoxValue,
                    checkColor: Color(0xfff3f3f4),
                    activeColor: Color(0xff6497b1),
                    onChanged: (bool value) {
                      setState(() {
                        checkBoxValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  _loginButton(),
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
