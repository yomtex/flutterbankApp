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

class SendFunds extends StatefulWidget {
  const SendFunds({Key? key}) : super(key: key);

  @override
  State<SendFunds> createState() => _SendFundsState();
}

class _SendFundsState extends State<SendFunds> {
  //space formatter
  String? replaceWhitespaces(String s, String replace) {
    if (s == null) {
      return null;
    }

    return s.replaceAll(' ', replace);
  }  //space formatter
  String? replaceSplash(String s, String replace) {
    if (s == null) {
      return null;
    }

    return s.replaceAll('/', replace);
  }
  late String expMth ,extYear;
  //int extYear=0;
  bool _iscard = false;
  bool _ishidden = false;
  bool _isLoading = false;
  bool _isVisible = false;
  bool _is_local=false;
  bool backBtn=false;
  bool searchForm=true;
  bool searchBtn=true;
  bool sendBtn = false;
  bool continueBtn = false;
  bool initialVal = false;
  String userCurrency = '';
  String receiving_amt='';
  String pCurrency = '';
  String nickname = '';
  String success=' ';
  String username_receiver='';
  String local_details = '';
  String int_details = '';
  String userType = '';
  String search_username = '';
  GlobalKey<FormState> searchUser = GlobalKey<FormState>();
  TextEditingController searchUname = TextEditingController();
  GlobalKey<FormState> _local_formkey = GlobalKey<FormState>();
  GlobalKey<FormState> _int_formkey = GlobalKey<FormState>();
  GlobalKey<FormState> _sendFund = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController uname = TextEditingController();
  TextEditingController card_um = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController expiryMth = TextEditingController();

