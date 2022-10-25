import 'package:flutter/material.dart';
import './home.dart';

class ActionN extends StatefulWidget {
  const ActionN({Key? key}) : super(key: key);

  @override
  State<ActionN> createState() => _ActionNState();
}

class _ActionNState extends State<ActionN> {
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
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/A6- Action Needed.png'))),
        ),
      ),
    );
  }
}
