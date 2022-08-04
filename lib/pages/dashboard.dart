import 'package:bankapp/pages/profile.dart';
import 'package:bankapp/pages/transaction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../util/navbar.dart';
import '../util/transactions.dart';
import '../util/user_dialog.dart';
import '../util/wallet.dart';
import 'login.dart';

//

//Creating a class user to store the data;
// class UserModel {
//   final email;
//   final username;
//   final userid;
//   final walletbal;
//   UserModel({
//     required this.email,
//     required this.username,
//     required this.walletbal,
//     required this.userid,
//   });
//
// }//

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map mapResponse = new Map();
  bool isNull = false;
  bool _isLoading = true;
  Future getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = sharedPreferences.getString("token");
    //final value = prefs.get(key ) ?? 0;
    if (prefs == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()),
          (Route<dynamic> route) => false);
    } else {
      String url = "http://laravel.teletradeoptions.com/api/auth/user-profile";
      http.Response response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $prefs'
      });

      var responsedata = json.decode(response.body);
      var errMsg = (responsedata["message"]);
      if (!(response.statusCode >= 200 && response.statusCode <= 299)) {
        //means user logged out or session expires
        //return user to login page
        sharedPreferences.remove("token");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Login()),
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
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
      body: Column(
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
      ),
    )
        : Scaffold(
        drawer: _isLoading
            ? Container(
                child: CircularProgressIndicator(),
              )
            : Navbar(
                firstname: mapResponse["name"].toString(),
                lastname: mapResponse["lastname"].toString(),
                balance: mapResponse["walletBalance"].toString(),
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
                  icon: Icon(
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
                  icon: Icon(
                    Icons.history,
                    size: 30,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Transaction()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: IconButton(
                  icon: Icon(
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
        backgroundColor: Color.fromARGB(237, 237, 237, 245),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          elevation: 0,
          centerTitle: true,
          title: Text("Fineapp"),
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
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()),
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
          child: Icon(
            Icons.monetization_on_sharp,
            size: 40,
          ),
          backgroundColor: Colors.purple,
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Container(
              child: Column(
                children: [
                  Container(
                    //main widget holding the position and distaince from red is too
                    height: 245,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        //color: Colors.purple,
                        ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.purple,
                            ),
                            width: MediaQuery.of(context).size.width,
                            //The widget the card float on
                            height: 100.0,
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //first wallet balance content
                                _isLoading
                                    ? Container(
                                        child: CircularProgressIndicator())
                                    : Container(
                                        child: Wallet(
                                          walletBalance:
                                              mapResponse["walletBalance"]
                                                  .toString(),
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
                      ],
                    ),
                  ),

                  SizedBox(height: 40),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        //Transaction widget
                        //color: Colors.orange,
                        ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 22),
                                child: Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 22),
                                child: Text(
                                  "View all",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        //color: Colors.pink,
                        ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            //Start of Transaction widget
                            Transactions(
                              trans_name: "Amazon",
                              trans_bal: -1050,
                            ),
                            Transactions(
                              trans_name: "Vanila",
                              trans_bal: -5100,
                            ),
                            Transactions(
                              trans_name: "Google Play",
                              trans_bal: -21888,
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
