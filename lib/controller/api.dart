import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController{
  String serverUrl = "http://laravel.teletradeoptions.com/api";
  var status ;

  var token ;

  loginUser(String email , String password)async{

    String myUrl = "$serverUrl/login";
    final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: {
          "username": email,
          "password" : password
        });
    status = response.body.contains('msg');
    var data = json.decode(response.body);

    if(status){
      print('data : ${data["token"]}');
      _save(data["token"]);
    }else{
      print("invalid");
    }
  }
//Saving token per login
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
   print(prefs.setString(key, value));
  }

  // Read store token
  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;
    print('read : $value');
  }

  Future<List> getData() async{

    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    String myUrl = "$serverUrl/user";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Bearer $value'
        });
    return json.decode(response.body);
  }

}