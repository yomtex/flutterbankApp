import 'dart:async';

import 'package:bankapp/util/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../controller/login_status.dart';
import '../pages/login.dart';

class UserTransfer extends StatefulWidget {
  const UserTransfer({Key? key}) : super(key: key);

  @override
  State<UserTransfer> createState() => _UserTransferState();
}

class _UserTransferState extends State<UserTransfer> {
  bool _isLoading = false;
  bool _isVisible = false;
  bool _is_local=false;
  bool sendBtn = false;
  bool initialVal = false;
  String success=' ';
  String username_receiver='';
  GlobalKey<FormState> _local_formkey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController local_amount = TextEditingController();
  TextEditingController local_description = TextEditingController();
  String message=' ';
  String message2=' ';
  String charges=' ';
  String? lreceiver_uname,lamount_charged,lsend_amount;

  @override
  initState()  {
    var checkstatus =new LoginStatus();
    var _active = checkstatus.status();
    print(_active);

  }
  final timer =
  Timer(const Duration(seconds: 0), () => print('Timer finished'));
// Cancel timer, callback never called.

  Widget build(BuildContext context) {
    final _local_amount = TextEditingController();
    return Dialog(
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 10, 5),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(hintText: "Enter username"),
                onChanged: (value) => {
                  setState((){
                    sendBtn =false;
                    _isVisible = false;
                    _is_local = false;
                    local_amount.clear();
                    message="";
                    charges = "";
                    _isLoading=true;
                    if(value.isEmpty){
                    print("empty");
                    _isLoading = false;
                    }else if(value.length < 3){
                    message ="Too short";
                    _isLoading = false;
                    }
                    else{
                      _isLoading = true;
                      message ="";
                      Future.delayed(Duration(seconds: 2),(){

                      receiver(value);
                      });
                    }
                  }),
                  },

              ),
            ),

            _isLoading?Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const Center(
                child: CircularProgressIndicator(semanticsLabel: 'loading', valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),),
              ),
            ):
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                message.toString(),style:
              TextStyle(color: Colors.red),
              ),
            ),
            //_isLoading?Container(child: CircularProgressIndicator(),):Text(message2.toString()),

            //first form widget for international transfer
            Visibility(
              visible: _isVisible,
              child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                          onChanged:(value)=>sendBtn=false,
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
            //first form widget close up

            //second form for local transfer
            Visibility(
              visible: _is_local,
              child: Form(
                key:_local_formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(success.toString()),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        onChanged: (value) => {
                          Timer(const Duration(seconds: 1),()
                          {
                            setState((){
                              _isLoading= true;
                              charges ="";
                              sendBtn=false;
                              timer.cancel();
                              if(value.isEmpty){
                              _isLoading=false;
                              sendBtn =false;
                              charges ="Minmum is 1000";
                              print("empty");
                              }else if(double.parse(value) < 1000){
                              _isLoading =false;
                              sendBtn =false;
                              charges ="Minmum is 1000";
                              }
                              else{
                              local_rates(value);
                              _isLoading=true;
                              sendBtn =false;
                              _isVisible=false;
                              }
                            });
                          }),
                        },
                        controller: local_amount,
                        inputFormatters: <TextInputFormatter>[
                          TextInputFormatter.withFunction(
                                (oldValue, newValue) => newValue.copyWith(
                              text: newValue.text.replaceAll('.', '.'),
                            ),
                          ),
                        ],
                        keyboardType: TextInputType.numberWithOptions(decimal:true),

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
                    Text(charges.toString()),
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

                    Visibility(
                      visible: sendBtn,
                      child: Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(

                          onPressed: () {
                            setState(() {
                              send_fund_local();
                              _isLoading= true;
                              sendBtn =false;
                              _is_local = false;
                              _isVisible = false;
                            });
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //second form close
        ],//
        ),)
    );
  }

  receiver(String value)async {
  if(value.length < 3){
    message = "Field cannot be empty";
  }else{
    var serverUrl = Uri.parse("https://laravel.teletradeoptions.com/api/auth/search-user");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    Map data = {
      'reciever':value
    };
    var response = await http.post(serverUrl,body:data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $prefs'
    });
    var responseDecode = jsonDecode(response.body);
    if(response.statusCode >= 200 && response.statusCode<= 299){
      var transfer_type = responseDecode["transfer_type"];
      if(transfer_type == "local"){
        message = "";
        setState((){
          _isLoading =false;
          if(responseDecode["msg"] == "success"){
            //print(responseDecode);
            message2= responseDecode["isPrivate"];
            if(message2 == "1"){
              message="";
              success= responseDecode["username"];
              username_receiver= responseDecode["username"];
              _local_receiver(username_receiver);
              lreceiver_uname=username_receiver;
            }else{
              username_receiver= responseDecode["username"];
              success= responseDecode["fullname"];
              _local_receiver(username_receiver);
              message="";
            }
            //message = "local";
            _isVisible=false;
            _is_local =true;

            print(transfer_type);
          }else{
            message=responseDecode["msg"];
            _isVisible=false;
            _is_local=false;
          }
        });
      }else{

        //message = value;
        setState((){
          _isLoading =false;
          if(responseDecode["msg"] == "success"){
            //print(responseDecode);
            message2= responseDecode["isPrivate"];
            if(message2 == "1"){
              message="";
              success= responseDecode["username"];
              //print(responseDecode);
            }else{
              success= responseDecode["fullname"];
              message="";
            }
            //message = "international";
            print(transfer_type);
            _isVisible=true;
            _is_local=false;
          }else{
            message=responseDecode["msg"];
            _isVisible=false;
            _is_local=false;
          }
        });
      }
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


  local_rates(String value)async {
    var serverUrl = Uri.parse("https://laravel.teletradeoptions.com/api/auth/transfer-charges");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    Map data = {
      'amount':value
    };
    var response = await http.post(serverUrl,body:data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $prefs'
    });
    var responseDecode = jsonDecode(response.body)["msg"];
    var limit = jsonDecode(response.body)["msg"].toString();
    print(responseDecode);
    if(response.statusCode >= 200 && response.statusCode<= 299){
      setState((){
        Future.delayed(Duration(seconds: 0),(){
          if(responseDecode == "Insufficient funds!"){
            _isLoading=false;
            charges =responseDecode;
            sendBtn =false;
            message =" ";
          }else if(responseDecode == "Minmum is 1000"){
            charges =responseDecode;
            sendBtn =false;
            _isLoading=false;
            message =" ";
          }else if(limit.contains("Limit")){
            charges =responseDecode;
            sendBtn =false;
            _isLoading=false;
            message =" ";
          }
          else{
            _isLoading=false;
            message = "";
            charges =responseDecode;
            var repDecde = jsonDecode(response.body);
            lsend_amount =  data["amount"];
            lamount_charged=(repDecde["charged_amount"]).toString();
            var _charges = (repDecde["charged_amount"]);
            var amount_entered= data["amount"];
            sendBtn =true;
             local_charges(_charges, amount_entered);
          }
        });
      });
    }else{
      sharedPreferences.remove("token");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
              (Route<dynamic> route) => false);
    }

  }
  _local_receiver(receiver){
    assert(receiver != null);
    setState((){
      return receiver;
    });
  }
  local_charges(amount,charged_amount)async{
     var user= _local_receiver(username_receiver);
      // print("$amount $charged_amount $username_receiver");
      // print(username_receiver);
      // send_fund_local();
      //message = "$amount";

  }
  send_fund_local()async{
    print("$lamount_charged $lsend_amount $username_receiver");
    var serverUrl = Uri.parse("https://laravel.teletradeoptions.com/api/auth/local-transfer");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    Map data = {
      'send_to':username_receiver,
      'charged_amount':lamount_charged,
      'amount':lsend_amount,
      'transfer_type':'local'
    };
    var response = await http.post(serverUrl,body:data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $prefs'
    });
    var responseDecode = jsonDecode(response.body);
    print(responseDecode);
    if(response.statusCode >= 200 && response.statusCode<= 299)
    {
      if(responseDecode["msg"] == "success"){
        print(responseDecode["msg"]);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>const Success()),
        );
      }else if(responseDecode["msg"]=="failed"){
        print("Transfer failed");
      }
    }else
    {
      sharedPreferences.remove("token");
      _isLoading?CircularProgressIndicator():Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
              (Route<dynamic> route) => false);
    }
  }
}



