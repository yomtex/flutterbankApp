import 'dart:io';

class Network{

  tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      return "true";
    } on SocketException catch (e) {return "false";
    }
  }
}