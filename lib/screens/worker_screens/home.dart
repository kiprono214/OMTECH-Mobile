import 'package:OMTECH/authentication/login.dart';
import 'package:OMTECH/screens/worker_screens/create_tag.dart';
import 'package:OMTECH/screens/worker_screens/tag_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:OMTECH/screens/worker_screens/assigned.dart';
import 'package:OMTECH/screens/worker_screens/worker_home.dart';
import 'package:OMTECH/screens/worker_screens/profile%20copy.dart';
import 'package:OMTECH/screens/worker_screens/snag.dart';
import 'package:OMTECH/screens/worker_screens/completed.dart';
import 'package:OMTECH/screens/worker_screens/reactive.dart';
import 'package:OMTECH/tools/jumping_dots.dart';

import '../worker_screens/jobs.dart';
import '../worker_screens/preventive.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tabs extends ConsumerStatefulWidget {
  Tabs({Key? key, this.selected}) : super(key: key);
  String? selected;

  @override
  ConsumerState<Tabs> createState() => _TabsState();
}

class _TabsState extends ConsumerState<Tabs> {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.selected != null) {
      setState(() {
        current = widget.selected!;
      });
    }
  }

  String current = 'Action';
  Color getColor(String tapped) {
    if (tapped == current) {
      return Colors.white;
    } else {
      return Colors.transparent;
    }
  }

  Color getTextColor(String tapped) {
    if (tapped == current) {
      return const Color.fromRGBO(0, 122, 255, 1);
    } else {
      return const Color.fromRGBO(42, 46, 49, 0.4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(226, 240, 255, 1),
          borderRadius: BorderRadius.circular(10)),
      padding:
          const EdgeInsets.only(left: 4.6, top: 3.85, bottom: 3.85, right: 4.6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectPage(context, ref, 'projects');
                current = 'Projects';
              });
            },
            child: Container(
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: getColor('Projects'),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Projects',
                  style: TextStyle(
                      color: getTextColor('Projects'),
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectPage(context, ref, 'engineers');
                  current = 'Engineers';
                });
              },
              child: Container(
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: getColor('Engineers'),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Asset Engineers',
                    style: TextStyle(
                        color: getTextColor('Engineers'),
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void toAction() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Snag()));
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
    getTags();
  }

  Color leftBar = Colors.blue;
  Color rightBar = Colors.black45;
  Color leftLine = Colors.blue;
  Color rightLine = Colors.transparent;

  String selectedOpt = 'Work Orders';

  final TextEditingController searchController = TextEditingController();

  List<DocumentSnapshot> tags = [];

  void getTags() async {
    await FirebaseFirestore.instance
        .collection('new_actions')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        tags.add(doc);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final searchField = TextFormField(
        autofocus: false,
        controller: searchController,
        obscureText: false,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          return null;
        },
        onSaved: (value) {
          searchController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "What are you looking for?",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                const BorderSide(color: Colors.orangeAccent, width: 0.8),
          ),
        ));
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
                                ? Stack(
                                    children: [
                                      Container(
                                        height: 600,
                                        child: Column(
                                          children: [
                                            Row(children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20),
                                                  height: 50,
                                                  width: 265,
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black54,
                                                        offset: Offset(
                                                          1.2,
                                                          1.2,
                                                        ),
                                                        blurRadius: 10.0,
                                                        spreadRadius: 2.0,
                                                      ), //BoxShadow
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      SizedBox(
                                                        width: 265,
                                                        child: searchField,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        child: Container(
                                                            height: 36,
                                                            width: 36,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    left: 220),
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            decoration: const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            10)),
                                                                color: Color.fromRGBO(
                                                                    46,
                                                                    55,
                                                                    73,
                                                                    1)),
                                                            child: SvgPicture.asset(
                                                                'assets/images/Combined Shape.svg')),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              161,
                                                              1)),
                                                      child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          child: SvgPicture.asset(
                                                              'assets/images/Group 5 (1).svg')),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Column(
                                              children: [
                                                for (var doc in tags)
                                                  TagClick(
                                                      id: doc.get('id'),
                                                      name: doc.get('name'),
                                                      address:
                                                          doc.get('address'),
                                                      room: doc.get('room'),
                                                      project:
                                                          doc.get('project'),
                                                      asset: doc.get('asset'),
                                                      date: doc
                                                          .get('date_created'),
                                                      assetId:
                                                          doc.get('assetId'),
                                                      description: doc
                                                          .get('description'))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateTag()));
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            margin: const EdgeInsets.only(
                                                top: 400,
                                                right: 20,
                                                bottom: 30),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: Colors.orange),
                                            child: Icon(Icons.add_rounded,
                                                color: Colors.white, size: 35),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
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
                                          const SizedBox(
                                            width: 20,
                                          ),
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
                                                          'assets/images/Group 55591.svg',
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
                                                        'Snag List',
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
        .child('workers/$userId')
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

