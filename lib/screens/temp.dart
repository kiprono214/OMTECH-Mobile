import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Temp extends StatefulWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
      
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(  
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/rectangle.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(2)),
          child: Container(
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/temp.png"),
                  fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(2)),
          ),    
       ),

    );
  }
}
