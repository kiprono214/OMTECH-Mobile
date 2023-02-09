import 'package:OMTECH/screens/author_screens/engineer_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

class Assigned extends StatefulWidget {
  const Assigned({Key? key}) : super(key: key);

  @override
  State<Assigned> createState() => _AssignedState();
}

class _AssignedState extends State<Assigned> {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('projects')
      .where('company', isEqualTo: username)
      .snapshots();

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
    'Title': 'title',
    'Client': 'client',
    'Address': 'address',
    'Manager': 'managerName',
    'Project Status': 'status'
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

  List<List> companyProjects = [];

  List<DocumentSnapshot> projectsList = [];

  void getCompanyProjects() async {
    List temp = [];
    companyProjects.clear();
    await FirebaseFirestore.instance
        .collection('company_projects')
        .where('company', isEqualTo: userId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        temp.add(doc.get('company'));
        temp.add(doc.get('project'));
        companyProjects.add(temp);
      }
    });
    getProjects();
  }

  int index = 0;

  void getProjects() async {
    projectsList.clear();
    await FirebaseFirestore.instance.collection('projects').get().then((value) {
      for (var doc in value.docs) {
        if (companyProjects[index][1].contains(doc.id)) {
          projectsList.add(doc);
        }
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getCompanyProjects();

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
        endDrawer: Drawer(
          width: 240,
          backgroundColor: const Color.fromRGBO(237, 245, 255, 1),
          child: ListView(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 80),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Filter By',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    margin:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 10),
                    padding: const EdgeInsets.only(left: 30),
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
                          BackPress(),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'My Projects',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 13,
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
                Column(
                  children: [
                    for (var doc in projectsList)
                      AssetClick(
                          title: doc.get('title'), address: doc.get('address'))
                  ],
                )
                // StreamBuilder<QuerySnapshot>(
                //     stream: _usersStream,
                //     builder: (BuildContext context,
                //         AsyncSnapshot<QuerySnapshot> snapshot) {
                //       if (snapshot.hasError) {
                //         return const SizedBox(
                //             height: 100,
                //             child: Center(child: Text('Something went wrong')));
                //       }

                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return const SizedBox(
                //             height: 100,
                //             child: Center(child: Text("Loading...")));
                //       }

                //       documents = snapshot.data!.docs;
                //       if (searchController.text.length > 0) {
                //         documents = documents.where((element) {
                //           return element
                //               .get(filter)
                //               .toString()
                //               .toLowerCase()
                //               .contains(searchController.text.toLowerCase());
                //         }).toList();
                //       }

                //       return Container(
                //           height: MediaQuery.of(context).size.height,
                //           child: ListView(
                //               children:
                //                   documents.map((DocumentSnapshot document) {
                //             Map<String, dynamic> data =
                //                 document.data()! as Map<String, dynamic>;

                //             return AssetClick(
                //               title: data['title'],
                //               address: data['address'],
                //             );
                //           }).toList()));
                //     }
                // children:

                // )
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

class AssetClick extends ConsumerStatefulWidget {
  AssetClick({required this.title, required this.address});
  final String title;
  final String address;

  @override
  ConsumerState<AssetClick> createState() =>
      _AssetClickState(title: title, address: address);
}

class _AssetClickState extends ConsumerState<AssetClick> {
  _AssetClickState({required this.title, required this.address});

  String title;
  String address;
  String assets = '0';

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  void getAssets(String title) async {
    List assetsList = [];
    await FirebaseFirestore.instance
        .collection('assets')
        .where('project', isEqualTo: title)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        assetsList.add(doc.id);
        setState(() {
          assets = assetsList.length.toString();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssets(title);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: () {
          _selectPage(context, ref, 'assets');
          titleClick = title;
        },
        child: Container(
            alignment: Alignment.centerLeft,
            height: 140,
            margin: const EdgeInsets.only(top: 6, left: 20, right: 20),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(0, 122, 255, 0.1)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 30,
                            width: 130,
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: const Text("Project Title : ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                                height: 30,
                                width: 280,
                                alignment: Alignment.centerLeft,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(title,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14)),
                                )))
                      ]),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Row(children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 30,
                        width: 130,
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: const Text("Address : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            height: 30,
                            width: 280,
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(address,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14)),
                            )))
                  ]),
                ),
                Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  child: Row(children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 30,
                        width: 130,
                        alignment: Alignment.centerLeft,
                        child: const Text("No Of Assets : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 30,
                        width: 280,
                        alignment: Alignment.centerLeft,
                        child: Text(assets,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14)))
                  ]),
                ),
              ]),
            )));
  }
}

class Engineers extends StatefulWidget {
  const Engineers({Key? key}) : super(key: key);
  @override
  State<Engineers> createState() => _EngineersState();
}

class _EngineersState extends State<Engineers> {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  List<DocumentSnapshot> engineers = [];
  List<Map<String, String>> engineersNames = [];
  List docIds = [];

  void getEng() async {
    await FirebaseFirestore.instance
        .collection('projects')
        .where('managerName', isEqualTo: username)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        docIds.add(doc.id);
        print(docIds.length.toString());
      }
    });
    for (var id in docIds) {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(id)
          .collection('engineers')
          .get()
          .then((value) {
        for (var doc in value.docs) {
          if (engineersNames.length > 0) {
            for (Map docIn in engineersNames) {
              if (docIn.entries.first.value == doc.get('name')) {
              } else {
                String id = doc.id;
                String name = doc.get('name');
                engineersNames.add(<String, String>{id: name});
              }
            }
          } else {
            String id = doc.id;
            String name = doc.get('name');
            engineersNames.add(<String, String>{id: name});
          }

          setState(() {});
          print(engineers.length.toString());
        }
      });
    }
    for (var docEn in engineersNames) {
      await FirebaseFirestore.instance
          .collection('engineers')
          .where('name', isEqualTo: docEn.entries.first.value)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          engineers.add(doc);
          setState(() {});
          print(engineers.length.toString());
        }
      });
    }
  }

  void getFromEngineers() async {
    for (var id in docIds) {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(id)
          .collection('engineers')
          .get()
          .then((value) {
        for (var doc in value.docs) {
          engineers.add(doc);
          print(engineers.length.toString());
        }
      });
    }
  }

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
                      const SizedBox(
                        height: 40,
                      ),
                      Stack(
                        children: [
                          EngBackPress(),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Asset Engineers',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 13,
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
                Column(
                    children: engineers
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return EngineerClick(
                            id: document.id,
                            name: data['name'],
                            email: data['email'],
                            phone: data['phone'],
                            address: data['address'],
                          );
                        })
                        .toList()
                        .cast())
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

class EngineerClick extends ConsumerStatefulWidget {
  EngineerClick({
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
  ConsumerState<EngineerClick> createState() => _EngineerClickState();
}

class _EngineerClickState extends ConsumerState<EngineerClick> {
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
        .child('engineers/$id')
        .getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    if (imgUrl == '') {
      getProf();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EngineerDetails(
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
            color: const Color.fromRGBO(0, 122, 255, 0.1)),
        child: Row(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 30,
                                    width: 50,
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: const Text("Name : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                        height: 30,
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(widget.name,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14)),
                                        )))
                              ]),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                height: 30,
                                width: 50,
                                alignment: Alignment.centerLeft,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: const Text('Assets : ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                    height: 30,
                                    width: 120,
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(assets.length.toString(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14)),
                                    )))
                          ]),
                        ),
                      ]),
                )),
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
