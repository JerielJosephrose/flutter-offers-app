import 'package:flutter/cupertino.dart';

/*
* Class containing all the user's contact
*
* */

class Contact {
  int id;
  String id_user;
  String phone;
  String email;
  String facebook;
  String skype;
  String instagram;
  String twitter;
  String linkedin;

  Contact(
      {this.id,
      this.id_user,
      this.phone,
      this.email,
      this.facebook,
      this.skype,
      this.instagram,
      this.twitter,
      this.linkedin});

  @override
  String toString() {
    return 'Contact{id: $id, id_user: $id_user, phone: $phone, email: $email, facebook: $facebook, skype: $skype, instagram: $instagram, twitter: $twitter, linkedin: $linkedin}';
  }

  //transforms a map into an object of type Contact
  factory Contact.fromMap(Map<String, dynamic> data) => new Contact(
        id: data['id'],
        id_user: data['id_user'],
        phone: data['phone'],
        email: data['email'],
        facebook: data['facebook'],
        skype: data['skype'],
        instagram: data['instagram'],
        twitter: data['twitter'],
        linkedin: data['linkedin'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "id_user": id_user,
        "phone": phone,
        "email": email,
        "facebook": facebook,
        "skype": skype,
        "instagram": instagram,
        "twitter": twitter,
        "linkedin": linkedin,
      };
}

class ContactValue {
  String title;
  String value;
  Image imageicon;

  ContactValue(this.title, this.imageicon);

  @override
  String toString() {
    return 'Contacts{title: $title, value: $value}';
  }

  void setvalue(String instagram) {}
}
