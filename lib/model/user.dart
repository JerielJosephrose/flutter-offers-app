
/*
* classe modele des user
* */

class User {
  String id;
  String password;
  String date_insert;

  User({this.id, this.password, this.date_insert});

  factory User.fromJson(Map<String, dynamic> json) => new User(
        id: json['id'],
        password: json['password'],
        date_insert: json['date_insert'],
      );

  @override
  String toString() {
    return 'User{id: $id, password: $password, date_insert: $date_insert}';
  }

  factory User.fromMap(Map<String, dynamic> data) => new User(
        id: data['id'],
        password: data['password'],
        date_insert: data['date_insert'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "password": password,
        "date_insert": date_insert,
      };
}
