import 'dart:convert';

import 'form.dart';

class Contents {
  int id_content;
  int id_form;
  String json_content;
  String latitude;
  String longitude;
  String date_insert;
  String contact;
  String id_user;

  Contents(
      {this.id_content,
      this.id_form,
      this.json_content,
      this.latitude,
      this.longitude,
      this.date_insert,
      this.contact,
      this.id_user});

  factory Contents.fromJson(Map<String, dynamic> Json) {
    return Contents(
      id_content: Json['id_content'],
      id_form: Json['id_form'],
      json_content: jsonEncode(Json['json_content']),
      latitude: Json['latitude'],
      longitude: Json['longitude'],
      date_insert: Json['date_insert'],
      contact: Json['contact'],
      id_user: Json['id_user'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_content": id_content,
        "id_form": id_form,
        "json_content": json_content,
        "latitude": latitude,
        "longitude": longitude,
        "date_insert": date_insert,
        "contact": contact,
        "id_user": id_user,
      };

  factory Contents.fromMap(Map<String, dynamic> data) => new Contents(
        id_content: data['id_content'],
        id_form: data['id_form'],
        json_content: jsonEncode(data['json_content']),
        latitude: data['latitude'],
        longitude: data['longitude'],
        date_insert: data['date_insert'],
        contact: data['contact'],
        id_user: data['id_user'],
      );

  Map<String, dynamic> toMap() => {
        "id_content": id_content,
        "id_form": id_form,
        "json_content": json_content,
        "latitude": latitude,
        "longitude": longitude,
        "date_insert": date_insert,
        "contact": contact,
        "id_user": id_user,
      };
}

class JsonContent {

  List<Fields> fields;
  JsonContent({this.fields});

  factory JsonContent.fromJson(Map<String, dynamic> Json) {
    return JsonContent(
      fields: parseFields(Json),
    );
  }

  static List<Fields> parseFields(fieldsJson) {
    var list = fieldsJson['fields'] as List;
    List<Fields> fieldsList =
        list.map((data) => Fields.fromJson(data)).toList();
    return fieldsList;
  }

  Map<String, dynamic> toJson() => {
        "fields": fields,
      };
}
