import 'package:flutter/material.dart';
import 'package:OMTECH/screens/dashScreens/client_home.dart';

import 'home.dart';

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  Future<bool> toSplash() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => ClientDash()));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // You can do some work here.
        // Returning true allows the pop to happen, returning false prevents it.
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 30),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/A2- Completed Orders.png'))),
        ),
      ),
    );
  }
}
