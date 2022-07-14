import 'package:shared_preferences/shared_preferences.dart';

class preferences {

  // When a user logs in, their id is saved in the preferences in the user field
  // This allows to find the current user

  getUser(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    s = prefs.getString('user').toString();
    return s;
  }
}