class TagClick extends StatefulWidget {
  TagClick(
      {Key? key,
      required this.id,
      required this.name,
      required this.address,
      required this.room,
      required this.project,
      required this.asset,
      required this.assetId,
      required this.date,
      required this.description})
      : super(key: key);

  String id;
  String name;
  String address;
  String room;
  String project;
  String asset;
  String assetId;
  String description;
  String date;

  @override
  State<TagClick> createState() => _TagClickState();
}

class _TagClickState extends State<TagClick> {
  String imgUrl = '';

  List assets = [];
  void getAssets() async {
    await FirebaseFirestore.instance
        .collection('assets')
        .where('engineer', isEqualTo: widget.name)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        assets.add(doc.get('name'));
        print('===============================    ' + assets.length.toString());
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssets();
    getProf();
    setState(() {});
  }

  void getProf() async {
    String id = widget.id;
    imgUrl = await FirebaseStorage.instance
        .ref()
        .child('workers/$id')
        .getDownloadURL();
    setState(() {});
  }

  bool value = false;
  Color switchLeft = Colors.white;
  Color switchRight = Colors.transparent;

  String ongoing = '0';

  @override
  Widget build(BuildContext context) {
    setState(() {});
    if (imgUrl == '') {
      getProf();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TagDetails(
                id: widget.id,
                name: widget.name,
                address: widget.address,
                room: widget.room,
                project: widget.project,
                asset: widget.asset,
                assetId: widget.assetId,
                description: widget.description)));
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: 120,
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5),
            color: const Color.fromRGBO(0, 122, 255, 0.1)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 288,
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(237, 245, 254, 1),
                      borderRadius: BorderRadius.circular(14)),
                  child: SvgPicture.asset(
                    'assets/images/user.svg',
                    height: 15,
                    width: 15,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14))),
                )
              ],
            ),
          ),
          Container(
            width: 288,
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(237, 245, 254, 1),
                      borderRadius: BorderRadius.circular(14)),
                  child: SvgPicture.asset(
                    'assets/images/flag.svg',
                    height: 15,
                    width: 15,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.address,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14))),
                )
              ],
            ),
          ),
          Container(
            width: 288,
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(237, 245, 254, 1),
                      borderRadius: BorderRadius.circular(14)),
                  child: SvgPicture.asset(
                    'assets/images/calender.svg',
                    height: 15,
                    width: 15,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.date,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14))),
                )
              ],
            ),
          ),
        ]),
      ),
      // child: Container(
      //   alignment: Alignment.centerLeft,
      //   height: 120,
      //   margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(12.5),
      //       color: const Color.fromRGBO(246, 250, 255, 1)),
      //   child: Stack(
      //     children: [
      //       Align(
      //         alignment: Alignment.centerRight,
      //         child: Container(
      //           height: 30,
      //           width: 84,
      //           alignment: Alignment.center,
      //           decoration: BoxDecoration(
      //               color: Color.fromRGBO(236, 238, 241, 1),
      //               borderRadius: BorderRadius.circular(5)),
      //           child: Text(
      //             'Ongoing : ' + ongoing,
      //             style: TextStyle(
      //               fontSize: 13,
      //               fontWeight: FontWeight.w400,
      //             ),
      //           ),
      //         ),
      //       ),
      //       Row(
      //         children: [
      //           Container(
      //               height: double.infinity,
      //               alignment: Alignment.centerLeft,
      //               child: SingleChildScrollView(
      //                 scrollDirection: Axis.horizontal,
      //                 child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     children: [
      //                       SizedBox(
      //                         height: 20,
      //                       ),
      //                       Container(
      //                         alignment: Alignment.centerLeft,
      //                         margin: const EdgeInsets.only(left: 15),
      //                         child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.start,
      //                             children: [
      //                               Container(
      //                                 height: 20,
      //                                 width: 180,
      //                                 alignment: Alignment.centerLeft,
      //                                 child: Text(widget.name,
      //                                     textAlign: TextAlign.start,
      //                                     style: const TextStyle(
      //                                         color: Colors.black,
      //                                         fontWeight: FontWeight.normal,
      //                                         fontSize: 14)),
      //                               )
      //                             ]),
      //                       ),
      //                       Container(
      //                         height: 20,
      //                         width: 180,
      //                         margin: const EdgeInsets.only(left: 15),
      //                         alignment: Alignment.centerLeft,
      //                         child: Row(
      //                           mainAxisAlignment: MainAxisAlignment.start,
      //                           children: [
      //                             Container(
      //                               height: 15,
      //                               width: 15,
      //                               alignment: Alignment.center,
      //                               decoration: BoxDecoration(
      //                                   // color: Color.fromRGBO(237, 245, 254, 1),
      //                                   borderRadius:
      //                                       BorderRadius.circular(14)),
      //                               child: SvgPicture.asset(
      //                                 'assets/images/flag.svg',
      //                                 height: 15,
      //                                 width: 15,
      //                               ),
      //                             ),
      //                             const SizedBox(width: 3),
      //                             Container(
      //                               alignment: Alignment.centerLeft,
      //                               child: Text(widget.name,
      //                                   style: TextStyle(
      //                                       fontWeight: FontWeight.w400,
      //                                       fontSize: 12)),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                       Container(
      //                         height: 20,
      //                         width: 180,
      //                         margin: const EdgeInsets.only(left: 15),
      //                         alignment: Alignment.centerLeft,
      //                         child: Row(
      //                           mainAxisAlignment: MainAxisAlignment.start,
      //                           children: [
      //                             Container(
      //                               height: 15,
      //                               width: 15,
      //                               alignment: Alignment.center,
      //                               decoration: BoxDecoration(
      //                                   // color: Color.fromRGBO(237, 245, 254, 1),
      //                                   borderRadius:
      //                                       BorderRadius.circular(14)),
      //                               child: SvgPicture.asset(
      //                                 'assets/images/flag.svg',
      //                                 height: 15,
      //                                 width: 15,
      //                               ),
      //                             ),
      //                             const SizedBox(width: 3),
      //                             Container(
      //                               alignment: Alignment.centerLeft,
      //                               child: Text(widget.address,
      //                                   style: TextStyle(
      //                                       fontWeight: FontWeight.w400,
      //                                       fontSize: 12)),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ]),
      //               )),
      //         ],
      //       ),
      //       Align(
      //         alignment: Alignment.bottomRight,
      //         child: Container(
      //           height: 24,
      //           width: 100,
      //           alignment: Alignment.bottomRight,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               Container(
      //                 height: 24,
      //                 width: 56,
      //                 padding: const EdgeInsets.all(2),
      //                 decoration: BoxDecoration(
      //                   color: Colors.orange,
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   children: [
      //                     GestureDetector(
      //                       onTap: () {
      //                         setState(() {
      //                           value = false;
      //                           // switchLeft = Colors.white;
      //                           // switchRight = Colors.transparent;
      //                         });
      //                       },
      //                       child: Container(
      //                         height: 20,
      //                         width: 20,
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(10),
      //                             color: (value == true)
      //                                 ? Colors.transparent
      //                                 : Colors.white),
      //                       ),
      //                     ),
      //                     Expanded(
      //                       child: Align(
      //                         alignment: Alignment.centerRight,
      //                         child: GestureDetector(
      //                           onTap: () {
      //                             setState(() {
      //                               value = true;
      //                               // switchLeft = Colors.transparent;
      //                               // switchRight = Colors.white;
      //                             });
      //                           },
      //                           child: Container(
      //                             height: 20,
      //                             width: 20,
      //                             decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(10),
      //                                 color: (value == false)
      //                                     ? Colors.transparent
      //                                     : Colors.white),
      //                           ),
      //                         ),
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(
      //                 width: 10,
      //               ),
      //               SvgPicture.asset(
      //                 'assets/images/Group 4911 (1).svg',
      //                 height: 24,
      //                 width: 24,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget getPic() {
    if (imgUrl == '') {
      return SvgPicture.asset(
        'assets/images/image 3.svg',
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        imgUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    }
  }
}
