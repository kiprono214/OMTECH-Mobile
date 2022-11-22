import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:OMTECH/screens/dashScreens/action.dart';
import 'package:OMTECH/screens/dashScreens/client_home.dart';
import 'package:OMTECH/screens/dashScreens/profile.dart';
import 'package:OMTECH/screens/dashScreens/reactive.dart';
import 'package:OMTECH/screens/dashScreens/projects.dart';

import 'completed.dart';
import 'jobs.dart';
import 'preventive.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void toAction() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => ActionN()));
  }

  void toReactive() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => ReactiveM()));
  }

  void toJobs() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Jobs()));
  }

  void toPreventive() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PreventiveM()));
  }

  void toCompleted() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Completed()));
  }

  void toProfile() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Profile()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(46, 59, 73, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                'assets/images/Pattern.svg',
                height: 112,
                width: 180,
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 20, right: 20),
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
                          child: Stack(children: const [
                            Image(image: AssetImage("assets/images/round.png")),
                            // Image(image: AssetImage("assets/images/prof.png")),
                          ])),
                    )
                  ],
                ),
              ),
              Container(
                  height: 800,
                  margin: const EdgeInsets.only(top: 20),
                  alignment: Alignment.bottomCenter,
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                      // ignore: prefer_const_constructors
                      color: const Color.fromRGBO(253, 253, 253, 1),
                      // ignore: prefer_const_constructors
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(50),
                          topRight: const Radius.circular(50))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: toAction,
                            child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(237, 245, 254, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                255, 251, 242, 1),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: SvgPicture.asset(
                                          'assets/images/study-light-idea.svg',
                                          height: 30,
                                          width: 30,
                                        )),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: const Text(
                                        'Action Needed',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              onTap: toJobs,
                              child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          237, 245, 254, 1),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 60,
                                          width: 60,
                                          alignment: Alignment.center,
                                          margin:
                                              const EdgeInsets.only(top: 15),
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  255, 251, 242, 1),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: SvgPicture.asset(
                                            'assets/images/pause 1.svg',
                                            height: 30,
                                            width: 30,
                                          )),
                                      Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(bottom: 12),
                                        child: const Text(
                                          'Jobs On Hold',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ))),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: toPreventive,
                            child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(237, 245, 254, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                255, 251, 242, 1),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: SvgPicture.asset(
                                          'assets/images/coronavirus 1.svg',
                                          height: 30,
                                          width: 30,
                                        )),
                                    Container(
                                      height: 60,
                                      width: 80,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(bottom: 12),
                                      child: const Text(
                                        'Preventive Maintenance',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: toReactive,
                            child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(237, 245, 254, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                255, 251, 242, 1),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: SvgPicture.asset(
                                          'assets/images/Vector (2).svg',
                                          height: 30,
                                          width: 30,
                                        )),
                                    Container(
                                      height: 60,
                                      width: 80,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: const Text(
                                        'Reactive Maintenance',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: toCompleted,
                            child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(237, 245, 254, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                255, 251, 242, 1),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: SvgPicture.asset(
                                          'assets/images/checklist (1) 1.svg',
                                          height: 30,
                                          width: 30,
                                        )),
                                    Container(
                                      height: 60,
                                      width: 80,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: const Text(
                                        'Completed',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          MyProfile()
                        ],
                      ),
                      const SizedBox(
                        height: 0,
                      )
                    ],
                  ))
            ]),
          ],
        ),
      ),
    );
  }
}

class MyProfile extends ConsumerWidget {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        _selectPage(context, ref, 'profile');
      },
      child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/Rectangular.png"),
                  fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(198, 201, 204, 0.3),
                      borderRadius: BorderRadius.circular(30)),
                  child: SvgPicture.asset(
                    'assets/images/Vector (3).svg',
                    height: 60,
                    width: 60,
                  )),
              Container(
                height: 60,
                width: 70,
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 12),
                child: const Text(
                  'My Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          )),
    );
  }
}
