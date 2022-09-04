import 'dart:async';

import 'package:bankapp/formats/custom_fmt.dart';
import 'package:bankapp/pages/profile.dart';
import 'package:bankapp/pages/transaction.dart';
import 'package:bankapp/util/income_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../controller/login_status.dart';
import '../util/navbar.dart';
import '../util/transactions.dart';
import '../util/user_dialog.dart';
import '../util/wallet.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  Map mapResponse = {};
  bool isNull = false;
  bool _isLoading = true;


  //Getting current user details
  Future getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    //final value = prefs.get(key ) ?? 0;
    try {
      if (prefs == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => const Login()),
                (Route<dynamic> route) => false);
      } else {
        var url = Uri.parse(
            "https://laravel.teletradeoptions.com/api/auth/user-profile");
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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => const Login()),
                  (Route<dynamic> route) => false);
        } else {
          var data = json.decode(response.body)["data"];

          if (mapResponse == null) {
            //print("nullb nu");
          } else {
            _isLoading = false;
            //print(data);
            setState(() {
              mapResponse = data;
            });
          }
        }
      }
    }catch(e){
      print("No connection");
    }
  }
  logout()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => const Login()),
            (Route<dynamic> route) => false);

  }

  countTime ()async {
    Timer(const Duration(minutes: 40), () {
      logout();
    });
  }
  @override
  void initState() {
    countTime();
    getData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    var checkstatus = LoginStatus();
    var _active = checkstatus.status();
    //print(_active);
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Timer(const Duration(seconds: 60), () {
          logout(); });
        break;
      case AppLifecycleState.detached:
        Timer(const Duration(seconds: 60), () {
          logout(); });
        break;
      case AppLifecycleState.inactive:
        Timer(const Duration(seconds: 60), () {
          logout(); });
        break;
      case AppLifecycleState.paused:
        Timer(const Duration(seconds: 60), () {
          logout(); });
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _isLoading
            ? Container(
                child: const CircularProgressIndicator(),
              )
            : Navbar(
                firstname: mapResponse["name"].toString(),
                lastname: mapResponse["lastname"].toString(),
                balance: fmtCurrency(mapResponse["walletBalance"].toString(),'', 2),
                currency: mapResponse["userCurrency"].toString(),
                username: mapResponse["username"].toString(),
              ),
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
                  onPressed: () {},
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Transaction()),
                    );
                  },
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(237, 237, 237, 245),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          elevation: 0,
          centerTitle: true,
          title: const Text("Fineapp"),
          actions: [
            //PopupMenuButton(itemBuilder: (context)=>[PopupMenuItem(child: Text("data"))]),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You pressed bell icon.')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                _isLoading = true;
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Login()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => const UserTransfer()
            );
          },
          child: const Icon(
            Icons.monetization_on_sharp,
            size: 40,
          ),
          backgroundColor: Colors.purple,
        ),
        body:_isLoading
            ? Scaffold(
          backgroundColor: Colors.purple,
          body: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/2.2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ],
          ),
        )
            :  SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Container(
              child: Column(
                children: [
                  Container(
                    //main widget holding the position and distaince from red is too
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        //color: Colors.purple,
                        ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.purple,
                            ),
                            width: MediaQuery.of(context).size.width,
                            //The widget the card float on
                            height: 130.0,
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //first wallet balance content
                                _isLoading
                                    ? Container(
                                        child: const CircularProgressIndicator())
                                    : Container(
                                        child: Wallet(
                                          walletBalance:
                                             fmtCurrency( mapResponse["walletBalance"]
                                                 .toString(), '', 2),
                                          currencey: mapResponse["userCurrency"]
                                              .toString(),
                                        ),
                                      ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              //border: Border(bottom: BorderSide(width: 1.5, color: Colors.grey),),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            width: MediaQuery.of(context).size.width,
                            //height: 200.0,
                          ),
                        ),
                        SizedBox(height: 15,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child:  Income(income_amt:"32300", expenses:"4030" ,),
                  ),

                  const SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        //Transaction widget
                        //color: Colors.orange,
                        ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                child: const Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                child: const Text(
                                  "View all",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        //color: Colors.pink,
                        ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            //Start of Transaction widget
                            const Transactions(
                              trans_name: "Amazon",
                              trans_bal: "-1050",
                            ),
                            const Transactions(
                              trans_name: "Vanila",
                              trans_bal: "-5100",
                            ),
                            const Transactions(
                              trans_name: "Google Play",
                              trans_bal: "-21888",
                            ),
                            //Closing of  trasaction
                          ],
                        ),
                      ],
                    ),
                  ),

                  //children parent of all below
                ],
              ),
            ),
          ),
        )
        //  Column(
        //   children: [
        //     _isLoading ?Container(child: CircularProgressIndicator(),):Text(mapResponse["email"].toString()),
        //   ],
        // ),
        );
  }
}
