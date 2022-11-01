import 'dart:io';

import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:OMTECH/tools/drop_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AssetDetailBackPress extends ConsumerWidget {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: () {
          _selectPage(context, ref, 'assets');
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

class CreateAsset extends StatefulWidget {
  const CreateAsset({Key? key}) : super(key: key);

  @override
  State<CreateAsset> createState() => _CreateAssetState();
}

class _CreateAssetState extends State<CreateAsset> {
  int assetDocId = 0;

  bool value = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController(text: '');
  TextEditingController assetID = TextEditingController(text: '');
  TextEditingController design = TextEditingController(text: '');
  TextEditingController model = TextEditingController(text: '');
  TextEditingController serialNumber = TextEditingController(text: '');
  TextEditingController detail = TextEditingController(text: '');

  TextEditingController manufacturerName = TextEditingController(text: '');
  TextEditingController manufacturerEmail = TextEditingController(text: '');
  TextEditingController addressOne = TextEditingController(text: '');
  TextEditingController addressTwo = TextEditingController(text: '');
  TextEditingController addressThree = TextEditingController(text: '');
  TextEditingController phone = TextEditingController(text: '');
  TextEditingController webLink = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        autofocus: false,
        controller: name,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          name.text = value!;
        },
        cursorColor: Colors.black45,
        cursorWidth: 0.8,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'name',
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
          // hintText: "Email",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));

    final serialNumberField = TextFormField(
        autofocus: false,
        controller: serialNumber,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          serialNumber.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Serial Number",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));
    final assetIDField = TextFormField(
        autofocus: false,
        controller: assetID,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          assetID.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Asset Id Field",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));
    final designField = TextFormField(
        autofocus: false,
        controller: design,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          design.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Asset Design ref",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));
    final modelField = TextFormField(
        autofocus: false,
        controller: model,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          model.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          // hintText: "Email",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));
    final detailField = TextFormField(
        autofocus: false,
        controller: detail,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          detail.text = value!;
        },
        textInputAction: TextInputAction.next,
        cursorColor: Colors.black54,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          hintText: 'Add asset description details here',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.transparent, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent, width: 0.2),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Container(
          height: 1400,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    child: Column(children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Stack(
                    children: [
                      AssetDetailBackPress(),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          'Fill Assets Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ])),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: SvgPicture.asset(
                          'assets/images/image 3.svg',
                          height: 86,
                          width: 86,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 24,
                            child: nameField,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (value == false) {
                                setState(() {
                                  value = true;
                                });
                              } else {
                                setState(() {
                                  value = false;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 0.2, color: Colors.black87),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Icon(
                                      Icons.check,
                                      color: checkIcon(),
                                      size: 15,
                                    )),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin:
                                      const EdgeInsets.only(left: 8, top: 20),
                                  child: const Text(
                                    'Verify',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 6),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: double.infinity,
                  height: 50,
                  child: AssetSystems(),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(6)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: double.infinity,
                  height: 50,
                  child: AssetSubSystems(),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: double.infinity,
                  height: 50,
                  child: AssetTypes(
                    action: subsystem,
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: double.infinity,
                  height: 50,
                  child: assetIDField,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: double.infinity,
                  height: 50,
                  child: designField,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  child: Text(titleClick + ' (Project)',
                      style: TextStyle(color: Colors.black87, fontSize: 14)),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.2, color: Colors.black87),
                      borderRadius: BorderRadius.circular(6)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: double.infinity,
                  height: 50,
                  child: Rooms(),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: double.infinity,
                  height: 50,
                  child: serialNumberField,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  width: double.infinity,
                  height: 50,
                  child: Expectancy(),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(0.3),
                  width: double.infinity,
                  height: 200,
                  child: SingleChildScrollView(child: detailField),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.2, color: Colors.black87),
                      borderRadius: BorderRadius.circular(8)),
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      addNewAsset();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 285,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 174, 0, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Save Details',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 300,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getData() {
    //  final DocumentReference user =
    List assetsList = [];
    setState(() {
      assetDocId = assetsList.length;
    });
    return FirebaseFirestore.instance.collection("assets").get().then((value) {
      for (var doc in value.docs) {
        assetsList.add(doc.id);
        var temp = assetsList.length;
        if (assetsList.contains(temp.toString())) {
          setState(() {
            assetDocId = assetsList.length + 1;
          });
        } else {
          setState(() {
            assetDocId = assetsList.length;
          });
        }
      }
    });
  }

  Future<void> addNewAsset() {
    String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
    return FirebaseFirestore.instance
        .collection('assets')
        .doc(assetDocId.toString())
        .set({
      'date': dateNow,
      'name': name.text,
      'project': titleClick,
      'room_location': roomsButton,
      'serial_number': serialNumber.text,
      'unique_id': assetID.text,
      'design': design.text,
      'model': model.text,
      'system': systemButton,
      'subsystem': subsystemButton,
      'type': assetTypeButton,
      'engineer': '',
      'expectancy': expectancyButton,
      'details': detail.text,
      'status': checkBox()
    }).then((value) => {
              // _showDialog('Asset Added')
            });
  }

  dynamic assetImg;

  String? imgAsset;

  String? imgUrl;

  Future<void> _pickImage() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'svg'],
    );

    PlatformFile plat = result!.files.first;

    // if no file is picked
    if (result == null) return;

    setState(() {
      assetImg = result.files.first.bytes;
      imgAsset = result.files.first.name;
    });

    FirebaseFirestore.instance
        .collection('images')
        .doc(assetDocId.toString())
        .set({'name': imgAsset, 'asset': assetDocId.toString()});

    await FirebaseStorage.instance
        .ref('asset_images/$imgAsset')
        .putData(assetImg);

    final ref = FirebaseStorage.instance.ref().child('asset_images/$imgAsset');
    // no need of the file extension, the name will do fine.
    String temp = await ref.getDownloadURL();
    setState(() {
      imgUrl = temp;
    });
    print(imgUrl);
  }

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);

      setState(() {
        this.image = imageTemp;
        imgAsset = image.name;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    await FirebaseFirestore.instance
        .collection('images')
        .doc(assetDocId.toString())
        .set({'name': imgAsset, 'asset': assetDocId.toString()});
  }

  String checkBox() {
    if (value == true) {
      return 'Verified';
    } else {
      return 'Not Verified';
    }
  }

  Color checkIcon() {
    if (value == true) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}
