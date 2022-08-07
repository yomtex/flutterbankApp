import 'package:bankapp/pages/dashboard.dart';
import 'package:bankapp/pages/profile.dart';
import 'package:flutter/material.dart';

import '../util/transactions.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
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
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: const BoxConstraints(),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Today"),
                  Text(
                    "View all",
                    style: TextStyle(color: Color.fromARGB(255, 60, 9, 155)),
                  )
                ],
              ),
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Yesterday"),
                  Text(
                    "View all",
                    style: TextStyle(color: Color.fromARGB(255, 60, 9, 155)),
                  )
                ],
              ),
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Sep 20, 2020"),
                  Text(
                    "View all",
                    style: TextStyle(color: Color.fromARGB(255, 60, 9, 155)),
                  )
                ],
              ),
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Last week"),
                  Text(
                    "View all",
                    style: TextStyle(color: Color.fromARGB(255, 60, 9, 155)),
                  )
                ],
              ),
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const Transactions(
              trans_bal: "-150",
              trans_name: "Amazon",
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
        )),
      ),
    );
  }
}
