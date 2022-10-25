// import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import '../authentication/login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);
  void handleTimeout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
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
    scheduleTimeout(3000);
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
                const SizedBox(
                  height: 400,
                ),
                Container(
                  height: 300,
                  width: 400,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage("assets/images/omlogo.png"),
                          fit: BoxFit.fitHeight),
                      borderRadius: BorderRadius.circular(0)),
                ),
                const SizedBox(
                  height: 20,
                ),
                AspectRatio(
                    aspectRatio: 2 / 1,
                    child: Container(
                        child: SpinKitThreeBounce(
                      color: Colors.orange,
                    )))
              ],
            ),
          )),
    );
  }
}
