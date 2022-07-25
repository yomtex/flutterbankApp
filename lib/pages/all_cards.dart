import 'package:bankapp/pages/profile.dart';
import 'package:bankapp/pages/transaction.dart';
import 'package:flutter/material.dart';

import '../util/wallet.dart';
import 'home.dart';

class MyCards extends StatefulWidget {
  MyCards({
    Key? key,
  }) : super(key: key);

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 235, 230, 236),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.purple,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          centerTitle: true,
          title: Text(
            "My Cards",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            children: [
              Container(
                //main widget holding the position and distaince from red is too
                height: 215,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 0),
                                    child: Text(
                                      "Adele",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 30),
                                    child: Text(
                                      "**** **** **** " + 5040.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 0),
                                        child: Text(
                                          "02/23",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 0),
                                        child: Container(
                                          child: Icon(
                                            Icons.credit_card,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          //border: Border(bottom: BorderSide(width: 1.5, color: Colors.grey),),
                          borderRadius: BorderRadius.circular(10),
                          //color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 200.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
