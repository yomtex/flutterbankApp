import 'dart:math';

import 'package:bankapp/pages/transaction.dart';
import 'package:flutter/material.dart';

class TransactionDetails extends StatelessWidget {
  final id,sender,receiver,charges, amount,currency,transfer_type;

  const TransactionDetails({
    Key? key,
    this.id,
    this.sender,
    this.receiver,
    this.charges,
    this.amount,
    this.currency,
    this.transfer_type
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(237, 237, 237, 245),
      appBar:
      AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,title: Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/7,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 40,
                    child: Text(
                      sender[0],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "times new roman",
                          fontSize: 60,
                          color: Colors.white),
                    ),
                  ),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Center(child: Text(
                "Transaction Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "times new roman",
                  fontSize: 17,letterSpacing: 1
                  ),
              ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:28.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 25,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8,vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Amount"),
                                Text("$currency $amount"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8,vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Beneficiary"),
                                Text(receiver),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:8,vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Status"),
                                Text("completed"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25,),
                        TextButton(onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (BuildContext context) => const Transaction()),
                                  (Route<dynamic> route) => false);
                        }, child: Container(
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                            child: Text("Back", style: TextStyle(color: Colors.black),))),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}