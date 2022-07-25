import 'package:bankapp/pages/profile.dart';
import 'package:flutter/material.dart';

import '../util/transactions.dart';
import 'home.dart';

class Transaction extends StatefulWidget {
  Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
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
                  onPressed: () {},
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
                    );},
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          centerTitle: true,
          title: Text(
            "History",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Container(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today"),
                    Text(
                      "View all",
                      style: TextStyle(color: Color.fromARGB(255, 60, 9, 155)),
                    )
                  ],
                ),
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Yesterday"),
                    Text(
                      "View all",
                      style: TextStyle(color: Color.fromARGB(255, 60, 9, 155)),
                    )
                  ],
                ),
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sep 20, 2020"),
                    Text(
                      "View all",
                      style: TextStyle(color: Color.fromARGB(255, 60, 9, 155)),
                    )
                  ],
                ),
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Last week"),
                    Text(
                      "View all",
                      style: TextStyle(color: Color.fromARGB(255, 60, 9, 155)),
                    )
                  ],
                ),
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              Transactions(
                trans_bal: -150,
                trans_name: "Amazon",
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          ),
        )),
      ),
    );
  }
}
