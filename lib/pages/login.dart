import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../util/networkStatus.dart';
import 'dashboard.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  bool _isVisible = false;
  bool _isLoading = false;
  bool appLoad = true;
  bool _isSeen = true;
  bool _loading_container = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String message='';
  String validUser=' ';
  //SharedPreferences sharedPreferences;
  loading()async{
    Timer(Duration(seconds: 5), () {
      setState((){
        _isVisible = true;
        appLoad = false;
      });
    });
  }
  //connection
  bool? _isConnectionSuccessful;

  _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      });
    } on SocketException catch (e) {
      setState(() {
        print("No connection");
        // _isConnectionSuccessful = false;
      });
    }
  }
    //coonection close
  @override
  initState() {
    _tryConnection();
    loading();
  }
  Widget build(BuildContext context) {
    return appLoad?Container(
      width: MediaQuery.of(context).size.width,
      height:double.infinity,
      decoration: BoxDecoration(color: Colors.purple
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height/2,),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)),
              ),
            ],
          ),
        ],
      ),
    ): SafeArea(
      child:  Scaffold(
        backgroundColor: Color.fromARGB(237, 237, 237, 245),
        body: SingleChildScrollView(
          child:Visibility(
            visible: _isVisible,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/10,),
                    Container(
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.purple,
                        child: Icon(Icons.person,size: 80,),),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 35, fontFamily: 'times new roman'),
                      ),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.always, key: formkey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: TextFormField(
                              controller: username,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email/Username',
                                  hintText: 'Enter valid username'),
                              validator: (value){
                                validUser="";
                                if(value!.isEmpty){
                                    //_isVisible = false;
                                    return "Enter a valid username";
                                }else if(!RegExp(r'^[a-z A-Z]+$').hasMatch(value) && !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])[A-Za-z0-9]+$').hasMatch(value)){

                                    //_isVisible = false;
                                    return "Enter a valid username";
                                }
                                else if(value.length < 6){
                                    //_isVisible = false;
                                    return "Enter a valid username";
                                }
                                else{
                                  return null;
                                }
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(validUser,style: TextStyle(color: Colors.red),),
                          ),

                          SizedBox(height: 0,),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 10, bottom: 0),
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
                                }else{return null;}
                              },
                              //validatePassword,        //Function to check validation
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  //TODO FORGOT PASSWORD SCREEN GOES HERE

                                },
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(color: Colors.blue, fontSize: 15),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  //TODO FORGOT PASSWORD SCREEN GOES HERE

                                },
                                child: Text(
                                  "Don\'t have an account ? click here",
                                  style: TextStyle(color: Colors.blue, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(message,style: TextStyle(color: Colors.red),)),
                          ),
                          Visibility(
                            visible: _isSeen,
                            child: Container(
                              margin: EdgeInsets.all(0),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _tryConnection();
                                    if(_isConnectionSuccessful==null){
                                      _isLoading=false;
                                      message = "No connection";
                                    }else{


                                      var network = Network();

                                      appLoad= true;
                                      if (formkey.currentState!.validate()) {
                                        var uname = username.text;
                                        var upass = password.text;
                                        signIn(uname,upass);
                                      } else {
                                        setState(() {
                                          _isLoading=false;
                                          message = "";
                                        });
                                      }
                                    }
                                  });
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  signIn(String username,upass)async{
  try{
    _isLoading= true;
    var serverUrl = Uri.parse("https://laravel.teletradeoptions.com/api/auth/login");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    Map data = {
      'username':username,
      'password':upass
    };

    var jsonResponse=null;
    var response = await http.post(serverUrl,body:data);
    if((response.statusCode >= 200 && response.statusCode<= 299)) {
      jsonResponse = json.decode(response.body);
      //print('data : ${response.body}');
      //print('data : ${response.body}');
      //print(response.body);
      var decode = jsonDecode(response.body);
      var msg= decode["msg"];
      if(msg == "success"){
        //getUser();
        setState((){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Dashboard()), (Route<dynamic> route) => false);
          message = "";
          _isLoading = false;
        });
        sharedPreferences.setString("token", decode["token"]);
        //
        //
      }else{
        setState((){
          appLoad=false;
          message = "invalid credentials";
          _isLoading = false;
        });
      }

    }else{
      message = "Something went wrong, try later";
      _isLoading = false;
    }
  }catch(e){
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Connection.')));
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Login()), (Route<dynamic> route) => false);
  }
  }

  getUser()async{
    var serverUrl = Uri.parse("http://laravel.teletradeoptions.com/api/auth/user-profile");
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