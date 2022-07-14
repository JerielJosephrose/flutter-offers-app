import 'dart:convert';

import 'package:annonce/database/database.dart';
import 'package:annonce/model/categories.dart';
import 'package:annonce/model/contents.dart';
import 'package:annonce/model/form.dart';
import 'package:flutter/services.dart';

import 'database.dart';

class CategoriesApiProvider {
  // insert categorie in db
  Future<List<Categories>> getAllCategories() async {
    var jsonString = await loadFromAssets();
    List jsonResponse = json.decode(jsonString);
    return (jsonResponse).map((categories) {
      DBProvider.db.createCategorie(Categories.fromJson(categories));
    }).toList();
  }

  // insert cat in db
  CreateCat() async {
    var jsonString = await loadFromAssets();
    List jsonResponse = json.decode(jsonString);
    jsonResponse = (jsonResponse).map((form) {
      DBProvider.db.createCategorie(Categories.fromJson(form));
    }).toList();
  }
}

class FormsApiProvider {
  // search form by id
  Future<Forms> getForm(id) async {
    return DBProvider.db.getFormulaireWithId(id);
  }

  // insert form in db
  CreateForm() async {
    var jsonString = await loadFromAssets();
    List jsonResponse = json.decode(jsonString);
    jsonResponse = (jsonResponse).map((form) {
      DBProvider.db.createFormulaires(Forms.fromJson(form));
    }).toList();
  }
}

class CreateData {
// Insert some contents in db
  createData() async {
    String jsonString = await loadFromJsonProf();
    String jsonString2 = await loadFromJsonMaison();
    String jsonString3 = await loadFromJsonVoiture();
    String jsonString4 = await loadFromJsonvetement();

    DBProvider.db.addContentsToDatabase(new Contents(
        id_form: 1,
        json_content: jsonString,
        latitude: "48.866667",
        longitude: " 2.333333",
        date_insert: "2020-06-04 12:51:31.320176",
        contact: 'email : xxxx@xxxx.com',
        id_user: 'da54'));

    DBProvider.db.addContentsToDatabase(new Contents(
        id_form: 3,
        json_content: jsonString3,
        latitude: "50.6316211",
        longitude: " 3.1533357",
        date_insert: "2020-06-05 11:15:25.021653",
        contact: ' telephone : 0xxx15x156',
        id_user: 'da54'));

    DBProvider.db.addContentsToDatabase(new Contents(
        id_form: 14,
        json_content: jsonString2,
        latitude: "48.866667",
        longitude: " 2.333333",
        date_insert: "2020-05-04 18:54:31.132645",
        contact: 'email : xxxx@xxxx.com',
        id_user: 'da54'));

    DBProvider.db.addContentsToDatabase(new Contents(
        id_form: 36,
        json_content: jsonString4,
        latitude: "48.866667",
        longitude: " 2.333333",
        date_insert: "2020-05-04 18:54:31.132645",
        contact: 'email : xxxx@xxxx.com',
        id_user: 'da54'));
  }
}

Future<String> loadFromAssets() async {
  return await rootBundle.loadString('jsons/categories.json');
}

Future<String> loadFromJsonProf() async {
  return await rootBundle.loadString('jsons/prof.json');
}

Future<String> loadFromJsonMaison() async {
  return await rootBundle.loadString('jsons/maison.json');
}

Future<String> loadFromJsonVoiture() async {
  return await rootBundle.loadString('jsons/voiture.json');
}

Future<String> loadFromJsonvetement() async {
  return await rootBundle.loadString('jsons/vetements');
}