  TextEditingController _local_details = TextEditingController();
  TextEditingController _int_details = TextEditingController();
  //TextEditingController nickname = TextEditingController();
  TextEditingController local_amount = TextEditingController();
  TextEditingController local_description = TextEditingController();
  String message=' ';
  String message2=' ';
  String charges=' ';
  String? international_amt, international_username,international_details;
  String? lreceiver_uname,lamount_charged,lsend_amount;

@override
initState()  {

}
final timer =
Timer(const Duration(seconds: 0), () => null);
// Cancel timer, callback never called.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, backgroundColor: Colors.purple,title: Text("Send Fund"),),
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Container(
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: backBtn,
                      child: InkWell(
                        onTap: (){
                          setState((){
                            _isLoading=false;
                            searchForm=true;
                            searchBtn=true;
                            _isVisible=false;
                            _is_local=false;
                            receiving_amt="";
                            message="";
                            charges="";
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 13),
                          child:Icon(Icons.arrow_back_outlined),
                          // Text(
                          //   "Back",
                          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                          //       decoration: TextDecoration.underline)
                          //   ,)

                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: ()=>  Navigator.pop(context),
                    //   child: const Padding(
                    //     padding:   EdgeInsets.symmetric(vertical: 0.0,horizontal: 13),
                    //     child: Icon(Icons.close),
                    //     // Text(
                    //     //   "Back",
                    //     //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                    //     //       decoration: TextDecoration.underline)
                    //     //   ,)
                    //
                    //   ),
                    // ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 10, 5),
                  child: Visibility(
                    visible: searchForm,
                    child: Form(
                      key: searchUser,
                      child: TextFormField(
                        controller: searchUname,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter username"
                        ),
                        onFieldSubmitted: (value) => {
                          timer.cancel(),
                          Timer(const Duration(seconds: 5),()=>""),
                          setState((){
                            var valuename = value.replaceAll(" ", "");
                            searchBtn=false;
                            searchForm=false;
                            backBtn=false;
                            message="";
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
                              backBtn=false;
                              message ="";
                              // Future.delayed(const Duration(seconds: 2),(){
                              //
                              // receiver(value);
                              // });
                              timer.cancel();
                              receiver(valuename);
                            }
                          }),
                        },

                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: searchBtn,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: InkWell(onTap: (){
                        search_username = searchUname.text;
                        if(search_username.toString().isEmpty || search_username =="" || search_username== null){
                          setState((){
                            //print("object");
                            message="Field cannot be empty";
                          });
                        }else{

                          setState((){
                            searchBtn=false;
                            searchForm=false;
                            _isLoading = true;
                            backBtn=false;
                            message="";
                            if(searchUser.currentState!.validate()){
                              search_username = searchUname.text;
                              receiver(search_username);
                            }
                          });
                        }
                      },
                        child: Container(
                          decoration: BoxDecoration(color: Colors.purple,borderRadius: BorderRadius.circular(15)),
                          width: MediaQuery.of(context).size.width/2,
                          child: const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: const Text("Search",style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                          ),),
                      ),
                    ),
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
                  child: Center(
                    child: Text(
                      message.toString(),style:
                    const TextStyle(color: Colors.red),
                    ),
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
                        Visibility(
                          visible: _ishidden,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction(
                                      (oldValue, newValue) => newValue.copyWith(
                                    text: newValue.text.replaceAll('.', ''),
                                  ),
                                ),
                              ],
                              
                              keyboardType: const TextInputType.numberWithOptions(decimal:true),
                              onChanged: (value) => {
                                sendBtn=false,
                                continueBtn=false,
                                setState((){
                                  _isLoading= true;
                                  charges ="";
                                  sendBtn=false;
                                  continueBtn=false;
                                  timer.cancel();
                                  receiving_amt = "";
                                  if(value.isEmpty){
                                    _isLoading=false;
                                    sendBtn =false;
                                    charges ="";
                                    receiving_amt = "";
                                    print("empty");
                                  }else if(double.parse(value) < 10){
                                    _isLoading=false;
                                    sendBtn =false;
                                    charges ="Minimum is 10";
                                    receiving_amt = "";
                                  }
                                  else{
                                    international_rate(value);
                                    //_isLoading=true;
                                    receiving_amt = "";
                                    sendBtn =false;
                                    continueBtn=false;
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
                        ),

                        //card Widget
                        Visibility(
                          visible: _iscard,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    //color: Colors.red
                                ),
                                child: Form(
                                  key: _sendFund,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: card_um,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(16),
                                          CardNumberFormatter(),
                                        ],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Card number",
                                          //prefixIcon: Padding(padding: EdgeInsets.all(10),)

                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: fullname,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Full name",
                                          //prefixIcon: Padding(padding: EdgeInsets.all(10),)

                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: cvv,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                            ],
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "cvv",
                                              //prefixIcon: Padding(padding: EdgeInsets.all(10),)

                                            ),
                                          ),
                                        )),
                                        Expanded(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            validator: (value){
                                              //return "fff";
                                            },
                                            controller: expiryMth,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(4),
                                              CardMonthFormatter()
                                            ],
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "MM/YY",
                                              //prefixIcon: Padding(padding: EdgeInsets.all(10),)

                                            ),
                                          ),
                                        ),
                                        )
                                      ],
                                    ),
                                  ],
                                  ),
                                ),
                              ),
                            )
                        ),
                        const SizedBox(height: 15,),
                        Visibility(
                            visible:_ishidden,
                            child: Text(
                                charges.toString()
                            )
                        ),
                        Visibility(
                          visible: _ishidden,
                            child: Text(
                                receiving_amt.toString()
                            )
                        ),
                        const SizedBox(height: 8,),
                        Visibility(
                          visible: _ishidden,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: _int_details,
                              decoration: const InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Description',
                                  hintText: 'Description'),
                            ),
                          ),
                        ),
                        //Continue btn
                        const SizedBox(height: 15,),
                        Visibility(
                          visible: continueBtn,
                          child: Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(20)),
                            child: TextButton(

                              onPressed: () {
                                setState((){
                                  continueBtn =false;
                                  _ishidden =false;
                                  _iscard =true;
                                  sendBtn = true;
                                });
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),

                        //send btn
                        Visibility(
                          visible: sendBtn,
                          child: Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(20)),
                            child: TextButton(
//working here
                              onPressed: () {
                                if(_sendFund.currentState!.validate()){
                                  //local_details = _local_details.text;
                                  setState(() {

                                    int_details = _int_details.text;
                                    nickname = fullname.text;
                                    //get extmth and year
                                    String? exp = replaceSplash(expiryMth.text,"");
                                    var lengExpirey = ((exp?.length));
                                    if((lengExpirey)! % 4 ==0 || lengExpirey>4){
                                      //Let the first two digit be exp month
                                      String expMthnum ="${exp![0]}${exp[1]}" ;
                                      String expYrnum ="${exp[2]}${exp[3]}" ;
                                       expMth =expMthnum;
                                       extYear = expYrnum;
                                      print(expMth);
                                      print(extYear);
                                      send_fund_international();
                                      _isLoading= true;
                                      sendBtn =false;
                                      _is_local = false;
                                      _isVisible = false;
                                      print("valid");
                                    }else{
                                      print("Not valid");
                                    }

                                    //print();
                                    //send_fund_international();
                                    // _isLoading= true;
                                    // sendBtn =false;
                                    // _is_local = false;
                                    // _isVisible = false;
                                    print(replaceWhitespaces(card_um.text,""));
                                  });
                                }else {
                                  print("Invalid details");
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
                                    //send_fund_local();
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
          ),
        )
    );
  }
  receiver(String value)async {
    backBtn=false;

    var myval =value.replaceAll(" ", "");
    print(value);
    if(myval.length < 3){
      setState((){
        myval.replaceAll(" ", "");
        searchForm=true;
        searchBtn=true;
        backBtn=false;
        _isLoading =false;
        _isVisible=false;
        message = "Field cannot be empty";
      });
    }else if(myval.isEmpty){
      setState((){
        myval.replaceAll(" ", "");
        searchForm=true;
        searchBtn=true;
        backBtn=false;
        _isLoading =false;
        _isVisible=false;
        message = "Field cannot be empty";
      });
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
        print(responseDecode);
        var resErr = responseDecode["reciever"].toString();
        if(response.statusCode >= 200 && response.statusCode<= 299){
          var transfer_type = responseDecode["transfer_type"];
            setState((){
              print("su");
              _isLoading= false;
              message = resErr;
            });
            if(transfer_type == "local"){
              message = "";
              setState((){
                _isLoading =false;
                if(responseDecode["status"] == "success"){
                  backBtn = true;
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
                      //_local_receiver(username_receiver);
                      lreceiver_uname=username_receiver;});
                  }else{
                    setState(() {
                      userType = "0";
                      username_receiver = responseDecode["username"];
                      success = responseDecode["fullname"];
                      userCurrency = responseDecode["userCurrency"];
                      pCurrency = responseDecode["userCurrency"];
                      //_local_receiver(username_receiver);
                      message = "";
                    });
                  }
                  //message = "local";
                  _isVisible=false;
                  _is_local =true;

                  print(transfer_type);
                }else{
                  searchForm=true;
                  searchBtn=true;
                  message=responseDecode["msg"];
                  _isVisible=false;
                  _is_local=false;
                }
              });
            }
            else{
              //international transfer
              //message = value;
              setState((){
                backBtn = true;
                _isLoading =false;
                if(responseDecode["status"] == "success"){
                  //print(responseDecode);
                  message2= responseDecode["isPrivate"];
                  if(message2 == "1"){
                    userType = "1";
                    userCurrency ="";
                    _ishidden = true;
                    _iscard = false;
                    international_username=responseDecode["username"];
                    message="";
                    success= responseDecode["username"];
                    userCurrency = responseDecode["userCurrency"];
                    pCurrency = "";
                    continueBtn=false;
                    //print(responseDecode);
                  }else{
                    userType = "0";
                    continueBtn=false;
                    success= responseDecode["fullname"];
                    international_username=responseDecode["username"];
                    userCurrency = responseDecode["userCurrency"];
                    pCurrency = responseDecode["userCurrency"];
                    message="";
                    _ishidden = true;
                    _iscard = false;
                  }
                  //message = "international";
                  print(transfer_type);
                  _isVisible=true;
                  _is_local=false;
                }else{
                  searchForm=true;
                  searchBtn=true;
                  _iscard = false;
                  message=responseDecode["msg"];
                  _isVisible=false;
                  _is_local=false;
                }
              });
            }

        }
        else{
          setState((){
            sharedPreferences.remove("token");
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => const Login()),
                    (Route<dynamic> route) => false);
          });
        }

    }
  }

  //International rate Api

  international_rate(String value)async{
    //_isLoading=false;
    print(userCurrency);
    var serverUrl = Uri.parse("https://laravel.teletradeoptions.com/api/auth/get-exchange-rates");
    //var serverUrl = Uri.parse("http://127.0.0.1:8000/api/auth/get-exchange-rates");
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
      print(responseDecode);
      if(response.statusCode >= 200 && response.statusCode<= 299){
        var limit = jsonDecode(response.body)["msg"].toString();
        print(response.body);
        if( jsonDecode(response.body)["status"] =="success"){

          setState((){
            if(userType == "1"){
              print(response.body);
              //private user
              _isLoading = false;
              sendBtn = false;
              continueBtn =true;
              international_amt=value;
              print(userType);
              charges = responseDecode["msg"];

              receiving_amt = "";
            }else{
              //public user
              _isLoading = false;
              international_amt=value;
              sendBtn = false;
              continueBtn =true;
              print(responseDecode);
              charges = responseDecode["msg"];
              final double recives_response =responseDecode["receiving_amount"];
              receiving_amt = "Receives $recives_response";

            }
          });
        }
        else if(limit.contains("minimum")){
          setState((){
            _isLoading = false;
            receiving_amt="";
            sendBtn = false;
            continueBtn =false;
            charges = responseDecode["msg"];
          });
        }else if(limit.contains("maximum")){
          setState(() {
            _isLoading = false;
            sendBtn = false;
            continueBtn =false;
            receiving_amt="";
            charges = responseDecode["msg"];
          });
        }else if(limit.contains("insufficient")){
          setState(() {
            receiving_amt="";
            _isLoading = false;
            sendBtn = false;
            continueBtn =false;
            charges = responseDecode["msg"];
          });
        }else{
          setState(() {
            _isLoading = false;
            sendBtn = false;
            receiving_amt="";
            continueBtn =false;
            charges = responseDecode["msg"];
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

  //Send funds method ..

  send_fund_international()async{
    print("$international_amt $international_username $int_details $cvv $card_um $expMth $extYear");
    var serverUrl = Uri.parse("https://laravel.teletradeoptions.com/api/auth/send-funds");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    Map data = {
      'send_to':international_username,
      'amount':international_amt,
      'description':int_details,
      'cvv':cvv.text,
      'card_number':card_um.text,
      'expiry_month':expMth,
      'expiry_year':extYear,
      'nickname':nickname,
      'isSaved':"0"
    };
    var response = await http.post(serverUrl,body:data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $prefs'
    });
    var responseDecode = jsonDecode(response.body);
    // print(responseDecode);
    if(response.statusCode >= 200 && response.statusCode<= 299)
    {
      if(responseDecode["status"] == "success"){
        // print(responseDecode["msg"]);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>const Success()),
        );
      }else{
        setState((){
          _isLoading=false;
          receiving_amt="";
          charges = response.body;
          print(responseDecode["msg"]);
        });
      }
    }else
    {
      setState((){
        _isLoading= false;
        //charges = responseDecode;
        print(responseDecode);
      });
    }
  }

  //Local Transfer method
  send_fund_local()async{
    //print("$lamount_charged $lsend_amount $username_receiver");
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
      print(responseDecode);
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
            }else if(limit.contains("send at this moment")){
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
}
class CardMonthFormatter extends TextInputFormatter{

   late String expResult;
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for(var i = 0; i < inputData.length; i++){
      buffer.write(inputData[i]);
      int index = i +1;

      if(index % 2 == 0 && inputData.length != index){
        //print(inputDate[0]+""+ inputDate[1]);
        buffer.write("/"); //adding double space
        //print(inputDate[2]+""+ inputDate[3]);
        expResult = inputData;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length,
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }
    String inputDate = newValue.text;
    StringBuffer buffer = StringBuffer();
    for(var i = 0; i < inputDate.length; i++){
      buffer.write(inputDate[i]);
      int index = i +1;

      if(index % 4 == 0 && inputDate.length != index){
        buffer.write("  "); //adding double space
      }
    }

    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length,
        ),
    );
  }

}