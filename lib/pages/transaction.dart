import 'package:bankapp/pages/dashboard.dart';
import 'package:bankapp/pages/profile.dart';
import 'package:bankapp/util/transaction_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  Map mapResponse = {};
  bool isNull = false;
  bool _isLoading = true;
  List transactions=[];
  Map userResponse={};
  var currentusername,x;
  String sender_currency="";
  String fname= "";
  String lname= "";
  String initials = "";
  String initial = "";
  String debit="Debit"; String  credit="Credit";

  logout()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    sharedPreferences.remove("token");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => const Login()),
            (Route<dynamic> route) => false);

  }


  getUser()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    if (prefs == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => const Login()),
              (Route<dynamic> route) => false);
    }else{
      var sender = Uri.parse("https://laravel.teletradeoptions.com/api/auth/user-profile");
      http.Response userRespo = await http.get(sender, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $prefs'
      });
      if (!(userRespo.statusCode >= 200 && userRespo.statusCode <= 299)) {
        //means user logged out or session expires
        //return user to login page
        sharedPreferences.remove("token");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => const Login()),
                (Route<dynamic> route) => false);
      }else{
        var userDecode = jsonDecode(userRespo.body);
        var userData = userDecode["data"];
        currentusername = userData["username"];
        fname = userData["name"].toString();
        lname = userData["lastname"].toString();
        var _sender_currency = userData["userCurrency"];
        initials = fname[0].toUpperCase()+lname[0].toUpperCase();
        print(initials);
        if(_sender_currency == "NGN"){
          sender_currency="₦";
        }else if(_sender_currency == "USD"){
          sender_currency="\$";
        }
        //print(currentusername);

        //getting user history
        var url = Uri.parse("https://laravel.teletradeoptions.com/api/auth/transaction-history");
        http.Response response = await http.get(url, headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $prefs'
        });
        if (!(response.statusCode >= 200 && response.statusCode <= 299)) {
          //means user logged out or session expires
          //return user to login page
          sharedPreferences.remove("token");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => const Login()),
                  (Route<dynamic> route) => false);
        } else {
          var msg = json.decode(response.body)["msg"];
          var  debit = json.decode(response.body)["data"];
          //transactions = mapResponse["msg"];
          if(msg == "success"){
            setState((){
              mapResponse = json.decode(response.body);
              transactions = mapResponse["data"];
              for(var x = 1; x<transactions.length; x++){
                if(transactions[x]["from"] == currentusername){
                  setState((){
                     //debit_sender = (transactions[x]["from"]);
                  });
                }
                if(transactions[x]["from"] != currentusername){
                  setState((){
                    //print(transactions[x]);
                  });
                }
              }
              _isLoading=false;
            });
          }else{
            //user not found
            sharedPreferences.remove("token");
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => const Login()),
                    (Route<dynamic> route) => false);
          }
        }

      }

    }

  }
  @override
  void initState(){
    getUser();
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        logout();
        break;
      case AppLifecycleState.detached:
        logout();
        break;
      case AppLifecycleState.inactive:
        logout();
        break;
      case AppLifecycleState.paused:
        logout();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 230, 236),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.home,
                    size: 30,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Dashboard()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.history,
                    size: 30,
                    color: Colors.purple,
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );},
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          centerTitle: true,
          title: const Text(
            "History",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:_isLoading
            ? Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/2.2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ],
              ),
            ],
          ),
        )
            :  SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions == null?0:transactions.length,
                itemBuilder:(context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){
                            _isLoading?Container(child: CircularProgressIndicator(),):Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  TransactionDetails(
                                      id: transactions[index]["id"],
                                      sender: transactions[index]["from"],
                                      receiver: transactions[index]["send_to"],
                                      charges:transactions[index]["charges"],
                                      amount: transactions[index]["recieving_amount"],
                                      currency: sender_currency,
                                  )),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children:[
                                   Container(
                                      width: 70,
                                      child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.purple,
                                          child: Text(initials)),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      child: transactions[index]["from"]==currentusername?
                                       Text(debit,
                                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),):
                                       Text(credit,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: transactions[index]["from"]==currentusername?
                                Row(
                                  children: [
                                    const Text("- ",  style: TextStyle(
                                        color: Colors.red, fontWeight: FontWeight.bold),),
                                     Text(sender_currency,  style: TextStyle(
                                        color: Colors.red, fontWeight: FontWeight.bold),),
                                    Text(transactions[index]["recieving_amount"],
                                      style: const TextStyle(
                                          color: Colors.red, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ):Row(
                                  children: [
                                    const Text("+ ",  style: TextStyle(
                                        color: Colors.green, fontWeight: FontWeight.bold),),
                                    Text(sender_currency,  style: TextStyle(
                                        color: Colors.green, fontWeight: FontWeight.bold),),
                                    Text(transactions[index]["recieving_amount"], style: const TextStyle(
                                        color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
                }),

            const SizedBox(
              height: 10,
            ),


            const SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }
}


