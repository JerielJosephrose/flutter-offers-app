import 'dart:async';
import 'dart:io';
import 'package:annonce/model/categories.dart';
import 'package:annonce/model/contact.dart';
import 'package:annonce/model/contents.dart';
import 'package:annonce/model/form.dart';
import 'package:annonce/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;

  DBProvider();

  DBProvider._();

  static final DBProvider db = DBProvider._();

  Future<Database> get database async {
    // if db exist => return db
    if (_database != null) {
      return _database;
    }
    //if db don't exist => create db
    _database = await initDB();
    return _database;
  }

  // Initialise the data base
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'leboncoin.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(TABLE_APP);
          await db.execute(Style);
      await db.execute(Create_DB_USERS);
      await db.execute(Create_DB_OPI_CLASSES);
      await db.execute(Create_DB_OPI_FORMS);
      await db.execute(Create_DB_OPI_CONTENTS);
      await db.execute(Create_DB_CONTACT);
    });
  }


  // table app containing application information
  final String TABLE_APP= "CREATE TABLE app ("
      "id_app INTEGER,"
      "nom_app TEXT,"
      "description_app TEXT,"
      "selected  INT"
      ")";

  //table style contenant le style de l'application
  final String Style = "CREATE TABLE Style ("
      "id_app integer,"
      "style TEXT"
      ")";


  // TABLE USERS  containing  user's identifiers and account creation date
  final String Create_DB_USERS = "CREATE TABLE User ("
      "id TEXT PRIMARY KEY,"
      "username TEXT,"
      "password TEXT,"
      "date_insert TEXT"
      ")";

  // TABLE CATEGORIES
  final String Create_DB_OPI_CLASSES = "CREATE TABLE opi_classes ("
      "id integer PRIMARY KEY,"
      "id_parent_class INTEGER,"
      "label TEXT" // title_form
      ")";

  //table containing all forms
  final String Create_DB_OPI_FORMS = "CREATE TABLE opi_forms ("
      "id integer PRIMARY KEY,"
      "label TEXT,"
      "fields TEXT"
      ")";

  // table containing all the forms entered by users
  final String Create_DB_OPI_CONTENTS = "CREATE TABLE opi_contents ("
      "id_content INTEGER PRIMARY KEY AUTOINCREMENT,"
      "id_form integer,"
      "json_content TEXT,"
      "latitude TEXT,"
      "longitude TEXT,"
      "date_insert TEXT,"
      "contact TEXT,"
      "id_user TEXT"
      ")";

  // TABLE contact, 1 by user
  final String Create_DB_CONTACT = "CREATE TABLE moyen_contact ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "id_user TEXT,"
      "phone TEXT,"
      "email TEXT,"
      "facebook TEXT,"
      "skype TEXT,"
      "instagram TEXT,"
      "twitter TEXT,"
      "linkedin TEXT"
      ")";

  //
  addContactToDatabase(Contact contact) async {
    final db = await database;
    var raw = await db.insert(
      "moyen_contact",
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  // modification of contacts
  Future<int> updateContact(Contact contact) async {
    var db = await this.database;
    var result = await db.update('moyen_contact', contact.toMap(),
        where: 'id_user = ?', whereArgs: [contact.id_user]);
    return result;
  }

  // get contact by user_id
  Future<Contact> getContactById(String id) async {
    final db = await database;
    var response =
        await db.query("moyen_contact", where: "id_user = ?", whereArgs: [id]);
    return response.isNotEmpty ? Contact.fromMap(response.first) : null;
  }


  // USER
  addUserToDatabase(User user) async {
    final db = await database;
    var raw = await db.insert(
      "User",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<User> getUserWithId(int id) async {
    final db = await database;
    var response = await db.query("User", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? User.fromMap(response.first) : null;
  }


  updateUser(User user) async {
    final db = await database;
    var response = await db
        .update("User", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    return response;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    var response = await db.query("User");
    List<User> list = response.map((c) => User.fromMap(c)).toList();
    return list;
  }

  deleteAllUsers() async {
    final db = await database;
    db.delete("User");
  }

  Future<User> getUserWithName(String username) async {
    final db = await database;
    var response =
        await db.query("User", where: "username = ?", whereArgs: [username]);
    return response.isNotEmpty ? User.fromMap(response.first) : null;
  }

  deleteUserWithId(int id) async {
    final db = await database;
    return db.delete("User", where: "id = ?", whereArgs: [id]);
  }

  // Insert Categorie on database
  createCategorie(Categories newCategories) async {
    await deleteAllCategories();
    final db = await database;
    final res = await db.insert('opi_classes', newCategories.toJson());
    return res;
  }

  // Delete all Categories
  Future<int> deleteAllCategories() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM opi_classes');
    return res;
  }

  Future<int> deleteAllContents() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM opi_contents');
    return res;
  }

  Future<List<Categories>> getAllCategories() async {
    final db = await database;
    var response = await db.query("opi_classes");
    List<Categories> list =
        response.map((c) => Categories.fromJson(c)).toList();
    return list;
  }

  Future<List<Forms>> getAllForms() async {
    final db = await database;
    var response = await db.query("opi_forms");
    List<Forms> list = response.map((c) => Forms.fromJson(c)).toList();
    return list;
  }

  // Insert Categorie on database
  createFormulaires(Forms newForm) async {
    await deleteAllForms();
    final db = await database;
    final res = await db.insert('opi_forms', newForm.toJson());
    return res;
  }

  // get formulaire by id
  Future<Forms> getFormulaireWithId(int id) async {
    final db = await database;
    var response =
        await db.query("opi_forms", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Forms.fromJson(response.first) : null;
  }

  // Delete all Categories
  Future<int> deleteAllForms() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM opi_forms');
    return res;
  }

  // get categories by id
  Future<Categories> getCategoriesWithId(int id) async {
    final db = await database;
    var response =
        await db.query("opi_forms", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Categories.fromJson(response.first) : null;
  }


// add form entered by the user
  addContentsToDatabase(Contents contents) async {
    final db = await database;
    var raw = await db.insert(
      "opi_contents",
      contents.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //CONTENTS
  Future<List<Contents>> getAllUserContentsbyId(String id_user) async {
    final db = await database;
    var response = await db
        .query("opi_contents", where: "id_user = ?", whereArgs: [id_user]);
    List<Contents> list = response.map((c) => Contents.fromMap(c)).toList();
    return list;
  }


  // method for obtaining ads by classification
  Future<List<Contents>> getAllContentsbyId(int id_form) async {
    final db = await database;
    var response = await db
        .query("opi_contents", where: "id_form = ?", whereArgs: [id_form]);
    List<Contents> list = response.map((c) => Contents.fromMap(c)).toList();
    return list;
  }

  // update content
  updateContents(Contents content) async {
    final db = await database;
    var response = await db.update("opi_contents", content.toMap(),
        where: "id_content = ?", whereArgs: [content.id_content]);
    return response;
  }

  //CONTENTS
  Future<List<Contents>> getAllContents() async {
    final db = await database;
    var response = await db.query("opi_contents");
    List<Contents> list = response.map((c) => Contents.fromMap(c)).toList();
    return list;
  }

  //  detelete an ad
  deleteContentWithId(int id) async {
    final db = await database;
    return db.delete("opi_contents", where: "id_content = ?", whereArgs: [id]);
  }

  // insertion of an ad
  createContents(Contents newContent) async {
    await deleteAllForms();
    final db = await database;
    final res = await db.insert('opi_forms', newContent.toJson());
    return res;
  }

}
