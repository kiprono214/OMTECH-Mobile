import 'package:flutter/material.dart';
import 'package:OMTECH/screens/dashScreens/client_home.dart';
import 'package:OMTECH/screens/dashScreens/home.dart';
import '../authentication/login.dart';
import 'dart:async';

class Dialog extends StatefulWidget {
  const Dialog({Key? key}) : super(key: key);

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);
  void handleTimeout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ClientDash()));
    // Do some work.
  }
  // _SplashState(){
  //    _timer = new Timer(const Duration(milliseconds: 800), () {
  //       setState(() {

  //       });
  //       _timer = new Timer(const Duration(seconds: 1), () {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) =>Login()));
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scheduleTimeout(5000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/images/Rectangle.png"),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(0)),
        child: Center(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 5 / 2,
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 100),
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage("assets/images/omlogo.png")),
                      borderRadius: BorderRadius.circular(0)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AspectRatio(
                  aspectRatio: 8 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage("assets/images/gif_loading.gif")),
                        borderRadius: BorderRadius.circular(0)),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void toLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()));
  }
}
