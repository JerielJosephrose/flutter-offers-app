import 'dart:convert';

class Forms {
  int id;
  String label;
  String fields;

  Forms({this.id, this.label, this.fields});

  factory Forms.fromJson(Map<String, dynamic> Json) {
    return Forms(
      id: Json['id'],
      label: Json['label'],
      fields: jsonEncode(Json['fields']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "fields": fields,
      };
}

class Fields {
  String key;
  String label;
  var value;
  String type;
  Fields({this.key, this.value, this.type, this.label});

  factory Fields.fromJson(Map<String, dynamic> Json) {
    return Fields(
      key: Json['key'],
      value: Json['value'],
      label: Json['label'].toString(),
      type: jsonEncode(Json['type']),
    );
  }

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "label": label,
         "type": type,
      };
}
