import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:OMTECH/authentication/login.dart';
import 'package:OMTECH/screens/company_screens/company_home.dart';
import 'package:OMTECH/screens/company_screens/edit_profile.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  Image getIm(String selected) {
    if (selected == 'home') {
      return Image(image: AssetImage('assets/images/homeItem.png'));
    } else {
      return Image(image: AssetImage('assets/images/home (1).png'));
    }
  }

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  Image getIp(String selected) {
    if (selected == 'proj') {
      return const Image(image: AssetImage('assets/images/office bag (2).png'));
    } else {
      return const Image(image: AssetImage('assets/images/office bag.png'));
    }
  }

  BoxDecoration getVis(String visible) {
    if (visible == 'true') {
      return const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Ellipse 132 (2).png')));
    } else {
      return const BoxDecoration(color: Colors.transparent);
    }
  }

  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late int _currentIndex;

  static String selected = 'home';
  static String visHome = 'true';
  static String visProj = '';
  static String projSel = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(46, 55, 73, 1),
                  borderRadius: BorderRadius.circular(0)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                                    image:
                                        AssetImage("assets/images/omlogo.png"),
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
                                  Image(
                                      image: AssetImage(
                                          "assets/images/round.png")),
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
                            image: DecorationImage(
                                // ignore: prefer_const_constructors
                                image: AssetImage("assets/images/rect.png"),
                                fit: BoxFit.cover),
                            // ignore: prefer_const_constructors
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 108,
                                  width: 108,
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(46, 55, 73, 1),
                                      borderRadius: BorderRadius.circular(54)),
                                ),
                                Container(
                                    height: 27,
                                    alignment: Alignment.center,
                                    child: Text(
                                      username,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    )),
                                Container(
                                    height: 21,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '#PM' + userId,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewProfile()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Stack(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/Rectangle (1).svg',
                                              height: 55,
                                              width: 55,
                                            ),
                                            Container(
                                              height: 55,
                                              width: 55,
                                              alignment: Alignment.center,
                                              child: SvgPicture.asset(
                                                'assets/images/Vector.svg',
                                                height: 21,
                                                width: 21,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Container(
                                        height: 55,
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          'My Profile',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/Rectangle (1).svg',
                                            height: 55,
                                            width: 55,
                                          ),
                                          Container(
                                            height: 55,
                                            width: 55,
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              'assets/images/Vector (1).svg',
                                              height: 21,
                                              width: 21,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      height: 55,
                                      width: 120,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Calender',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/Rectangle (1).svg',
                                            height: 55,
                                            width: 55,
                                          ),
                                          Container(
                                            height: 55,
                                            width: 55,
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              'assets/images/newspaper 1.svg',
                                              height: 21,
                                              width: 21,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      height: 55,
                                      width: 120,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Generate Reports',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/Rectangle (1).svg',
                                            height: 55,
                                            width: 55,
                                          ),
                                          Container(
                                            height: 55,
                                            width: 55,
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                              'assets/images/Group 55763.svg',
                                              height: 21,
                                              width: 21,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      height: 55,
                                      width: 120,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Notifications',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    _selectPage(context, ref, 'home');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  },
                                  child: Container(
                                    height: 53,
                                    width: 262,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 174, 0, 1),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    alignment: Alignment.center,
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        child: const Text('LOG OUT',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20))),
                                  ),
                                ))
                          ],
                        ))
                  ])),
        ],
      ),
    );
  }
}
