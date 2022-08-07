import 'package:bankapp/pages/dashboard.dart';
import 'package:flutter/material.dart';
class Success extends StatelessWidget {
  const Success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
      Scaffold(
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child:
              Text(
                "Success !!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'times new roman')
                ,)
          ),
          Center(
              child:
              Text(
                "Transfer was successful",
                style: TextStyle(
                    fontSize: 20, fontFamily: 'times new roman')
                ,)
          ), Container(
            margin: EdgeInsets.all(20),
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20)),
            child: TextButton(

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const Dashboard()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 // Icon(Icons.transfer_within_a_station),
                  Text(
                    'OK',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
