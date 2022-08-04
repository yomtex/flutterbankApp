import 'package:flutter/material.dart';

import '../formats/custom_fmt.dart';
import 'nav_balance.dart';

class Navbar extends StatelessWidget {
  final firstname, lastname;
  final my_color = Color.fromARGB(255, 229, 197, 235);
  final  balance,currency,username;
  final font_size = 15;
  Navbar({Key? key, required this.balance, this.firstname, this.lastname, this.currency, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.purple,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(35),
                                child: Image.asset(
                                  "lib/icons/credit-card.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$firstname $lastname",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "$username",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(color: Colors.white),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.purple),
                child: Column(
                  children: [
                    //
                    Nav_balance(
                      currency: "$currency",
                      balance:"$balance",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: ListTile(
                  visualDensity: VisualDensity(vertical: 0),
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Menu",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 85, 17, 97),
                              radius: 17,
                              child: ClipOval(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.dashboard,
                                      size: 17,
                                    )),
                              ),
                            ),
                            Text(
                              " " + " Overview",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      //second Menu Item

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 85, 17, 97),
                              radius: 17,
                              child: ClipOval(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.credit_card,
                                      size: 17,
                                    )),
                              ),
                            ),
                            Text(
                              " " + " My Cards",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ),

                      //Third Menu Item

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 85, 17, 97),
                              radius: 17,
                              child: ClipOval(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.settings,
                                      size: 17,
                                    )),
                              ),
                            ),
                            Text(
                              " " + " Settings",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      //fourth Menu item

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 85, 17, 97),
                              radius: 17,
                              child: ClipOval(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.person,
                                      size: 17,
                                    )),
                              ),
                            ),
                            Text(
                              " " + " Profile",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ),

                      //fifth Menu item

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 85, 17, 97),
                              radius: 17,
                              child: ClipOval(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.logout,
                                      size: 17,
                                    )),
                              ),
                            ),
                            Text(
                              " " + " Logout",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //decoration: BoxDecoration(color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

            // decoration: BoxDecoration(
            //   color: Colors.purple,
            // ),