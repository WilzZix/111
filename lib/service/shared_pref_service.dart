import 'package:shared_preferences/shared_preferences.dart';

class SharePrefService {
  static Future<String> getUserAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')!;
  }
}
