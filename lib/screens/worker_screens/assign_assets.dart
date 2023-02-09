import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignAssets extends StatefulWidget {
  AssignAssets({Key? key, required this.name}) : super(key: key);

  String name;

  @override
  State<AssignAssets> createState() => _AssignAssetsState();
}

class _AssignAssetsState extends State<AssignAssets> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('assets')
      .where('engineer', isEqualTo: '')
      .snapshots();

  List<DocumentSnapshot> documents = [];

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Assign Assets',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
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
                            width: double.infinity,
                            child: searchField,
                          ),
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 5),
                            child: Container(
                                height: 36,
                                width: 36,
                                margin: const EdgeInsets.only(left: 280),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color.fromRGBO(255, 204, 3, 1)),
                                child: SvgPicture.asset(
                                    'assets/images/Combined Shape.svg')),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const SizedBox(
                            height: 100,
                            child: Center(child: Text('Something went wrong')));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
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

                      return Container(
                          height: 560,
                          padding: const EdgeInsets.only(bottom: 20, top: 20),
                          child: SingleChildScrollView(
                            child: Column(
                                children: documents
                                    .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data() as Map<String, dynamic>;

                                      return AssignClick(
                                          engineerName: widget.name,
                                          name: data['name'],
                                          type: data['type'],
                                          assetId: document.id,
                                          location: data['room_location']);

                                      // data['room_location']
                                    })
                                    .toList()
                                    .cast()),
                          ));
                    }
                    // children:

                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AssignClick extends StatefulWidget {
  AssignClick(
      {Key? key,
      required this.name,
      required this.type,
      required this.location,
      required this.assetId,
      required this.engineerName})
      : super(key: key);

  String name;
  String type;
  String location;
  String assetId;
  String engineerName;

  @override
  State<AssignClick> createState() => _AssignClickState();
}

class _AssignClickState extends State<AssignClick> {
  String imgUrl = '';

  Future<void> getImg() async {
    await FirebaseFirestore.instance
        .collection('images')
        .where('asset', isEqualTo: widget.assetId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          imgUrl = doc.get('name');
          print(widget.assetId);
        });
      }
    });
    final ref =
        await FirebaseStorage.instance.ref().child('asset_images/$imgUrl');
    // no need of the file extension, the name will do fine.
    String temp = await ref.getDownloadURL();
    setState(() {
      imgUrl = temp;
      print('????????????????????????????????????' + imgUrl);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImg();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAssignDialog();
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
                                    width: 48,
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: const Text("Title : ",
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
                                width: 46,
                                alignment: Alignment.centerLeft,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: const Text("Type : ",
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
                                      child: Text(widget.type,
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
                                width: 48,
                                alignment: Alignment.centerLeft,
                                child: const Text("Room : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                height: 30,
                                width: 120,
                                alignment: Alignment.centerLeft,
                                child: Text(widget.location,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14)))
                          ]),
                        ),
                      ]),
                )),
          ],
        ),
      ),
    );
  }

  Future showAssignDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            content: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Container(
                      height: 148,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        'Assign ' +
                            widget.name +
                            ' to ' +
                            widget.engineerName +
                            '?',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      color: Colors.black54,
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 139,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400),
                                  ))),
                          Container(
                            height: double.infinity,
                            width: 1,
                            margin: const EdgeInsets.only(bottom: 10, top: 4),
                            color: Colors.black54,
                          ),
                          GestureDetector(
                              onTap: () {
                                getAssetAssign(context);
                              },
                              child: Container(
                                width: 139,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text('Confirm',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue)),
                              ))
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }

  void getAssetAssign(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('assets')
        .doc(widget.assetId)
        .update({'engineer': widget.engineerName}).then((value) {
      Navigator.pop(context);
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => AssignAssets(name: widget.engineerName)));
    });
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
