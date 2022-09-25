import 'package:bankapp/payment/addfunds.dart';
import 'package:flutter/material.dart';

import '../pages/all_cards.dart';

class Wallet extends StatelessWidget {
  final walletBalance;
  final currencey;
  const Wallet({Key? key, this.walletBalance, this.currencey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListBody(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Balance"),
            SizedBox(height:30),
            // Container(
            //     decoration: BoxDecoration(
            //         color: Color.fromARGB(255, 233, 216, 236),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: Padding(
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
            //       child: IconButton(
            //         icon: Icon(Icons.add),
            //         onPressed: ()
            //           =>Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFunds()),),
            //       ))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "$currencey $walletBalance",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 60,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Container(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child:Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Withdraw"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Container(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.purple),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child:Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Send"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Container(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child:Icon(
                            Icons.credit_card,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Cards"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Container(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child:Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Recent"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
