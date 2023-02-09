import 'package:OMTECH/screens/company_screens/create_worker.dart';
import 'package:OMTECH/screens/company_screens/worker_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:OMTECH/screens/company_screens/company_home.dart';
import 'package:OMTECH/screens/company_screens/home.dart';
import '../../authentication/login.dart';

class BackPress extends ConsumerWidget {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: () {
          _selectPage(context, ref, 'home');
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

class EngBackPress extends ConsumerWidget {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: () {
          _selectPage(context, ref, 'projects');
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

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

  String current = 'Projects';
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
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
            margin: const EdgeInsets.only(bottom: 100),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromRGBO(255, 174, 0, 1)),
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 50,
            )),
      ),
      body: Container(
        height: 42,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(226, 240, 255, 1),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.only(
            left: 4.6, top: 3.85, bottom: 3.85, right: 4.6),
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
      ),
    );
  }
}

class Workers extends StatefulWidget {
  const Workers({Key? key}) : super(key: key);
  @override
  State<Workers> createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  List<DocumentSnapshot> workers = [];
  List<Map<String, String>> engineersNames = [];
  List docIds = [];

  void getEng() async {
    await FirebaseFirestore.instance
        .collection('workers')
        .where('company', isEqualTo: username)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          workers.add(doc);
        });
      }
    });
  }

  // void getFromEngineers() async {
  //   for (var id in docIds) {
  //     await FirebaseFirestore.instance
  //         .collection('projects')
  //         .doc(id)
  //         .collection('engineers')
  //         .get()
  //         .then((value) {
  //       for (var doc in value.docs) {
  //         engineers.add(doc);
  //         print(engineers.length.toString());
  //       }
  //     });
  //   }
  // }

  final TextEditingController searchController = TextEditingController();

  List projects = [];

  Future<dynamic> getData(String email, String password) async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("projects")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String title = doc.get('title');
        if (title.contains(searchController.text)) {
          projects.add(doc);
        }
      }
    });
  }

  List<DocumentSnapshot> documents = [];
  List<DocumentSnapshot> documentsFiltered = [];

  final filters = <String, String>{
    'Name': 'name',
    'Address': 'address',
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  String filter = 'title';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEng();
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.only(left: 130, top: 00, right: 20),
          content: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 0, bottom: 50),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(237, 245, 255, 1),
                borderRadius: BorderRadius.circular(20)),
            width: 150,
            height: 330,
            child: ListView(
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.bottomRight,
                          child: const Icon(Icons.cancel,
                              color: Colors.orangeAccent, size: 20),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'Filter By',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                for (var item in filters.entries)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filter = item.value;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      margin: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 10),
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        item.key,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    searchController.addListener(() {
      setState(() {});
    });
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
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CreateWorker()));
          },
          child: Container(
              margin: const EdgeInsets.only(bottom: 100),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromRGBO(255, 174, 0, 1)),
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 50,
              )),
        ),
        body: Container(
          color: Colors.white,
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          EngBackPress(),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Workers',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Container(
                            height: 50,
                            width: 265,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Container(
                                      height: 36,
                                      width: 36,
                                      margin: const EdgeInsets.only(left: 220),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Color.fromRGBO(46, 55, 73, 1)),
                                      child: SvgPicture.asset(
                                          'assets/images/Combined Shape.svg')),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: (() => _showDialog()),
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromARGB(255, 255, 161, 1)),
                                child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: SvgPicture.asset(
                                        'assets/images/Group 5 (1).svg')),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 120),
                  child: Column(
                      children: workers
                          .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return WorkerClick(
                              id: document.id,
                              name: data['name'],
                              email: data['email'],
                              phone: data['phone'],
                              address: data['address'],
                            );
                          })
                          .toList()
                          .cast()),
                )
                // .toList()
                // .cast(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WorkerClick extends StatefulWidget {
  WorkerClick({
    Key? key,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  }) : super(key: key);

  String id;
  String name;
  String email;
  String phone;
  String address;

  @override
  State<WorkerClick> createState() => _WorkerClickState();
}

class _WorkerClickState extends State<WorkerClick> {
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
            builder: (BuildContext context) => WorkerDetails(
                  name: widget.name,
                  email: widget.email,
                  phone: widget.phone,
                  address: widget.address,
                  imgUrl: imgUrl,
                )));
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: 120,
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5),
            color: const Color.fromRGBO(246, 250, 255, 1)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 30,
                width: 84,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(236, 238, 241, 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Ongoing : ' + ongoing,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.all(0.25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10), child: getPic()),
                ),
                Container(
                    height: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 180,
                                      alignment: Alignment.centerLeft,
                                      child: Text(widget.name,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14)),
                                    )
                                  ]),
                            ),
                            Container(
                              height: 20,
                              width: 180,
                              margin: const EdgeInsets.only(left: 15),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        // color: Color.fromRGBO(237, 245, 254, 1),
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: SvgPicture.asset(
                                      'assets/images/flag.svg',
                                      height: 15,
                                      width: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(widget.address,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12)),
                                  )
                                ],
                              ),
                            ),
                          ]),
                    )),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 24,
                width: 100,
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 24,
                      width: 56,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                value = false;
                                // switchLeft = Colors.white;
                                // switchRight = Colors.transparent;
                              });
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (value == true)
                                      ? Colors.transparent
                                      : Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    value = true;
                                    // switchLeft = Colors.transparent;
                                    // switchRight = Colors.white;
                                  });
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: (value == false)
                                          ? Colors.transparent
                                          : Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      'assets/images/Group 4911 (1).svg',
                      height: 24,
                      width: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
