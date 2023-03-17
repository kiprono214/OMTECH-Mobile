import 'package:OMTECH/screens/worker_screens/worker_home.dart';
import 'package:OMTECH/screens/worker_screens/create_asset.dart';
import 'package:OMTECH/tools/drop_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

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
          Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        getProjId(context);
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 50),
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

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('assets')
      .where('project', isEqualTo: titleClick)
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
                      height: 10,
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
                              .get('name')
                              .toString()
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase());
                        }).toList();
                      }

                      return Container(
                          height: 600,
                          margin: const EdgeInsets.only(bottom: 120),
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
