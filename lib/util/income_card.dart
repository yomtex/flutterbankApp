import 'package:flutter/material.dart';

import '../formats/custom_fmt.dart';

class Income extends StatelessWidget {
  final double income_amt, expenses;
  const Income({Key? key, required this.income_amt, required this.expenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              //height:350,
              child: Card(
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 225, 225, 235),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Incomes",
                            style: TextStyle(),
                          ),
                          Text(
                            fmtCurrency(income_amt, '\$', 1),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              //height:350,
              child: Card(
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 225, 225, 235),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expenses",
                            style: TextStyle(),
                          ),
                          Text(
                            fmtCurrency(expenses, '\$', 1),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
