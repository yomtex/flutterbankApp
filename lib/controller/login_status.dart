import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class LoginStatus{
  Future status()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    var url = Uri.parse("https://laravel.teletradeoptions.com/api/auth/user-profile");
    http.Response response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $prefs'
    });

    //var responsedata = json.decode(response.body);
    //var errMsg = (responsedata["message"]);
    if (!(response.statusCode >= 200 && response.statusCode <= 299)) {
      //means user logged out or session expires
      //return user to login page
      sharedPreferences.remove("token");
      print (0);
    }
  }


}
