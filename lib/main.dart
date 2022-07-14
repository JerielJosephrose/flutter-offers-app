import 'dart:async';
import 'package:annonce/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'database/api_provider.dart';
import 'view/authentification/login.dart';


/**
 * application main class
 *
 * */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var phone = prefs.getString('phone');
  print(phone);

//If the user clicked stay connected => opent Home, else =>open Myapp => loginPage
  runApp(MaterialApp(home: phone == null ? MyApp() : HomePage()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  String mobileNumber = '';
  var apiProvider = FormsApiProvider();
  var ApiProvider2 = CategoriesApiProvider();
  var ApiProvider3 = CreateData();

  //insert some ads in the database at the first installation
  Future checkData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool CheckValue = prefs.containsKey('data');
    if (!CheckValue) {
      ApiProvider3.createData();
      prefs.setBool('data', true);
    }
  }

  //opens the login page with the recovered telephone number
  Widget openLoginPage(String mobileNumber) {
    return (new Login(mobileNumber: mobileNumber));
  }


  @override
  Future<void> initState() {
    ApiProvider2.CreateCat();
    apiProvider.CreateForm();
    checkData();
    super.initState();
  }

  //try to retrieve the phone number
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }

    try {
      mobileNumber = await MobileNumber.mobileNumber;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    if (!mounted) return;
    setState(() {
      mobileNumber = mobileNumber;
    });
  }

  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 2,
      navigateAfterSeconds: openLoginPage(mobileNumber),
      //navigateAfterSeconds: new HomePage(),
      title: new Text(
        'Bienvenue sur Opi annonces',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff0b4e94),
            fontSize: 20.0),
      ),
      loaderColor: Color(0xff0b4e94),
    );
  }
}
