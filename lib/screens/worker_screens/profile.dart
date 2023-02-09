import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage("assets/images/Rectangle.png"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(0)),
            child: Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  alignment: Alignment.topRight,
                  child: const Image(image: AssetImage('assets/images/Pattern.png')),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.only(left: 20, right: 30),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 80,
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 30, left: 12),
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage("assets/images/omlogo.png"),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          
                          Expanded(
                            child: Container(
                              alignment: Alignment.topRight,
                              margin: const EdgeInsets.only(
                                top: 30,
                                right: 12,
                              ),
                              // decoration: BoxDecoration(
                              //     image: const DecorationImage(
                              //         image: AssetImage("assets/images/round.png")),
                              //     borderRadius: BorderRadius.circular(0)),
                              child:
                                  Stack(
                                    children: const [
                                      // Image(image: AssetImage("assets/images/round.png")),
                                      Image(image: AssetImage("assets/images/prof.png")),
                                    ]
                                  )
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                            margin: const EdgeInsets.only(top: 10),
                            alignment: Alignment.bottomCenter,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/rect.png"),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50))),
                                child: SingleChildScrollView(
                                  child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(height: 11,),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        // onTap: toAction,
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Rectangular.png"),
                                                    fit: BoxFit.fill),
                                                borderRadius: BorderRadius.circular(0)),
                                            child: const Image(image: AssetImage('assets/images/passp.png'),)
                                                ),
                                      ),
                                      const SizedBox(
                                        width: 17,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text('Author Id wil be here', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        // onTap: toAction,
                                        child: Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Rectangular.png"),
                                                    fit: BoxFit.fill),
                                                borderRadius: BorderRadius.circular(0)),
                                            child: const Image(image: AssetImage('assets/images/passp.png'),)
                                                ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text('My Projects', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        // onTap: toAction,
                                        child: Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Rectangular.png"),
                                                    fit: BoxFit.fill),
                                                borderRadius: BorderRadius.circular(0)),
                                            child: const Image(image: AssetImage('assets/images/calender1.png'),)
                                                ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text('Calendar', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        // onTap: toAction,
                                        child: Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Rectangular.png"),
                                                    fit: BoxFit.fill),
                                                borderRadius: BorderRadius.circular(0)),
                                            child: const Image(image: AssetImage('assets/images/newspaper1.png'),)
                                                ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text('Generate Reports', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        // onTap: toAction,
                                        child: Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/Rectangular.png"),
                                                    fit: BoxFit.fill),
                                                borderRadius: BorderRadius.circular(0)),
                                            child: const Image(image: AssetImage('assets/images/bell.png'),)
                                                ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: const Text('Completed', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                      )))
                  ]),
                ),
              ],
            ),
          );
  }
}