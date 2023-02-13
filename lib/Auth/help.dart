import 'package:shared_preferences/shared_preferences.dart';

class helper_functions {

  static String userloggenin = "USERLOGGENIN";
  static String username = "USERNAME";
  static String useremailkey = "USEREMAILKEY";
  static String uid = "UID";

  static Future<bool> saveuserloggin(bool userloggedins) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userloggenin, userloggedins); 
  }

  static Future<bool> saveusername(String usernames) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(username , usernames);
  }

  static Future<bool> saveemail(String emails) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(useremailkey, emails);
  }



  static Future<bool?> getUserLoggedInStatus() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userloggenin);
  }

  static Future<String?> getusernamefromSF () async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(username);
  }

  static Future<String?> getemailfromSF () async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(useremailkey);
  }


  static Future<String?> getuidfromSF () async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(uid);
  }


  static Future<bool?> saveuid (String uids) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(uid , uids);
  }


}