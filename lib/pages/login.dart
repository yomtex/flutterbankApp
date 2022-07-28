import 'dart:io';

import 'package:bankapp/controller/api.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'dart:convert';

//import 'HomePage.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
 bool _isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String message='';
  //SharedPreferences sharedPreferences;
  @override
  initState() {
    //read();
  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(237, 237, 237, 245),
        // appBar: AppBar(
        //   backgroundColor: Colors.purple,
        //   title: Text("Login Page"),
        // ),
        body: SingleChildScrollView(
          //_isLoading ? Center(child: CircularProgressIndicator()):Text(message)

          child:_isLoading ? Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/2.2,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   CircularProgressIndicator(
                     valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                   ),
                 ],
               ),
            ],
          ): Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/8,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.purple, fontSize: 25, fontFamily: 'times new roman'),
                    ),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.always, key: formkey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: username,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email/Username',
                                  hintText: 'Enter valid username'),
                              validator: (value){
                              if(value!.isEmpty){
                                return "Required";
                              }
                              },

                          ),
                        ),
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 15, bottom: 0),
                          child: TextFormField(
                            controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  hintText: 'Enter secure password'),
                            validator: (value){
                              if(value!.isEmpty){
                                return "Required";
                              }else if(value.length < 6){
                                return "Password too short";
                              }
                            },
                            //validatePassword,        //Function to check validation
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            //TODO FORGOT PASSWORD SCREEN GOES HERE

                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(message)),
                        ),
                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(20)),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _isLoading= true;
                              });
                              if (formkey.currentState!.validate()) {
                                var uname = username.text;
                                var upass = password.text;
                                signIn(uname,upass);

                                //print(uname);
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (_) => HomePage()));
                                // print("Validated");
                                //Navigator.pushReplacementNamed(context, '/dashboard');
                              } else {
                              setState(() {
                                _isLoading=false;
                              message = "";
                              });
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Text('New User? Create Account')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  signIn(String username,upass)async{

    String serverUrl = "http://laravel.teletradeoptions.com/api/auth/login";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'username':username,
      'password':upass
    };

    var jsonResponse=null;
    var response = await http.post(serverUrl,body:data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      //print('data : ${response.body}');
     //print('data : ${response.body}');
     print(response.body);
     var decode = jsonDecode(response.body);
     var msg= decode["msg"];
     if(msg == "success"){
       getUser();
       setState((){
         message = "";
         _isLoading = false;
       });
       sharedPreferences.setString("token", decode["token"]);
      //
       //
     }else{
       setState((){
         message = "invalid credentials";
         _isLoading = false;
       });
     }

  }
  }

getUser()async{
  String serverUrl = "http://laravel.teletradeoptions.com/api/auth/user-profile";
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if(sharedPreferences.getString("token")==null){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Login()), (Route<dynamic> route) => false);
  }else{
    var token  = sharedPreferences.getString("token");
    var response = await http.get(serverUrl, headers: {"Authorization": "Bearer $token"});
    print(response.body);
  }

}

}