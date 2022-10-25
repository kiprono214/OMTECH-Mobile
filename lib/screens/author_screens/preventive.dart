import 'package:flutter/material.dart';

import '../dashScreens/home.dart';

class PreventiveM extends StatefulWidget {
  const PreventiveM({Key? key}) : super(key: key);

  @override
  State<PreventiveM> createState() => _PreventiveMState();
}

class _PreventiveMState extends State<PreventiveM> {
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
                  image: AssetImage(
                      'assets/images/A3- Preventative Maintance.png'))),
        ),
      ),
    );
  }
}
