import 'package:OMTECH/screens/worker_screens/work_order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../authentication/login.dart';

import 'worker_home.dart';

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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => WorkerHome()));
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

class PreventiveM extends StatefulWidget {
  const PreventiveM({Key? key}) : super(key: key);

  @override
  State<PreventiveM> createState() => _PreventiveMState();
}

class _PreventiveMState extends State<PreventiveM> {
  final TextEditingController searchController = TextEditingController();

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
        // You can do some work here.
        // Returning true allows the pop to happen, returning false prevents it.
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          BackPress(),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Preventative Maintenance',
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
                            width: 320,
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
                                  width: 320,
                                  child: searchField,
                                ),
                                Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: 36,
                                      width: 36,
                                      margin: const EdgeInsets.only(left: 275),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color:
                                              Color.fromARGB(255, 255, 161, 1)),
                                      child: SvgPicture.asset(
                                          'assets/images/Combined Shape.svg')),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _usersStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const SizedBox(
                              height: 100,
                              child:
                                  Center(child: Text('Something went wrong')));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                              height: 100,
                              child: Center(child: Text("Loading...")));
                        }

                        documents = snapshot.data!.docs;
                        if (searchController.text.length > 0) {
                          documents = documents.where((element) {
                            return element
                                .get('name')
                                .toString()
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase());
                          }).toList();
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return AlertDialog(
                            title: const Text('No work orders found'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  // Text('This is a demo alert dialog.'),
                                  // Text('Would you like to approve of this message?'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          WorkerHome())); // pop current page
                                  // push it back in
                                },
                              ),
                            ],
                          );
                        }

                        return Container(
                            height: 600,
                            margin: const EdgeInsets.only(bottom: 150),
                            child: ListView(
                                children:
                                    documents.map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              return WorkOrderClick(
                                status: data['status'],
                                priority: data['priority'],
                                name: data['name'],
                                category: data['category'],
                                address: data['address'],
                                date: data['date'],
                                project: data['project'],
                                room: data['room'],
                                author: data['author'],
                                client: data['client'],
                                engineer: data['engineer'],
                                company: data['assignee'],
                                date_created: data['date_created'],
                                lastMaintained: data['last_maintained'],
                                asset: data['asset'],
                                assetId: data['asset_id'],
                                creator: data['created_by'],
                                nature: data['nature'],
                                frequency: data['frequency'],
                                id: document.id,
                              );
                            }).toList()));
                      }
                      // children:

                      ),
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

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('new_work_orders')
      .where('worker', isEqualTo: username)
      .where('nature', isEqualTo: 'Preventative')
      .snapshots();

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
}

class WorkOrderClick extends ConsumerStatefulWidget {
  WorkOrderClick(
      {required this.name,
      required this.category,
      required this.status,
      required this.date,
      required this.address,
      required this.project,
      required this.author,
      required this.client,
      required this.date_created,
      required this.company,
      required this.room,
      required this.creator,
      required this.frequency,
      required this.nature,
      required this.lastMaintained,
      required this.asset,
      required this.engineer,
      required this.id,
      required this.priority,
      required this.assetId});

  String priority;
  String status;

  String name;
  String category;
  String date;
  String address;
  String project;
  String author;
  String client;
  String date_created;
  String company;
  String room;
  String creator;
  String frequency;
  String nature;
  String lastMaintained;
  String asset;
  String engineer;
  String id;
  String assetId;

  @override
  ConsumerState<WorkOrderClick> createState() => _WorkOrderClickState();
}

class _WorkOrderClickState extends ConsumerState<WorkOrderClick> {
  _WorkOrderClickState();

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImg();
  }

  String imgUrl = '';
  String assetDesignRef = '';

  Future<void> getImg() async {
    String name = '';
    String design = '';
    await FirebaseFirestore.instance
        .collection('assets')
        .where('unique_id', isEqualTo: widget.assetId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          name = doc.id;
          design = doc.get('design');
          print(name);
        });
      }
    });
    await FirebaseFirestore.instance
        .collection('images')
        .where('asset', isEqualTo: name)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          name = doc.get('name');
          print(name);
        });
      }
    });
    final ref =
        await FirebaseStorage.instance.ref().child('asset_images/$name');
    // no need of the file extension, the name will do fine.
    String temp = await ref.getDownloadURL();
    setState(() {
      imgUrl = temp;
      assetDesignRef = design;
      print('????????????????????????????????????' + imgUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WorkOrderDetails(
                  name: widget.name,
                  status: widget.status,
                  category: widget.category,
                  date: widget.date,
                  address: widget.address,
                  project: widget.project,
                  author: widget.author,
                  client: widget.client,
                  date_created: widget.date_created,
                  company: widget.company,
                  room: widget.room,
                  creator: widget.creator,
                  frequency: widget.frequency,
                  nature: widget.nature,
                  lastMaintained: widget.lastMaintained,
                  asset: widget.asset,
                  engineer: widget.engineer,
                  id: widget.id,
                  assetId: widget.assetId,
                  assetDesignRef: assetDesignRef,
                  imgUrl: imgUrl)));
        },
        child: Stack(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 140,
              margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(0, 122, 255, 0.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 120,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14))),
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
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14))),
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
                                    'assets/images/category.svg',
                                    height: 15,
                                    width: 15,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(widget.category,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14))),
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
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14))),
                                )
                              ],
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  margin: const EdgeInsets.only(top: 24, right: 24),
                  child: widget.priority == 'High'
                      ? SvgPicture.asset(
                          'assets/images/high.svg',
                          height: 32,
                          width: 58,
                        )
                      : widget.priority == 'Medium'
                          ? SvgPicture.asset('assets/images/medium.svg')
                          : SvgPicture.asset('assets/images/Group 31.svg')),
            )
          ],
        ));
  }
}
