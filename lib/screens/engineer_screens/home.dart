import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:OMTECH/screens/engineer_screens/engineer_home.dart';
import 'package:OMTECH/screens/engineer_screens/profile.dart';

import '../../authentication/login.dart';
import './action.dart';
import './completed.dart';
import './jobs.dart';
import './preventive.dart';
import './reactive.dart';

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return WillPopScope(
      onWillPop: () async {
        return true;
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
            SingleChildScrollView(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                            child: getSmallHolder()),
                      )
                    ],
                  ),
                ),
                Container(
                    height: 650,
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                        // ignore: prefer_const_constructors
                        image: DecorationImage(
                            // ignore: prefer_const_constructors
                            image: AssetImage("assets/images/rect.png"),
                            fit: BoxFit.cover),
                        // ignore: prefer_const_constructors
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(50),
                            topRight: const Radius.circular(50))),
                    child: SingleChildScrollView(
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
                                            'assets/images/study-light-idea.svg',
                                            height: 30,
                                            width: 30,
                                          )),
                                      Container(
                                        height: 60,
                                        width: 80,
                                        alignment: Alignment.center,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
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
                              onTap: () {},
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
                                            'assets/images/Vector (4).svg',
                                            height: 30,
                                            width: 30,
                                          )),
                                      Container(
                                        height: 60,
                                        width: 80,
                                        alignment: Alignment.center,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        child: const Text(
                                          'My Assets',
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
                              onTap: (() {}),
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
                                            'assets/images/Vector (5).svg',
                                            height: 30,
                                            width: 30,
                                          )),
                                      Container(
                                        height: 60,
                                        width: 80,
                                        alignment: Alignment.center,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
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
                    )))
              ]),
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
