import 'package:flutter/material.dart';

import '../dashScreens/home.dart';

class ReactiveM extends StatefulWidget {
  const ReactiveM({Key? key}) : super(key: key);

  @override
  State<ReactiveM> createState() => _ReactiveMState();
}

class _ReactiveMState extends State<ReactiveM> {
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
                  image: AssetImage(
                      'assets/images/A4- Reactive Maintanance.png'))),
        ),
      ),
    );
  }
}
