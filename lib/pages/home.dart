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

class HomePage extends StatefulWidget {
  Widget build(BuildContext context) => Drawer();
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = PageController();
    AuthController authUser = new AuthController();
    //saved token
  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }


  @override
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
              icon: const Icon(Icons.settings),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You pressed bell icon.')));
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
                                Wallet(),
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
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          //Widget holding Income and Expenses stuff
                          //color: Colors.cyan,
                          ),
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
                    width: MediaQuery.of(context).size.width,
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
                  // Container(
                  //   height: 300,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //     color: Colors.green,
                  //   ),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 10),
                  //   height: 300,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //     color: Colors.yellow,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
