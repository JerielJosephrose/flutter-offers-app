import 'dart:convert';

import 'package:annonce/database/database.dart';
import 'package:annonce/model/contents.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import 'consult_ad_details_user.dart';





/*
*class displaying the list of current user's ads
* */






class AdListUser extends StatefulWidget {
  @override
  _AdListUserState createState() => _AdListUserState();
}

class _AdListUserState extends State<AdListUser> {
  JsonContent contentjson;
  Contents content;
  String id_user = '';

  @override
  void didUpdateWidget(AdListUser oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  void initState() {
    getStringValuesSF();

    super.initState();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prof = prefs.getString('user');
    setState(() {
      id_user = prof;
      print(id_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes annonces"),
        backgroundColor: Color(0xff0b4e94),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            child: FutureBuilder<List<Contents>>(
              future: DBProvider.db.getAllUserContentsbyId(id_user),
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
                          JsonContent cntj =
                              new JsonContent.fromJson(jsonDecode(jsonstring));
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
                                    /* Expanded(
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
                                      width: MediaQuery.of(context).size.width -
                                          130,
                                      child: ListView(
                                        primary: false,
                                        physics: NeverScrollableScrollPhysics(),
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
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  sdate,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.blueGrey[300],
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
                                String guillemet = '"';
                                String start = '{' +
                                    guillemet +
                                    'fields' +
                                    guillemet +
                                    ':[';
                                String end = ']}';
                                jsonstring = jsonstring.replaceAll('[', start);
                                jsonstring = jsonstring.replaceAll(']', end);
                                JsonContent cntj = new JsonContent.fromJson(
                                    jsonDecode(jsonstring));
                                contentjson = cntj;
                                String titre;

                                for (int i = 0; i < cntj.fields.length; i++) {
                                  if (cntj.fields[i].key.toString() ==
                                      "titre") {
                                    titre = cntj.fields[i].value.toString();
                                    print(titre);
                                  }
                                }

                                openDetailsAdUser(contentjson, content);
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
          ),
        ]),
      ),
    );
  }

  openDetailsAdUser(JsonContent contentJson, Contents content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            new ConsultAdUser(contentjson: contentJson, content: content),
      ),
    );
  }
}
