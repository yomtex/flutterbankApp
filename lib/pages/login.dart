import 'package:bankapp/controller/api.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

//import 'HomePage.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  read() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'token';
  final value = prefs.get(key) ?? 0;
  if (value != '0') {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new HomePage(),
    ));
  }
}
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String message='';

  @override
  initState() {
    read();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(237, 237, 237, 245),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.always, key: formkey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 100,),
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
                child: Center(child: Text(message)),
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
                      message = "Please wait";
                    });
                    if (formkey.currentState!.validate()) {
                      var uname = username.text;
                      var upass = password.text;
                      AuthController auth = new AuthController();
                      (auth.loginUser(uname, upass));

                      //print(uname);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (_) => HomePage()));
                      // print("Validated");
                      //Navigator.pushReplacementNamed(context, '/dashboard');
                    } else {
                    setState(() {
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
      ),
    );
  }
}