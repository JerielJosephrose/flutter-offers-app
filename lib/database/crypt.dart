import 'package:encrypt/encrypt.dart';

/// class that encrypts the phone number entered by the user when registering

class Crypt {

  //encrypt method with the phone number in parameter as String
  encrypt(String telephone) {
    final key = Key.fromLength(32);
    final iv = IV.fromLength(8);
    final encrypter = Encrypter(Salsa20(key));
    final encrypted = encrypter.encrypt(telephone, iv: iv);
    return encrypted.base64;
  }
}
