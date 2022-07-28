import 'package:flutter/material.dart';
class ItemList extends StatelessWidget {
  List list;
   ItemList({Key? key,required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new GestureDetector(
              child: new Card(
                child: new ListTile(
                  title: new Text(list[i]['email']),
                  leading: new Icon(Icons.apps),
                  subtitle: new Text('username : ${list[i]['username']}'),
                ),
              ),
            ),
          );
        });
  }
}
