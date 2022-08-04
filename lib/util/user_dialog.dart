import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../pages/login.dart';

class UserTransfer extends StatefulWidget {
  const UserTransfer({Key? key}) : super(key: key);

  @override
  State<UserTransfer> createState() => _UserTransferState();
}

class _UserTransferState extends State<UserTransfer> {
  bool _isLoading = false;
  bool _isVisible = false;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController details = TextEditingController();
  String message=' ';
  String message2=' ';
  String success=' ';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(hintText: "Enter username"),
                onChanged: (value) => {
                  if(value.isEmpty){
                    print("empty"),
                  }else{
                    receiver(value),
                    _isLoading=true,
                  }
                  },

              ),
            ),

            _isLoading?Container(child: CircularProgressIndicator(),):Text(message.toString()),
            //_isLoading?Container(child: CircularProgressIndicator(),):Text(message2.toString()),
            Visibility(
              visible: _isVisible,
              child: Form(
                key:_formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          readOnly: true,
                          initialValue: success.toString(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '',
                              hintText: ''),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Required";
                            }
                          },

                        ),
                      ),
                      SizedBox(height: 15,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            TextInputFormatter.withFunction(
                                  (oldValue, newValue) => newValue.copyWith(
                                text: newValue.text.replaceAll('.', ','),
                              ),
                            ),
                          ],
                          keyboardType: TextInputType.numberWithOptions(decimal:true),
                          onChanged:(value)=>transfer_rates() ,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Amount',
                              hintText: 'Amount'),
                          validator: (value){
                            if(value!.isEmpty){
                              return "Required";
                            }
                          },

                        ),
                      ),
                      SizedBox(height: 15,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: details,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description',
                              hintText: 'Description'),
                        ),
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
              ),
            ),
        ],//
        ),)
    );
  }

  receiver(String value)async {
  if(value.isEmpty){
    message = "Field cannot be empty";
  }else{
    String serverUrl = "http://laravel.teletradeoptions.com/api/auth/search-user";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    Map data = {
      'reciever':value
    };
    var response = await http.post(serverUrl,body:data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $prefs'
    });
    if(response.statusCode >= 200 && response.statusCode<= 299){
      var responseDecode = jsonDecode(response.body);
      //message = value;
      setState((){
        _isLoading =false;
        if(responseDecode["msg"] == "success"){
          print(responseDecode);
          message2= responseDecode["isPrivate"];
          if(message2 == 1){
            message="";
            success= responseDecode["username"];
          }else{
            success= responseDecode["fullname"];
              message="";
          }
          _isVisible=true;
        }else{
          message=responseDecode["msg"];
          _isVisible=false;
        }
      });
    }else if(!(response.statusCode >= 200 && response.statusCode<= 299)){

      sharedPreferences.remove("token");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
              (Route<dynamic> route) => false);
    }
    else{
      setState((){
        _isLoading =false;
        message= "user not found";
        _isVisible=false;
        message2= " ";
      });
    }
  }
}

  transfer_rates()async {}

}

