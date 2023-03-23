import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:OMTECH/screens/author_screens/create_asset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import '../../tools/drop_buttons.dart';

class AssetBackPress extends ConsumerWidget {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AuthorHome()));
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

class CreateAssetPress extends ConsumerWidget {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  void getProjId(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('projects')
        .where('title', isEqualTo: titleClick)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        projectId.text = doc.id;
      }
    });
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateAsset()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        getProjId(context);
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
    );
  }
}

class AssetsStream extends StatefulWidget {
  AssetsStream({Key? key, required this.title}) : super(key: key);

  String title;

  @override
  State<AssetsStream> createState() => _AssetsStreamState(title: title);
}

class _AssetsStreamState extends State<AssetsStream> {
  _AssetsStreamState({required this.title});
  String title;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  String filter = 'detail';

  List<DocumentSnapshot> documents = [];

  final filters = <String, String>{
    'Manufacturer': 'manufacturer',
    'Title': 'name',
    'Type': 'type',
    'Room': 'room_location'
  };

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: const EdgeInsets.all(0),
          insetPadding:
              const EdgeInsets.only(left: 130, top: 00, right: 20, bottom: 150),
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

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('assets')
      .where('project', isEqualTo: titleClick)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // searchController.addListener(() {
    //   setState(() {});
    // });

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
          hintText: "Search",
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
      floatingActionButton: CreateAssetPress(),
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
                    Stack(
                      children: [
                        AssetBackPress(),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Assets',
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
                  height: 40,
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(left: 30, bottom: 10),
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  )),
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
                              .get(filter)
                              .toString()
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase());
                        }).toList();
                      }

                      return Container(
                          height: 530,
                          margin: const EdgeInsets.only(bottom: 60),
                          child: SingleChildScrollView(
                            child: Column(
                                children: documents
                                    .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data() as Map<String, dynamic>;

                                      return AssetDetailClick(
                                        assetId: document.id,
                                        date: data['date'],
                                        id: data['unique_id'],
                                        name: data['name'],
                                        project: data['project'],
                                        design: data['design'],
                                        serial: data['serial_number'],
                                        location: data['room_location'],
                                        model: data['model'],
                                        status: data['status'],
                                        system: data['system'],
                                        subsystem: data['subsystem'],
                                        type: data['type'],
                                        engineer: data['engineer'],
                                        expectancy: data['expectancy'],
                                        details: data['details'],
                                      );

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



// class FirebaseImage extends StatefulWidget {
//   final String storagePath;

//   FirebaseImage({
//     required this.storagePath,
//   }) : super(key: Key(storagePath));

//   @override
//   State<FirebaseImage> createState() => _FirebaseImageState();
// }

// class _FirebaseImageState extends State<FirebaseImage> {
//   File? _file;

//   @override
//   void initState() {
//     init();
//     super.initState();
//   }

//   Future<void> init() async {
//     final imageFile = await getImageFile();
//     if (mounted) {
//       setState(() {
//         _file = imageFile;
//       });
//     }
//   }

//   Future<File?> getImageFile() async {
//     final storagePath = widget.storagePath;
//     final tempDir = await getTemporaryDirectory();
//     final fileName = widget.storagePath.split('/').last;
//     final file = File('${tempDir.path}/$fileName');

//     // If the file do not exists try to download
//     if (!file.existsSync()) {
//       try {
//         file.create(recursive: true);
//         await FirebaseStorage.instance.ref(storagePath).writeToFile(file);
//       } catch (e) {
//         // If there is an error delete the created file
//         await file.delete(recursive: true);
//         return null;
//       }
//     }
//     return file;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_file == null) {
//       return const Icon(Icons.error);
//     }
//     return Image.file(
//       _file!,
//       width: 100,
//       height: 100,
//     );
//   }
// }
