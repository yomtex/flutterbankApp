import 'package:bankapp/controller/api.dart';
import 'package:bankapp/pages/profile.dart';
import 'package:bankapp/pages/transaction.dart';
import 'package:bankapp/util/income_card.dart';
import 'package:bankapp/util/wallet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../util/my_card.dart';
import '../util/navbar.dart';
import '../util/transactions.dart';
import 'all_cards.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



//Creating a class user to store the data;
class User {
  final email;
  final username;
  final userid;
  final walletbal;
  User({
    required this.email,
    required this.username,
    required this.walletbal,
    required this.userid,
  });
}



class HomePage extends StatefulWidget {
  Widget build(BuildContext context) => Drawer();
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Applying get request.

  Future<List<User>> getRequest() async {
    //replace your restFull API here.

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String url = "http://laravel.teletradeoptions.com/api/auth/user-profile";
    var token = sharedPreferences.getString("token");
    final response = await http.get(
        url, headers: {"Authorization": "Bearer $token"});

    var responseData = jsonDecode(response.body)["data"];
    //print(responseData);
    if (response.statusCode == 200) {
      //Creating a list to store input data;
      //List<User> users = [];

      print(responseData["name"]);
      print(responseData["email"]);
     return  responseData["data"];

      // User myuser = User(
      //   email: repdata["name"],
      //   userid: repdata["email"],
      //   walletbal: repdata["walletBalance"],
      //   username: repdata["username"],
      // );
      // users.add(myuser);
      // for (var singleUser in responseData) {
      //
      //   User user = User(
      //       email: singleUser["email"],
      //       userid: singleUser["userid"],
      //       walletbal: singleUser["walletBalance"],
      //       username: singleUser["username"]);
      //
      //   // Adding user to the list.
      //   users.add(user);
      // }
      //print(users);
      //return users;
    } else {
      return logout();
    }
  }

  getUser() async {
    String serverUrl = "http://laravel.teletradeoptions.com/api/auth/user-profile";
    SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()), (
          Route<dynamic> route) => false);
    } else {
      var token = sharedPreferences.getString("token");
      var response = await http.get(
          serverUrl, headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == "500") {
        print("unauthorized");
      } else {
        print(response.body);
      }
    }
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = "http://laravel.teletradeoptions.com/api/auth/logout";
    var token = preferences.getString("token");
    final response = await http.get(
        url, headers: {"Authorization": "Bearer $token"});


    await preferences.remove('token');
    //
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login()), (
        Route<dynamic> route) => false);
  }

  final _controller = PageController();

  late SharedPreferences sharedPreferences;

  @override
  void iniState() {
    super.initState();
    checkLoginStatus();
    getRequest();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login()), (
          Route<dynamic> route) => false);
    } else {
      String? token = sharedPreferences.getString("token");
      print(token);
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Navbar(
          balance: 5233.07,
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
        backgroundColor: Color.fromARGB(255, 225, 225, 235),
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
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (BuildContext context) => Login()), (
                    Route<dynamic> route) => false);
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
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
                    height: 235,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
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
                                Wallet(),
                              ],
                            ),
                            decoration: BoxDecoration(
                              //border: Border(bottom: BorderSide(width: 1.5, color: Colors.grey),),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            //height: 200.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Income side
                          Income(
                            income_amt: 321330.54,
                            expenses: 412338.75,
                          ),
                        ],
                      ),
                      // height: 180,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                        //Widget holding Income and Expenses stuff
                        //color: Colors.cyan,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "My Cards",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Padding(
                            //debit card widget
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyCards()),
                                );
                              },
                              child: Text(
                                "View all",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 60, 9, 155)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      //color: Colors.red,
                    ),
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      children: [
                        Mycard(
                          balance: 53580.20,
                          cardNumber: 5067,
                          color: Colors.black,
                          cartName: "Adele Main",
                          expMth: 03,
                          expYr: 23,
                        ),
                        Mycard(
                          balance: 5350.20,
                          cardNumber: 6102,
                          color: Colors.purple[400],
                          cartName: "Femi  Martins",
                          expMth: 09,
                          expYr: 24,
                        ),
                        Mycard(
                          balance: 5350.20,
                          cardNumber: 3981,
                          color: Colors.red,
                          cartName: "Wale Sugar",
                          expMth: 07,
                          expYr: 26,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                        activeDotColor: Colors.grey.shade800),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    FutureBuilder<List<User>>(future: getRequest(), builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Expanded(
                            child: Center(child: CircularProgressIndicator(),));
                      }else if(snapshot.hasData){
                        List<User> _users = snapshot.data!;
                        return Flexible(

                            child: Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:_users.length ,
                                itemBuilder: (context,index)=>_users[index].email,
                              ),
                            ));
                      }
                      else{return Text("");}
                    })
                  ],),
                  Container(
                    // child: FutureBuilder(
                    //   future: getUser(),
                    //   builder: (context, snapshot) {
                    //     final employees = snapshot.data;
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       return ListView.separated(
                    //         separatorBuilder: (context, index) {
                    //           return Divider(
                    //             height: 2,
                    //             color: Colors.black,
                    //           );
                    //         },
                    //         itemBuilder: (context, index) {
                    //           return ListTile(
                    //             title: Text(employees[index]['email']),
                    //             subtitle: Text(
                    //                 'Age: ${employees[index]['username']}'),
                    //           );
                    //         },
                    //         itemCount: snapshot.data.length,
                    //       );
                    //     }
                    //     return Center(
                    //       child: CircularProgressIndicator(),
                    //     );
                    //   },
                    // ),
                    height: 300,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(16.0),
                  //   child: FutureBuilder(
                  //     future: getRequest(),
                  //     builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  //       if (snapshot.data == null) {
                  //         return Container(
                  //           child: Center(
                  //             child: CircularProgressIndicator(),
                  //           ),
                  //         );
                  //       } else {
                  //         return Container(child:
                  //         ListView.builder(
                  //             itemCount: snapshot.data.length,
                  //             itemBuilder: (context, index) =>
                  //             ListTile(
                  //               title: Text(snapshot.data[index].edmail),)));
                  //       }
                  //     },
                  //   ),
                  // ),
                  Container(
                    height: 200,
                    child: IconButton(icon: Icon(Icons.add,), onPressed: () {
                      logout();
                    },),),
                  //Container(child: getCurrentUser(),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
    //
    // }Container(
    // child:new  ListView.builder(
    // itemCount: snapshot.data.length,
    // itemBuilder: (ctx, index) => ListTile(
    // title: Text(snapshot.data[index].email),
    // subtitle: Text(snapshot.data[index].username),
    // contentPadding: EdgeInsets.only(bottom: 20.0),
    // ),
    // ),
    // );


//fetching user record
// class User{
//   String userid;
//   String username, email, walletBalance,isPrivate,firstName,lastName;
//
//   User({required this.userid, required this.email, required this.walletBalance, required this.isPrivate, required this.firstName, required this.lastName, required this.username});
//
//   factory User.fromJson(Map<String, dynamic> json){
//     return User(
//       userid: json['userid'],
//       email: json['email'],
//       username: json['username'],
//       walletBalance: json['birth_date'],
//       isPrivate: json['gender'],
//       firstName: json['birth_date'],
//       lastName: json['birth_date'],
//
//     );
//   }
// }

  }}
