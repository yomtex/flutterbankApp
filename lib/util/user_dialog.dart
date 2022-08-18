import 'dart:async';

import 'package:bankapp/pages/dashboard.dart';
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
  String userCurrency = '';
  String receiving_amt='';
  String pCurrency = '';
  String success=' ';
  String username_receiver='';
  String local_details = '';
  String int_details = '';
  String userType = '';
  GlobalKey<FormState> _local_formkey = GlobalKey<FormState>();
  GlobalKey<FormState> _int_formkey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController _local_details = TextEditingController();
  TextEditingController _int_details = TextEditingController();
  TextEditingController local_amount = TextEditingController();
  TextEditingController local_description = TextEditingController();
  String message=' ';
  String message2=' ';
  String charges=' ';
  String? lreceiver_uname,lamount_charged,lsend_amount;

  @override
  initState()  {
    var checkstatus =LoginStatus();
    checkstatus.status();

  }
  final timer =
  Timer(const Duration(seconds: 0), () => null);
// Cancel timer, callback never called.

  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Container(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 5),
              child: TextFormField(
                autofocus: true,
                decoration: const InputDecoration(hintText: "Enter username"),
                onChanged: (value) => {
                timer.cancel(),
                Timer(Duration(seconds: 5),()=>""),
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
                    }else if(!RegExp(r'^[a-zA-Z0-9]*$').hasMatch(value)){
                      message ="Enter a valid username";
                      _isLoading = false;
                    }
                    else{
                      _isLoading = true;
                      message ="";
                      // Future.delayed(const Duration(seconds: 2),(){
                      //
                      // receiver(value);
                      // });
                      timer.cancel();
                     receiver(value);
                    }
                  }),
                  },

              ),
            ),

            _isLoading?const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: CircularProgressIndicator(semanticsLabel: 'loading', valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),),
              ),
            ):
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                message.toString(),style:
              const TextStyle(color: Colors.red),
              ),
            ),
            //_isLoading?Container(child: CircularProgressIndicator(),):Text(message2.toString()),

            //first form widget for international transfer
            Visibility(
              visible: _isVisible,
              child: Form(
                key: _int_formkey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(success.toString(),style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(pCurrency.toString(),style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            TextInputFormatter.withFunction(
                                  (oldValue, newValue) => newValue.copyWith(
                                text: newValue.text.replaceAll('.', ''),
                              ),
                            ),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(decimal:true),
                          onChanged: (value) => {
                              setState((){
                                _isLoading= true;
                                charges ="";
                                sendBtn=false;
                                timer.cancel();
                                if(value.isEmpty){
                                  _isLoading=false;
                                  sendBtn =false;
                                  charges ="";
                                  print("empty");
                                }
                                else{
                                  international_rate(value);
                                  //_isLoading=true;
                                  sendBtn =false;
                                }
                              }),
                          },
                          decoration: const InputDecoration(
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
                      const SizedBox(height: 15,),
                      Text(charges.toString()),
                      Text(receiving_amt.toString()),
                      const SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _int_details,
                          decoration: const InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Description',
                              hintText: 'Description'),
                        ),
                      ),
                      const SizedBox(height: 15,),
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
                              if(_int_formkey.currentState!.validate()){
                                //local_details = _local_details.text;
                                setState(() {
                                  int_details = _int_details.text;
                                  send_fund_local();
                                  _isLoading= true;
                                  sendBtn =false;
                                  _is_local = false;
                                  _isVisible = false;
                                  print(local_details);
                                });
                              }
                            },
                            child: const Text(
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
            //first form widget close up

            //second form for local transfer
            Visibility(
              visible: _is_local,
              child: Form(
                key:_local_formkey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(success.toString(),style: const TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(pCurrency.toString(),style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              print("empty");
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
                        keyboardType: const TextInputType.numberWithOptions(decimal:true),

                        decoration: const InputDecoration(
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
                    const SizedBox(height: 15,),
                    Text(charges.toString()),
                    const SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: _local_details,
                        decoration: const InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Description',
                            hintText: 'Description'),
                      ),
                    ),
                    const SizedBox(height: 15,),

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
                            if(_local_formkey.currentState!.validate()){
                               //local_details = _local_details.text;
                              setState(() {
                                local_details = _local_details.text;
                                send_fund_local();
                                _isLoading= true;
                                sendBtn =false;
                                _is_local = false;
                                _isVisible = false;
                                print(local_details);
                              });
                            }
                          },
                          child: const Text(
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
            //second form closeContainer(
            //     Center(
            //       child: Padding(padding: EdgeInsets.symmetric(vertical: 30),
            //         child: InkWell(onTap: (){
            //           Navigator.pop(
            //               context,
            //               MaterialPageRoute(builder: (context) => Dashboard()));
            //         },child: Text("close", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),),)
            //     ),
        ],//
        ),
      )
    );
  }

  receiver(String value)async {
  try{
    if(value.length < 3){
      message = "Field cannot be empty";
    }
    else
    {
      receiving_amt="";
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
                setState((){
                  message="";
                  success= responseDecode["username"];
                  userType="1";
                  userCurrency ="";
                  pCurrency = "";
                  username_receiver= responseDecode["username"];
                  _local_receiver(username_receiver);
                  lreceiver_uname=username_receiver;});
              }else{
                setState(() {
                  userType = "0";
                  username_receiver = responseDecode["username"];
                  success = responseDecode["fullname"];
                  userCurrency = responseDecode["userCurrency"];
                  pCurrency = responseDecode["userCurrency"];
                  _local_receiver(username_receiver);
                  message = "";
                });
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
          //international transfer
          //message = value;
          setState((){
            _isLoading =false;
            if(responseDecode["msg"] == "success"){
              //print(responseDecode);
              message2= responseDecode["isPrivate"];
              if(message2 == "1"){
                userType = "1";
                userCurrency ="";
                message="";
                success= responseDecode["username"];
                userCurrency = responseDecode["userCurrency"];
                pCurrency = "";
                //print(responseDecode);
              }else{
                userType = "0";
                success= responseDecode["fullname"];
                userCurrency = responseDecode["userCurrency"];
                pCurrency = responseDecode["userCurrency"];
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
            MaterialPageRoute(builder: (BuildContext context) => const Login()),
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
  }catch(e){
    print("No connection");
  }
}
  international_rate(String value)async{
    //_isLoading=false;
    print(userCurrency);
    var serverUrl = Uri.parse("https://laravel.teletradeoptions.com/api/auth/get-exchange-rates");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    Map data ={
      'reciever_currency':userCurrency,
      'amount':value
    };
    try{
      var response = await http.post(serverUrl,body:data, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $prefs'
      });
      var responseDecode = jsonDecode(response.body);
      if(response.statusCode >= 200 && response.statusCode<= 299){
        var limit = jsonDecode(response.body)["msg"].toString();
        if(limit.contains("minimum")){
          setState((){
            _isLoading = false;
            sendBtn = false;
            charges = responseDecode["msg"];
          });
        }else if(limit.contains("maximum")){
          setState(() {
            _isLoading = false;
            sendBtn = false;
            charges = responseDecode["msg"];
          });
        }else{
          setState((){
            if(userType == "1"){
              //private user
              _isLoading = false;
              sendBtn = true;
              print(userType);
              charges = responseDecode["msg"];
              receiving_amt = "";
            }else{
              //public user
              _isLoading = false;
              sendBtn = true;
              print(responseDecode);
              charges = responseDecode["msg"];
              final double recives_response =responseDecode["receiving_amount"];
              receiving_amt = "Receives $recives_response";

            }
          });
        }
      }else{
        setState((){
          sharedPreferences.remove("token");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => const Login()),
                  (Route<dynamic> route) => false);
        });
      }
    }on TimeoutException catch(_){
      print("Time out");
    }
  }



  local_rates(String value)async {
   try{
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
   print(limit);
   if(response.statusCode >= 200 && response.statusCode<= 299){
     setState((){
       Future.delayed(const Duration(seconds: 0),(){
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
         }else if(limit.contains("more than")){
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
         MaterialPageRoute(builder: (BuildContext context) => const Login()),
             (Route<dynamic> route) => false);
   }
   }catch(e){
     print("No connection");
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
  //international ttransfer method
  send_fund_international()async{

  }

  //Local Transfer method
  send_fund_local()async{
    print("$lamount_charged $lsend_amount $username_receiver");
    var serverUrl = Uri.parse("https://laravel.teletradeoptions.com/api/auth/local-transfer");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    Map data = {
      'send_to':username_receiver,
      'amount':lsend_amount,
      'transfer_type':'local',
      'description':local_details
    };
    var response = await http.post(serverUrl,body:data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $prefs'
    });
    var responseDecode = jsonDecode(response.body);
    // print(responseDecode);
    if(response.statusCode >= 200 && response.statusCode<= 299)
    {
      if(responseDecode["msg"] == "success"){
        // print(responseDecode["msg"]);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>const Success()),
        );
      }else if(responseDecode["msg"]=="failed"){
        // print("Transfer failed");
      }
    }else
    {
      charges = responseDecode["msg"];
    }
  }
}



