import 'package:OMTECH/authentication/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:OMTECH/screens/author_screens/assigned.dart';
import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:OMTECH/screens/author_screens/profile%20copy.dart';
import 'package:OMTECH/screens/author_screens/action.dart';
import 'package:OMTECH/screens/author_screens/completed.dart';
import 'package:OMTECH/screens/author_screens/reactive.dart';
import 'package:OMTECH/tools/jumping_dots.dart';

import '../author_screens/jobs.dart';
import '../author_screens/preventive.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getProf();
  }

  Color leftBar = Colors.blue;
  Color rightBar = Colors.black45;
  Color leftLine = Colors.blue;
  Color rightLine = Colors.transparent;

  String selectedOpt = 'Work Orders';

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
            Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                              child: getSmallHolder()),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: 700,
                      margin: const EdgeInsets.only(top: 20),
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                          // ignore: prefer_const_constructors
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(50),
                              topRight: const Radius.circular(50))),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      leftBar = Colors.blue;
                                      rightBar = Colors.black45;
                                      leftLine = Colors.blue;
                                      rightLine = Colors.transparent;

                                      selectedOpt = 'Work Orders';
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 50,
                                          width: 150,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Work Orders',
                                            style: TextStyle(
                                                color: leftBar,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Container(
                                        height: 3,
                                        width: 140,
                                        color: leftLine,
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      leftBar = Colors.black45;
                                      rightBar = Colors.blue;
                                      leftLine = Colors.transparent;
                                      rightLine = Colors.blue;

                                      selectedOpt = 'Tagging';
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 50,
                                          width: 150,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Tagging',
                                            style: TextStyle(
                                                color: rightBar,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Container(
                                        height: 3,
                                        width: 140,
                                        color: rightLine,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            (selectedOpt == 'Tagging')
                                ? Column(
                                    children: [],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: toAction,
                                            child: Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        237, 245, 254, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 60,
                                                        width: 60,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            top: 15),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                    .fromRGBO(
                                                                255,
                                                                251,
                                                                242,
                                                                1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: SvgPicture.asset(
                                                          'assets/images/study-light-idea.svg',
                                                          height: 30,
                                                          width: 30,
                                                        )),
                                                    Container(
                                                      height: 60,
                                                      width: 60,
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      child: const Text(
                                                        'Action Needed',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                      color:
                                                          const Color.fromRGBO(
                                                              237, 245, 254, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          height: 60,
                                                          width: 60,
                                                          alignment:
                                                              Alignment.center,
                                                          margin: const EdgeInsets
                                                              .only(top: 15),
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                      .fromRGBO(
                                                                  255,
                                                                  251,
                                                                  242,
                                                                  1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/images/pause 1.svg',
                                                            height: 30,
                                                            width: 30,
                                                          )),
                                                      Container(
                                                        height: 60,
                                                        width: 60,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: EdgeInsets.only(
                                                            bottom: 12),
                                                        child: const Text(
                                                          'Jobs On Hold',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: toPreventive,
                                            child: Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        237, 245, 254, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 60,
                                                        width: 60,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .only(top: 15),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                    .fromRGBO(
                                                                255,
                                                                251,
                                                                242,
                                                                1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: SvgPicture.asset(
                                                          'assets/images/coronavirus 1.svg',
                                                          height: 30,
                                                          width: 30,
                                                        )),
                                                    Container(
                                                      height: 60,
                                                      width: 80,
                                                      alignment:
                                                          Alignment.center,
                                                      margin: EdgeInsets.only(
                                                          bottom: 12),
                                                      child: const Text(
                                                        'Preventive Maintenance',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                                    color: const Color.fromRGBO(
                                                        237, 245, 254, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 60,
                                                        width: 60,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .only(top: 15),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                    .fromRGBO(
                                                                255,
                                                                251,
                                                                242,
                                                                1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: SvgPicture.asset(
                                                          'assets/images/Vector (2).svg',
                                                          height: 30,
                                                          width: 30,
                                                        )),
                                                    Container(
                                                      height: 60,
                                                      width: 80,
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      child: const Text(
                                                        'Reactive Maintenance',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: toCompleted,
                                            child: Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        237, 245, 254, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        height: 60,
                                                        width: 60,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .only(top: 15),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                    .fromRGBO(
                                                                255,
                                                                251,
                                                                242,
                                                                1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                        child: SvgPicture.asset(
                                                          'assets/images/checklist (1) 1.svg',
                                                          height: 30,
                                                          width: 30,
                                                        )),
                                                    Container(
                                                      height: 60,
                                                      width: 80,
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      child: const Text(
                                                        'Completed',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                  ),
                          ],
                        ),
                      ))
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getProf() async {
    userProf = await FirebaseStorage.instance
        .ref()
        .child('authors/$userId')
        .getDownloadURL();
    print('"""""""""""""""""$userProf');
    setState(() {});
  }

  Widget getSmallHolder() {
    if (userProf == null) {
      return GestureDetector(
        onTap: (() {}),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: SvgPicture.asset(
            'assets/images/image 3.svg',
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: (() {}),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            userProf!,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
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
