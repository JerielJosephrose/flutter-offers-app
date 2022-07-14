import 'dart:convert';

import 'package:annonce/database/database.dart';
import 'package:annonce/main.dart';
import 'package:annonce/model/contents.dart';
import 'package:annonce/widgets/icon_badge.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad/ad_list.dart';
import 'ad/ad_list_classifieds.dart';
import 'ad/ad_list_user.dart';
import 'ad/consult_ad_details.dart';
import 'ad/post/post_ad_category.dart';
import 'userDetails/contact_list.dart';
import 'util/CatList.dart';

/**
 *home page
 *
 * */

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchControl = new TextEditingController();
  JsonContent contentjson;
  Contents content;
  double longitude;
  double latitude;
  String codepostale = "";
  String Sprofil = '';

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Sprofil = prefs.get('profil').toString();
      print(Sprofil);
    });
  }

  void refreshData() {
    getStringValuesSF();
  }

  void tapped(int index) {
    if (index == 1) {
      print("taped index = 1");
    } else {
      print("taped index>1");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Flutter offers),
        backgroundColor: Color(0xff0b4e94),
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.notifications_none,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/opi_Drawer_Header.jpg"),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Accueil'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => new HomePage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.list,
                color: Colors.white,
              ),
              title: Text('Moyens de contact'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => new contact()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Déposer une annonce'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostAdCategory()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Mes annonces'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => new AdListUser()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Liste des annonces'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => new AdList()));
              },
            ),
            ListTile(
                leading: Icon(Icons.account_box),
                title: Text('Se déconnecter'),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('phone');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => MyApp()));
                }),
            SizedBox(
              height: 20,
            ),
          ],
        ), //
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PostAdCategory()));
        },
        child: const Icon(Icons.add_circle_outline),
        backgroundColor: Color(0xff0b4e94),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfffebedef),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Rechercher",
                      prefixIcon: Icon(
                        Icons.location_on,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    maxLines: 1,
                    controller: _searchControl,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Top Catégories",
                style: TextStyle(
                    color: Colors.black87.withOpacity(0.8),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 0),
                height: 140,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: catList == null ? 0 : catList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map cat = catList.reversed.toList()[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () {
                          openConsultationClassified(
                              int.parse("${cat["id"]}"), "${cat["name"]}");
                          print('tapped');
                        },
                        child: Container(
                          height: 250,
                          width: 140,
//                      color: Colors.green,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      /*Image.asset(
                                  "${cat["img"]}",
                                  height: 100,
                                  width: 250,
                                  fit: BoxFit.cover,
                                ),*/
                                      Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: <Widget>[
                                        Image.asset(
                                          "${cat["img"]}",
                                          height: 100,
                                          width: 250,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          "${cat["name"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ])),
                              SizedBox(height: 7),
                              /* Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${cat["name"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                child: FutureBuilder<List<Contents>>(
                  future: DBProvider.db.getAllContents(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Contents>> snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = snapshot.data[index];
                              content = item;
                              String sdate = item.date_insert;
                              sdate = convertDateFromString(sdate);
                              String jsonstring = jsonDecode(item.json_content);
                              String guillemet = '"';
                              String start =
                                  '{' + guillemet + 'fields' + guillemet + ':[';
                              String end = ']}';
                              jsonstring = jsonstring.replaceAll('[', start);
                              jsonstring = jsonstring.replaceAll(']', end);
                              JsonContent cntj = new JsonContent.fromJson(
                                  jsonDecode(jsonstring));
                              contentjson = cntj;
                              String titre;

                              for (int i = 0; i < cntj.fields.length; i++) {
                                if (cntj.fields[i].key.toString() == "titre") {
                                  titre = cntj.fields[i].value.toString();
                                  print(titre);
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: InkWell(
                                  child: Container(
                                    height: 70,
                                    child: Row(
                                      children: <Widget>[
                                        /*Expanded(
                                          child: Image.asset(
                                            "images/no_image.png",
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),*/
                                        SizedBox(width: 15),
                                        Container(
                                          height: 80,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              130,
                                          child: ListView(
                                            primary: false,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  titre,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.date_range,
                                                    size: 13,
                                                    color: Colors.blueGrey[300],
                                                  ),
                                                  SizedBox(width: 3),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      sdate,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: Colors
                                                            .blueGrey[300],
                                                      ),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    final item = snapshot.data[index];
                                    content = item;
                                    String sdate = item.date_insert;
                                    sdate = convertDateFromString(sdate);
                                    String jsonstring =
                                        jsonDecode(item.json_content);
                                    // print(jsonstring);
                                    // new Image.asset('images/no_image.png'),
                                    String quot = '"';
                                    String start =
                                        '{' + quot + 'fields' + quot + ':[';
                                    String end = ']}';
                                    jsonstring =
                                        jsonstring.replaceAll('[', start);
                                    jsonstring =
                                        jsonstring.replaceAll(']', end);
                                    JsonContent cntj = new JsonContent.fromJson(
                                        jsonDecode(jsonstring));
                                    contentjson = cntj;
                                    String titre;
                                    for (int i = 0;
                                        i < cntj.fields.length;
                                        i++) {
                                      if (cntj.fields[i].key.toString() ==
                                          "titre") {
                                        titre = cntj.fields[i].value.toString();
                                        print(titre);
                                      }
                                    }
                                    openConsultation(contentjson, content);
                                    ;
                                  },
                                ),
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ), //
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  openConsultationClassified(int catid, String cattitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            new AdListClassified(id: catid, title: cattitle),
      ),
    );
  }

  openConsultation(JsonContent contentJson, Contents content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            new ConsultAd(contentjson: contentJson, content: content),
      ),
    );
  }
}

// format date display
String convertDateFromString(String strDate) {
  DateTime todayDate = DateTime.parse(strDate);
  return strDate =
      formatDate(todayDate, [dd, '/', mm, '/', hh, ':', nn]).toString();
}

