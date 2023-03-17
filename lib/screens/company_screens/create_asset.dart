// import 'dart:io';
// import 'dart:typed_data';

// import 'package:OMTECH/screens/company_screens/company_home.dart';
// import 'package:OMTECH/tools/drop_buttons.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// class AssetDetailBackPress extends ConsumerWidget {
//   void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
//     if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
//       ref.read(selectedNavPageNameProvider.state).state = pageName;
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return GestureDetector(
//         onTap: () {
//           Navigator.of(context).pop();
//         },
//         child: Container(
//             width: 60,
//             alignment: Alignment.bottomLeft,
//             child: const Icon(Icons.arrow_back)));
//   }
// }

// class CreateAsset extends StatefulWidget {
//   const CreateAsset({Key? key}) : super(key: key);

//   @override
//   State<CreateAsset> createState() => _CreateAssetState();
// }

// class _CreateAssetState extends State<CreateAsset> {
//   int assetDocId = 0;

//   int attachmentDocId = 0;

//   int manufacturerDocId = 0;

//   bool value = false;

//   final _formKey = GlobalKey<FormState>();

//   TextEditingController name = TextEditingController(text: '');
//   TextEditingController assetID = TextEditingController(text: '');
//   TextEditingController design = TextEditingController(text: '');
//   TextEditingController model = TextEditingController(text: '');
//   TextEditingController serialNumber = TextEditingController(text: '');
//   TextEditingController detail = TextEditingController(text: '');

//   TextEditingController manufacturerName = TextEditingController(text: '');
//   TextEditingController manufacturerEmail = TextEditingController(text: '');
//   TextEditingController addressOne = TextEditingController(text: '');
//   TextEditingController addressTwo = TextEditingController(text: '');
//   TextEditingController addressThree = TextEditingController(text: '');
//   TextEditingController phone = TextEditingController(text: '');
//   TextEditingController webLink = TextEditingController(text: '');

//   @override
//   void initState() {
//     super.initState();
//     getData();
//     projectName.text = titleClick;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final nameField = TextFormField(
//         autofocus: false,
//         controller: name,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           name.text = value!;
//         },
//         cursorColor: Colors.black45,
//         cursorWidth: 0.8,
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           hintText: 'name',
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
//           // hintText: "Email",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(3),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(3),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));

//     final serialNumberField = TextFormField(
//         autofocus: false,
//         controller: serialNumber,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           serialNumber.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Serial Number",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));
//     final assetIDField = TextFormField(
//         autofocus: false,
//         controller: assetID,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           assetID.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Asset Id Field",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));
//     final designField = TextFormField(
//         autofocus: false,
//         controller: design,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           design.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Asset Design ref",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));
//     final modelField = TextFormField(
//         autofocus: false,
//         controller: model,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           model.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           // hintText: "Email",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));
//     final detailField = TextFormField(
//         autofocus: false,
//         controller: detail,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           detail.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         cursorColor: Colors.black54,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//           hintText: 'Add asset description details here',
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.transparent, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: Colors.transparent, width: 0.2),
//           ),
//         ));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Form(
//         key: _formKey,
//         child: Container(
//           height: 1400,
//           alignment: Alignment.topCenter,
//           padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                     child: Column(children: [
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   Stack(
//                     children: [
//                       AssetDetailBackPress(),
//                       Container(
//                         width: double.infinity,
//                         alignment: Alignment.center,
//                         child: const Text(
//                           'Fill Assets Details',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 22),
//                         ),
//                       )
//                     ],
//                   ),
//                 ])),
//                 const SizedBox(height: 10),
//                 Container(
//                   width: double.infinity,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       getHolder(),
//                       const SizedBox(
//                         width: 6,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 150,
//                             height: 24,
//                             child: nameField,
//                           ),
//                           Container(
//                             height: 20,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   margin: const EdgeInsets.only(bottom: 6),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: AssetSystems(),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(6)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   width: double.infinity,
//                   height: 50,
//                   child: AssetSubSystems(),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: AssetTypes(
//                     action: subsystem,
//                   ),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: assetIDField,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: designField,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   padding: const EdgeInsets.only(left: 20),
//                   alignment: Alignment.centerLeft,
//                   width: double.infinity,
//                   height: 50,
//                   child: Text(titleClick + ' (Project)',
//                       style: TextStyle(color: Colors.black87, fontSize: 14)),
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 0.2, color: Colors.black87),
//                       borderRadius: BorderRadius.circular(6)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: Rooms(
//                     title: titleClick,
//                   ),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: serialNumberField,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: Expectancy(),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   padding: const EdgeInsets.all(0.3),
//                   width: double.infinity,
//                   height: 200,
//                   child: SingleChildScrollView(child: detailField),
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 0.2, color: Colors.black87),
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _showManufacturerDialog();
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 8),
//                     child: Row(
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           height: 18,
//                           width: 18,
//                           child: Icon(
//                             Icons.add,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(9),
//                               color: Colors.black),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Container(
//                           height: 18,
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Add Manufacturer Details',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 decoration: TextDecoration.underline),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _showDocDialog();
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 8, bottom: 28),
//                     child: Row(
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           height: 18,
//                           width: 18,
//                           child: Icon(
//                             Icons.add,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(9),
//                               color: Colors.black),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Container(
//                           height: 18,
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Upload Documents',
//                             style: TextStyle(fontSize: 14),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     if (_formKey.currentState!.validate()) {
//                       addNewAsset();
//                     }
//                   },
//                   child: Container(
//                     height: 50,
//                     width: 285,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: const Color.fromRGBO(255, 174, 0, 1),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: const Text(
//                       'Save Details',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 300,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> getData() {
//     //  final DocumentReference user =
//     List assetsList = [];
//     setState(() {
//       assetDocId = assetsList.length;
//     });
//     return FirebaseFirestore.instance.collection("assets").get().then((value) {
//       for (var doc in value.docs) {
//         assetsList.add(doc.id);
//         var temp = assetsList.length;
//         if (assetsList.contains(temp.toString())) {
//           setState(() {
//             assetDocId = assetsList.length + 1;
//           });
//         } else {
//           setState(() {
//             assetDocId = assetsList.length;
//           });
//         }
//       }
//     });
//   }

//   Widget getHolder() {
//     if (assetImg == null) {
//       return GestureDetector(
//         onTap: (() {
//           pickImage();
//         }),
//         child: Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
//           child: SvgPicture.asset(
//             'assets/images/image 3.svg',
//             height: 86,
//             width: 86,
//             fit: BoxFit.cover,
//           ),
//         ),
//       );
//     } else {
//       return GestureDetector(
//         onTap: (() {
//           pickImage();
//         }),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(6),
//           child: Image.network(
//             assetImg!,
//             height: 86,
//             width: 86,
//             fit: BoxFit.cover,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> addNewAsset() {
//     String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
//     if (subsystemButton == null) {
//       subsystemButton = '';
//     }
//     if (assetTypeButton == null) {
//       assetTypeButton = '';
//     }
//     if (roomsButton == null) {}
//     return FirebaseFirestore.instance
//         .collection('assets')
//         .doc(assetDocId.toString())
//         .set({
//       'date': dateNow,
//       'name': name.text,
//       'project': titleClick,
//       'room_location': roomName.text,
//       'serial_number': serialNumber.text,
//       'unique_id': assetID.text,
//       'design': design.text,
//       'model': model.text,
//       'system': systemButton,
//       'subsystem': subsystemButton,
//       'type': assetTypeButton,
//       'engineer': '',
//       'expectancy': expectancyButton,
//       'details': detail.text,
//       'status': 'Not Verified'
//     }).then((value) => {_showDialog('Asset Added')});
//   }

//   Future<void> _showDialog(String? message) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(message!),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: const <Widget>[
//                 // Text('This is a demo alert dialog.'),
//                 // Text('Would you like to approve of this message?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 // Navigator.of(context).pop();
//                 Navigator.pop(context); // pop current page
//                 Navigator.of(context).pop(); // push it back in
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String? assetImg;

//   String? imgAsset;

//   String? imgUrl;

//   Future<void> _pickImage() async {
//     // opens storage to pick files and the picked file or files
//     // are assigned into result and if no file is chosen result is null.
//     // you can also toggle "allowMultiple" true or false depending on your need
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'png', 'svg'],
//     );

//     PlatformFile plat = result!.files.first;

//     // if no file is picked
//     if (result == null) return;

//     setState(() {
//       // assetImg = result.files.first.bytes;
//       imgAsset = result.files.first.name;
//     });

//     FirebaseFirestore.instance
//         .collection('images')
//         .doc(assetDocId.toString())
//         .set({'name': imgAsset, 'asset': assetDocId.toString()});

//     // await FirebaseStorage.instance
//     //     .ref('asset_images/$imgAsset')
//     //     .putData(assetImg);

//     final ref = FirebaseStorage.instance.ref().child('asset_images/$imgAsset');
//     // no need of the file extension, the name will do fine.
//     String temp = await ref.getDownloadURL();
//     setState(() {
//       imgUrl = temp;
//     });
//     print(imgUrl);
//   }

//   File? image;
//   Future pickImage() async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (image == null) return;
//       final imageTemp = File(image.path);

//       setState(() {
//         this.image = imageTemp;
//         imgAsset = image.name;
//       });
//     } on PlatformException catch (e) {
//       print('Failed to pick image: $e');
//     }
//     await FirebaseFirestore.instance
//         .collection('images')
//         .doc(assetDocId.toString())
//         .set({'name': imgAsset, 'asset': assetDocId.toString()});

//     if (image != null) {
//       //Upload to Firebase
//       var snapshot = await FirebaseStorage.instance
//           .ref()
//           .child('asset_images/$imgAsset')
//           .putFile(image!);
//       var downloadUrl = await snapshot.ref.getDownloadURL();
//       setState(() {
//         assetImg = downloadUrl;
//       });
//     } else {
//       print('No Image Path Received');
//     }
//   }

//   List<Map<dynamic, dynamic>> filesDynamo = [];

//   String upload = 'not yet';

//   String filename = '';

//   dynamic fileBytes;

//   int att = 0;

//   Future uploadFile(BuildContext context) async {
//     for (var file in filesDynamo) {
//       String tempName = file.entries.first.key;
//       dynamic tempBytes = file.entries.first.value;
//       await FirebaseStorage.instance.ref('attachments/$tempName').putFile(
//             File(tempBytes),
//           );
//     }
//     Navigator.pop(context);
//   }

//   Future<void> _pickFile() async {
//     // opens storage to pick files and the picked file or files
//     // are assigned into result and if no file is chosen result is null.
//     // you can also toggle "allowMultiple" true or false depending on your need
//     final result = await FilePicker.platform.pickFiles(allowMultiple: false);

//     PlatformFile plat = result!.files.first;

//     // if no file is picked
//     if (result == null) return;

//     var fileMap = <String, PlatformFile>{result.files.first.name: plat};

//     final fileName = result.files.first.name;

//     setState(() {
//       fileBytes = result.files.first.path;
//       filename = result.files.first.name;
//       filesDynamo.add({filename: fileBytes});
//     });

//     List docs = [];

//     FirebaseFirestore.instance.collection('attachments').get().then((value) {
//       for (var doc in value.docs) {
//         var name = doc.get('name');
//         docs.add(name);
//         setState(() {
//           att = docs.length;
//         });
//         print(docs.length.toString());
//       }
//     });

//     if (documentButton == null) {
//       documentButton = 'User Directory';
//     }

//     FirebaseFirestore.instance
//         .collection('attachments')
//         .doc(attachmentDocId.toString())
//         .set({
//       'name': filename,
//       'type': documentButton,
//       'asset': assetDocId.toString()
//     });
//     getDoc();
//   }

//   Future<void> _showDocDialog() async {
//     getDoc();
//     return showDialog<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(0),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             content: Container(
//               height: 400,
//               width: 600,
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                   color: const Color.fromRGBO(19, 18, 29, 1),
//                   borderRadius: BorderRadius.circular(20)),
//               child: Column(children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     height: 20,
//                     width: double.infinity,
//                     alignment: Alignment.centerRight,
//                     child: const Icon(Icons.cancel,
//                         size: 20, color: Colors.orange),
//                   ),
//                 ),
//                 Container(
//                   width: 600,
//                   alignment: Alignment.center,
//                   child: const Text(
//                     'Upload Document',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Container(height: 50, width: 240, child: DocumentType()),
//                 Container(
//                     height: 120,
//                     width: 300,
//                     alignment: Alignment.topCenter,
//                     child: GetAtts(
//                       assetDocId: assetDocId,
//                     )),
//                 Container(
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     child: GestureDetector(
//                       onTap: () {
//                         _pickFile();
//                       },
//                       child: const Text(
//                         'upload attachment',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     )),
//                 Align(
//                   alignment: Alignment.center,
//                   child: GestureDetector(
//                     onTap: () {
//                       uploadFile(context);
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(top: 20),
//                       alignment: Alignment.center,
//                       height: 50,
//                       width: 200,
//                       decoration: BoxDecoration(
//                           color: const Color.fromRGBO(200, 169, 86, 1),
//                           borderRadius: BorderRadius.circular(8)),
//                       child: const Text('Submit',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700)),
//                     ),
//                   ),
//                 )
//               ]),
//             ),
//           );
//         });
//   }

//   Future<void> _showManufacturerDialog() async {
//     getManDoc();
//     final nameField = TextFormField(
//         autofocus: false,
//         controller: manufacturerName,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           manufacturerName.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Manufacturer's name",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final emailField = TextFormField(
//         autofocus: false,
//         controller: manufacturerEmail,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation
//           if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
//               .hasMatch(value)) {
//             return ("Please Enter a valid email");
//           }

//           return null;
//         },
//         onSaved: (value) {
//           manufacturerEmail.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Manufacturer's email",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final addressOneField = TextFormField(
//         autofocus: false,
//         controller: addressOne,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           addressOne.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Address One",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final addressTwoField = TextFormField(
//         autofocus: false,
//         controller: addressTwo,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           return null;
//         },
//         onSaved: (value) {
//           addressTwo.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Address Two(optional)",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final addressThreeField = TextFormField(
//         autofocus: false,
//         controller: addressThree,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           return null;
//         },
//         onSaved: (value) {
//           addressThree.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Address Three(optional)",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final phoneField = TextFormField(
//         autofocus: false,
//         controller: phone,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           if (!RegExp("^[0-9]").hasMatch(value)) {
//             return ("Please Enter required details");
//           }
//           if (value.length < 10 || value.length > 12) {
//             return ('Your input is not valid');
//           }
//           if (RegExp("^[A-Za-z]").hasMatch(value)) {
//             return ("Please Enter required details");
//           }

//           return null;
//         },
//         onSaved: (value) {
//           phone.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Telephone",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final webLinkField = TextFormField(
//         autofocus: false,
//         controller: webLink,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           return null;
//         },
//         onSaved: (value) {
//           webLink.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Manufacturer's website(optional)",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final manForm = GlobalKey<FormState>();
//     return showDialog<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(0),
//             backgroundColor: Colors.transparent,
//             elevation: 5,
//             content: Form(
//               key: manForm,
//               child: SingleChildScrollView(
//                 child: Container(
//                   height: 500,
//                   width: 360,
//                   padding: const EdgeInsets.all(15),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: const Color.fromRGBO(233, 232, 235, 1),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: SingleChildScrollView(
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: nameField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: emailField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: addressOneField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: addressTwoField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: addressThreeField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: phoneField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(height: 40, width: 240, child: webLinkField),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           Align(
//                             alignment: Alignment.center,
//                             child: GestureDetector(
//                               onTap: () {
//                                 if (manForm.currentState!.validate()) {
//                                   addNewManufacturer(context);
//                                 }
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.only(top: 20),
//                                 alignment: Alignment.center,
//                                 height: 50,
//                                 width: 200,
//                                 decoration: BoxDecoration(
//                                     color:
//                                         const Color.fromRGBO(200, 169, 86, 1),
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: const Text('Submit',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700)),
//                               ),
//                             ),
//                           )
//                         ]),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   Future<void> addNewManufacturer(BuildContext context) {
//     String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
//     return FirebaseFirestore.instance
//         .collection('manufacturers')
//         .doc(assetDocId.toString())
//         .set({
//       'date': dateNow,
//       'name': manufacturerName.text,
//       'address_one': addressOne.text,
//       'address_two': addressTwo.text,
//       'address_three': addressThree.text,
//       'email': manufacturerEmail.text,
//       'phone': phone.text,
//       'web_link': webLink.text,
//       'asset': assetDocId.toString()
//     }).then((value) {
//       Navigator.pop(context);
//     });
//   }

//   Future<void> getManDoc() {
//     List list = [];
//     setState(() {
//       manufacturerDocId = list.length;
//     });
//     return FirebaseFirestore.instance
//         .collection("manufacturers")
//         .get()
//         .then((value) {
//       for (var doc in value.docs) {
//         list.add(doc.id);
//         var temp = list.length;
//         if (list.contains(temp.toString())) {
//           setState(() {
//             manufacturerDocId = list.length + 1;
//           });
//         } else {
//           setState(() {
//             manufacturerDocId = list.length;
//           });
//         }
//       }
//     });
//   }

//   Future<void> getDoc() {
//     //  final DocumentReference user =
//     List attachmentsList = [];

//     return FirebaseFirestore.instance
//         .collection("attachments")
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       for (var doc in querySnapshot.docs) {
//         attachmentsList.add(doc.id);
//         var temp = attachmentsList.length;
//         if (attachmentsList.contains(temp.toString())) {
//           setState(() {
//             attachmentDocId = attachmentsList.length + 1;
//           });
//         } else {
//           setState(() {
//             attachmentDocId = attachmentsList.length;
//           });
//         }
//       }
//     });
//   }

//   String checkBox() {
//     if (value == true) {
//       return 'Verified';
//     } else {
//       return 'Not Verified';
//     }
//   }

//   Color checkIcon() {
//     if (value == true) {
//       return Colors.black;
//     } else {
//       return Colors.white;
//     }
//   }
// }

// class GetAtts extends StatefulWidget {
//   GetAtts({Key? key, required this.assetDocId}) : super(key: key);
//   int assetDocId;
//   @override
//   State<GetAtts> createState() => _GetAttsState(assetDocId: assetDocId);
// }

// class _GetAttsState extends State<GetAtts> {
//   _GetAttsState({required this.assetDocId});
//   int assetDocId;

//   Future<void> deleteDoc(String id, String filename) async {
//     await FirebaseFirestore.instance.collection('attachments').doc(id).delete();
//     await FirebaseStorage.instance.ref('attachments/$filename').delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> uploads = FirebaseFirestore.instance
//         .collection('attachments')
//         .where('asset', isEqualTo: assetDocId.toString())
//         .snapshots();
//     return Container(
//       padding: const EdgeInsets.only(left: 15, right: 15),
//       child: SingleChildScrollView(
//         child: SizedBox(
//           height: 300,
//           width: double.infinity,
//           child: StreamBuilder(
//               stream: uploads,
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return const Text('Something went wrong');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Text("Loading...");
//                 }

//                 return ListView(
//                     children:
//                         snapshot.data!.docs.map((DocumentSnapshot document) {
//                   Map<String, dynamic> data =
//                       document.data()! as Map<String, dynamic>;

//                   return Container(
//                     margin: const EdgeInsets.only(top: 10),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 240,
//                           height: 20,
//                           alignment: Alignment.centerLeft,
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Text(data['name'] + ' -',
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.normal)),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               width: 160,
//                               alignment: Alignment.centerLeft,
//                               child: Text(data['type'],
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.normal)),
//                             ),
//                             Container(
//                               width: 40,
//                               height: 20,
//                               alignment: Alignment.center,
//                               child: GestureDetector(
//                                   onTap: () {
//                                     String fileNameDel = data['name'];
//                                     FirebaseFirestore.instance
//                                         .collection('attachments')
//                                         .doc(document.id)
//                                         .delete();
//                                     FirebaseStorage.instance
//                                         .ref()
//                                         .child('attachments/$fileNameDel')
//                                         .delete();
//                                   },
//                                   child: const SizedBox(
//                                     child: Icon(
//                                       Icons.cancel,
//                                       color: Colors.white,
//                                       size: 18,
//                                     ),
//                                     height: 20,
//                                     width: 20,
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList());
//               }),
//         ),
//       ),
//     );
//   }
// }

// class OK extends ConsumerStatefulWidget {
//   OK({Key? key}) : super(key: key);

//   @override
//   ConsumerState<OK> createState() => _OKState();
// }

// class _OKState extends ConsumerState<OK> {
//   void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
//     if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
//       ref.read(selectedNavPageNameProvider.state).state = pageName;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       child: const Text('OK'),
//       onPressed: () {
//         Navigator.pop(context);

//         _selectPage(context, ref, 'assets');
//       },
//     );
//   }
// }

// class EditDetailBackPress extends ConsumerWidget {
//   void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
//     if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
//       ref.read(selectedNavPageNameProvider.state).state = pageName;
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return GestureDetector(
//         onTap: () {
//           _selectPage(context, ref, 'assets');
//         },
//         child: Container(
//             width: 60,
//             alignment: Alignment.bottomLeft,
//             child: const Icon(Icons.arrow_back)));
//   }
// }

// class EditAsset extends StatefulWidget {
//   EditAsset(
//       {Key? key,
//       required this.assetId,
//       required this.date,
//       required this.id,
//       required this.name,
//       required this.project,
//       required this.design,
//       required this.serial,
//       required this.location,
//       required this.model,
//       required this.status,
//       required this.system,
//       required this.subsystem,
//       required this.type,
//       required this.engineer,
//       required this.expectancy,
//       required this.details});

//   String assetId,
//       date,
//       id,
//       name,
//       location,
//       project,
//       design,
//       serial,
//       model,
//       status,
//       system,
//       subsystem,
//       type,
//       engineer,
//       expectancy,
//       details;
//   @override
//   State<EditAsset> createState() => _EditAssetState();
// }

// class _EditAssetState extends State<EditAsset> {
//   int assetDocId = 0;

//   int attachmentDocId = 0;

//   int manufacturerDocId = 0;

//   bool value = false;

//   final _formKey = GlobalKey<FormState>();

//   TextEditingController name = TextEditingController(text: '');
//   TextEditingController assetID = TextEditingController(text: '');
//   TextEditingController design = TextEditingController(text: '');
//   TextEditingController model = TextEditingController(text: '');
//   TextEditingController serialNumber = TextEditingController(text: '');
//   TextEditingController detail = TextEditingController(text: '');

//   TextEditingController manufacturerName = TextEditingController(text: '');
//   TextEditingController manufacturerEmail = TextEditingController(text: '');
//   TextEditingController addressOne = TextEditingController(text: '');
//   TextEditingController addressTwo = TextEditingController(text: '');
//   TextEditingController addressThree = TextEditingController(text: '');
//   TextEditingController phone = TextEditingController(text: '');
//   TextEditingController webLink = TextEditingController(text: '');

//   @override
//   void initState() {
//     super.initState();
//     if (widget.status == 'Verified') {
//       setState(() {
//         value = true;
//       });
//     } else {}
//     setState(() {
//       projectName.text = titleClick;
//       name.text = widget.name;
//       assetID.text = widget.id;
//       design.text = widget.design;
//       model.text = widget.model;
//       serialNumber.text = widget.serial;
//       detail.text = widget.details;
//       projectName.text = widget.project;
//       roomName.text = widget.location;
//       systemButton = widget.system;
//       subsystemButton = widget.subsystem;
//       assetTypeButton = widget.type;
//       expectancyButton = widget.expectancy;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final nameField = TextFormField(
//         autofocus: false,
//         controller: name,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           name.text = value!;
//         },
//         cursorColor: Colors.black45,
//         cursorWidth: 0.8,
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           hintText: 'name',
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
//           // hintText: "Email",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(3),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(3),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));

//     final serialNumberField = TextFormField(
//         autofocus: false,
//         controller: serialNumber,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           serialNumber.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Serial Number",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));
//     final assetIDField = TextFormField(
//         autofocus: false,
//         controller: assetID,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           assetID.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Asset Id Field",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));
//     final designField = TextFormField(
//         autofocus: false,
//         controller: design,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           design.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Asset Design ref",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));
//     final modelField = TextFormField(
//         autofocus: false,
//         controller: model,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           model.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           // hintText: "Email",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.black87, width: 0.2),
//           ),
//         ));
//     final detailField = TextFormField(
//         autofocus: false,
//         controller: detail,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           detail.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         cursorColor: Colors.black54,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//           hintText: 'Add asset description details here',
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.transparent, width: 0.2),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: Colors.transparent, width: 0.2),
//           ),
//         ));

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Form(
//         key: _formKey,
//         child: Container(
//           height: 1400,
//           alignment: Alignment.topCenter,
//           padding: const EdgeInsets.all(20),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                     child: Column(children: [
//                   const SizedBox(
//                     height: 12,
//                   ),
//                   Stack(
//                     children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Icon(
//                             Icons.arrow_back,
//                             color: Colors.black,
//                             size: 24,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         alignment: Alignment.center,
//                         child: const Text(
//                           'Fill Assets Details',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 22),
//                         ),
//                       )
//                     ],
//                   ),
//                 ])),
//                 const SizedBox(height: 10),
//                 Container(
//                   width: double.infinity,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       getHolder(),
//                       const SizedBox(
//                         width: 6,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 150,
//                             height: 24,
//                             child: nameField,
//                           ),
//                           Container(
//                             height: 20,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   margin: const EdgeInsets.only(bottom: 6),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: AssetSystems(),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(6)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   width: double.infinity,
//                   height: 50,
//                   child: AssetSubSystems(),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: AssetTypes(
//                     action: subsystem,
//                   ),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: assetIDField,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: designField,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   padding: const EdgeInsets.only(left: 20),
//                   alignment: Alignment.centerLeft,
//                   width: double.infinity,
//                   height: 50,
//                   child: Text(titleClick + ' (Project)',
//                       style: TextStyle(color: Colors.black87, fontSize: 14)),
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 0.2, color: Colors.black87),
//                       borderRadius: BorderRadius.circular(6)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: Rooms(
//                     title: titleClick,
//                   ),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: serialNumberField,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   width: double.infinity,
//                   height: 50,
//                   child: Expectancy(),
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 6),
//                   padding: const EdgeInsets.all(0.3),
//                   width: double.infinity,
//                   height: 200,
//                   child: SingleChildScrollView(child: detailField),
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 0.2, color: Colors.black87),
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _showManufacturerDialog();
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 8),
//                     child: Row(
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           height: 18,
//                           width: 18,
//                           child: Icon(
//                             Icons.add,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(9),
//                               color: Colors.black),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Container(
//                           height: 18,
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Add Manufacturer Details',
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 decoration: TextDecoration.underline),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _showDocDialog();
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 8, bottom: 28),
//                     child: Row(
//                       children: [
//                         Container(
//                           alignment: Alignment.center,
//                           height: 18,
//                           width: 18,
//                           child: Icon(
//                             Icons.add,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(9),
//                               color: Colors.black),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Container(
//                           height: 18,
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Upload Documents',
//                             style: TextStyle(fontSize: 14),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     if (_formKey.currentState!.validate()) {
//                       addNewAsset();
//                     }
//                   },
//                   child: Container(
//                     height: 50,
//                     width: 285,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         color: const Color.fromRGBO(255, 174, 0, 1),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: const Text(
//                       'Save Details',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 300,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> getData() {
//     //  final DocumentReference user =
//     List assetsList = [];
//     setState(() {
//       assetDocId = assetsList.length;
//     });
//     return FirebaseFirestore.instance.collection("assets").get().then((value) {
//       for (var doc in value.docs) {
//         assetsList.add(doc.id);
//         var temp = assetsList.length;
//         if (assetsList.contains(temp.toString())) {
//           setState(() {
//             assetDocId = assetsList.length + 1;
//           });
//         } else {
//           setState(() {
//             assetDocId = assetsList.length;
//           });
//         }
//       }
//     });
//   }

//   Widget getHolder() {
//     if (assetImg == null) {
//       return GestureDetector(
//         onTap: (() {
//           pickImage();
//         }),
//         child: Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
//           child: SvgPicture.asset(
//             'assets/images/image 3.svg',
//             height: 86,
//             width: 86,
//             fit: BoxFit.cover,
//           ),
//         ),
//       );
//     } else {
//       return GestureDetector(
//         onTap: (() {
//           pickImage();
//         }),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(6),
//           child: Image.network(
//             assetImg!,
//             height: 86,
//             width: 86,
//             fit: BoxFit.cover,
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> addNewAsset() {
//     String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
//     if (subsystemButton == null) {
//       subsystemButton = '';
//     }
//     if (assetTypeButton == null) {
//       assetTypeButton = '';
//     }
//     if (roomsButton == null) {}
//     return FirebaseFirestore.instance
//         .collection('assets')
//         .doc(widget.assetId)
//         .update({
//       // 'date': dateNow,
//       'name': name.text,
//       'project': titleClick,
//       'room_location': roomName.text,
//       'serial_number': serialNumber.text,
//       'unique_id': assetID.text,
//       'design': design.text,
//       'model': model.text,
//       'system': systemButton,
//       'subsystem': subsystemButton,
//       'type': assetTypeButton,
//       'engineer': '',
//       'expectancy': expectancyButton,
//       'details': detail.text,
//       'status': 'Not Verified'
//     }).then((value) => {_showDialog('Asset Updated')});
//   }

//   Future<void> _showDialog(String? message) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(message!),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: const <Widget>[
//                 // Text('This is a demo alert dialog.'),
//                 // Text('Would you like to approve of this message?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 // Navigator.of(context).pop();
//                 Navigator.pop(context); // pop current page
//                 Navigator.of(context).pop(); // push it back in
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String? assetImg;

//   String? imgAsset;

//   String? imgUrl;

//   Future<void> _pickImage() async {
//     // opens storage to pick files and the picked file or files
//     // are assigned into result and if no file is chosen result is null.
//     // you can also toggle "allowMultiple" true or false depending on your need
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'png', 'svg'],
//     );

//     PlatformFile plat = result!.files.first;

//     // if no file is picked
//     if (result == null) return;

//     setState(() {
//       // assetImg = result.files.first.bytes;
//       imgAsset = result.files.first.name;
//     });

//     FirebaseFirestore.instance
//         .collection('images')
//         .doc(assetDocId.toString())
//         .set({'name': imgAsset, 'asset': assetDocId.toString()});

//     // await FirebaseStorage.instance
//     //     .ref('asset_images/$imgAsset')
//     //     .putData(assetImg);

//     final ref = FirebaseStorage.instance.ref().child('asset_images/$imgAsset');
//     // no need of the file extension, the name will do fine.
//     String temp = await ref.getDownloadURL();
//     setState(() {
//       imgUrl = temp;
//     });
//     print(imgUrl);
//   }

//   File? image;
//   Future pickImage() async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (image == null) return;
//       final imageTemp = File(image.path);

//       setState(() {
//         this.image = imageTemp;
//         imgAsset = image.name;
//       });
//     } on PlatformException catch (e) {
//       print('Failed to pick image: $e');
//     }
//     await FirebaseFirestore.instance
//         .collection('images')
//         .doc(assetDocId.toString())
//         .set({'name': imgAsset, 'asset': assetDocId.toString()});

//     if (image != null) {
//       //Upload to Firebase
//       var snapshot = await FirebaseStorage.instance
//           .ref()
//           .child('asset_images/$imgAsset')
//           .putFile(image!);
//       var downloadUrl = await snapshot.ref.getDownloadURL();
//       setState(() {
//         assetImg = downloadUrl;
//       });
//     } else {
//       print('No Image Path Received');
//     }
//   }

//   List<Map<dynamic, dynamic>> filesDynamo = [];

//   String upload = 'not yet';

//   String filename = '';

//   dynamic fileBytes;

//   int att = 0;

//   Future uploadFile(BuildContext context) async {
//     for (var file in filesDynamo) {
//       String tempName = file.entries.first.key;
//       dynamic tempBytes = file.entries.first.value;
//       await FirebaseStorage.instance.ref('attachments/$tempName').putFile(
//             File(tempBytes),
//           );
//     }
//     Navigator.pop(context);
//   }

//   Future<void> _pickFile() async {
//     // opens storage to pick files and the picked file or files
//     // are assigned into result and if no file is chosen result is null.
//     // you can also toggle "allowMultiple" true or false depending on your need
//     final result = await FilePicker.platform.pickFiles(allowMultiple: false);

//     PlatformFile plat = result!.files.first;

//     // if no file is picked
//     if (result == null) return;

//     var fileMap = <String, PlatformFile>{result.files.first.name: plat};

//     final fileName = result.files.first.name;

//     setState(() {
//       fileBytes = result.files.first.path;
//       filename = result.files.first.name;
//       filesDynamo.add({filename: fileBytes});
//     });

//     List docs = [];

//     FirebaseFirestore.instance.collection('attachments').get().then((value) {
//       for (var doc in value.docs) {
//         var name = doc.get('name');
//         docs.add(name);
//         setState(() {
//           att = docs.length;
//         });
//         print(docs.length.toString());
//       }
//     });

//     if (documentButton == null) {
//       documentButton = 'User Directory';
//     }

//     FirebaseFirestore.instance
//         .collection('attachments')
//         .doc(attachmentDocId.toString())
//         .set({
//       'name': filename,
//       'type': documentButton,
//       'asset': assetDocId.toString()
//     });
//     getDoc();
//   }

//   Future<void> _showDocDialog() async {
//     getDoc();
//     return showDialog<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(0),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             content: Container(
//               height: 400,
//               width: 600,
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                   color: const Color.fromRGBO(19, 18, 29, 1),
//                   borderRadius: BorderRadius.circular(20)),
//               child: Column(children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     height: 20,
//                     width: double.infinity,
//                     alignment: Alignment.centerRight,
//                     child: const Icon(Icons.cancel,
//                         size: 20, color: Colors.orange),
//                   ),
//                 ),
//                 Container(
//                   width: 600,
//                   alignment: Alignment.center,
//                   child: const Text(
//                     'Upload Document',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Container(height: 50, width: 240, child: DocumentType()),
//                 Container(
//                     height: 120,
//                     width: 300,
//                     alignment: Alignment.topCenter,
//                     child: GetAtts(
//                       assetDocId: assetDocId,
//                     )),
//                 Container(
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     child: GestureDetector(
//                       onTap: () {
//                         _pickFile();
//                       },
//                       child: const Text(
//                         'upload attachment',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     )),
//                 Align(
//                   alignment: Alignment.center,
//                   child: GestureDetector(
//                     onTap: () {
//                       uploadFile(context);
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(top: 20),
//                       alignment: Alignment.center,
//                       height: 50,
//                       width: 200,
//                       decoration: BoxDecoration(
//                           color: const Color.fromRGBO(200, 169, 86, 1),
//                           borderRadius: BorderRadius.circular(8)),
//                       child: const Text('Submit',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700)),
//                     ),
//                   ),
//                 )
//               ]),
//             ),
//           );
//         });
//   }

//   Future<void> _showManufacturerDialog() async {
//     getManDoc();
//     final nameField = TextFormField(
//         autofocus: false,
//         controller: manufacturerName,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           manufacturerName.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Manufacturer's name",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final emailField = TextFormField(
//         autofocus: false,
//         controller: manufacturerEmail,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation
//           if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
//               .hasMatch(value)) {
//             return ("Please Enter a valid email");
//           }

//           return null;
//         },
//         onSaved: (value) {
//           manufacturerEmail.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Manufacturer's email",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final addressOneField = TextFormField(
//         autofocus: false,
//         controller: addressOne,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           // reg expression for email validation

//           return null;
//         },
//         onSaved: (value) {
//           addressOne.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Address One",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final addressTwoField = TextFormField(
//         autofocus: false,
//         controller: addressTwo,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           return null;
//         },
//         onSaved: (value) {
//           addressTwo.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Address Two(optional)",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final addressThreeField = TextFormField(
//         autofocus: false,
//         controller: addressThree,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           return null;
//         },
//         onSaved: (value) {
//           addressThree.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Address Three(optional)",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final phoneField = TextFormField(
//         autofocus: false,
//         controller: phone,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           if (value!.isEmpty || value == '') {
//             return ("Please enter required details");
//           }
//           if (!RegExp("^[0-9]").hasMatch(value)) {
//             return ("Please Enter required details");
//           }
//           if (value.length < 10 || value.length > 12) {
//             return ('Your input is not valid');
//           }
//           if (RegExp("^[A-Za-z]").hasMatch(value)) {
//             return ("Please Enter required details");
//           }

//           return null;
//         },
//         onSaved: (value) {
//           phone.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Telephone",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final webLinkField = TextFormField(
//         autofocus: false,
//         controller: webLink,
//         keyboardType: TextInputType.emailAddress,
//         validator: (value) {
//           return null;
//         },
//         onSaved: (value) {
//           webLink.text = value!;
//         },
//         textInputAction: TextInputAction.next,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white,
//           //prefixIcon: Icon(Icons.mail),
//           contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//           hintText: "Manufacturer's website(optional)",
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.white, width: 0.1),
//           ),
//         ));
//     final manForm = GlobalKey<FormState>();
//     return showDialog<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(0),
//             backgroundColor: Colors.transparent,
//             elevation: 5,
//             content: Form(
//               key: manForm,
//               child: SingleChildScrollView(
//                 child: Container(
//                   height: 500,
//                   width: 360,
//                   padding: const EdgeInsets.all(15),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       color: const Color.fromRGBO(233, 232, 235, 1),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: SingleChildScrollView(
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: nameField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: emailField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: addressOneField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: addressTwoField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: addressThreeField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(
//                             height: 40,
//                             width: 240,
//                             child: phoneField,
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           SizedBox(height: 40, width: 240, child: webLinkField),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           Align(
//                             alignment: Alignment.center,
//                             child: GestureDetector(
//                               onTap: () {
//                                 if (manForm.currentState!.validate()) {
//                                   addNewManufacturer(context);
//                                 }
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.only(top: 20),
//                                 alignment: Alignment.center,
//                                 height: 50,
//                                 width: 200,
//                                 decoration: BoxDecoration(
//                                     color:
//                                         const Color.fromRGBO(200, 169, 86, 1),
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: const Text('Submit',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700)),
//                               ),
//                             ),
//                           )
//                         ]),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   Future<void> addNewManufacturer(BuildContext context) {
//     String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
//     return FirebaseFirestore.instance
//         .collection('manufacturers')
//         .doc(assetDocId.toString())
//         .set({
//       'date': dateNow,
//       'name': manufacturerName.text,
//       'address_one': addressOne.text,
//       'address_two': addressTwo.text,
//       'address_three': addressThree.text,
//       'email': manufacturerEmail.text,
//       'phone': phone.text,
//       'web_link': webLink.text,
//       'asset': assetDocId.toString()
//     }).then((value) {
//       Navigator.pop(context);
//     });
//   }

//   Future<void> getManDoc() {
//     List list = [];
//     setState(() {
//       manufacturerDocId = list.length;
//     });
//     return FirebaseFirestore.instance
//         .collection("manufacturers")
//         .get()
//         .then((value) {
//       for (var doc in value.docs) {
//         list.add(doc.id);
//         var temp = list.length;
//         if (list.contains(temp.toString())) {
//           setState(() {
//             manufacturerDocId = list.length + 1;
//           });
//         } else {
//           setState(() {
//             manufacturerDocId = list.length;
//           });
//         }
//       }
//     });
//   }

//   Future<void> getDoc() {
//     //  final DocumentReference user =
//     List attachmentsList = [];

//     return FirebaseFirestore.instance
//         .collection("attachments")
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       for (var doc in querySnapshot.docs) {
//         attachmentsList.add(doc.id);
//         var temp = attachmentsList.length;
//         if (attachmentsList.contains(temp.toString())) {
//           setState(() {
//             attachmentDocId = attachmentsList.length + 1;
//           });
//         } else {
//           setState(() {
//             attachmentDocId = attachmentsList.length;
//           });
//         }
//       }
//     });
//   }

//   String checkBox() {
//     if (value == true) {
//       return 'Verified';
//     } else {
//       return 'Not Verified';
//     }
//   }

//   Color checkIcon() {
//     if (value == true) {
//       return Colors.black;
//     } else {
//       return Colors.white;
//     }
//   }
// }

// class GetAttsEdit extends StatefulWidget {
//   GetAttsEdit({Key? key, required this.assetDocId}) : super(key: key);
//   int assetDocId;
//   @override
//   State<GetAttsEdit> createState() => _GetAttsEditState(assetDocId: assetDocId);
// }

// class _GetAttsEditState extends State<GetAttsEdit> {
//   _GetAttsEditState({required this.assetDocId});
//   int assetDocId;

//   Future<void> deleteDoc(String id, String filename) async {
//     await FirebaseFirestore.instance.collection('attachments').doc(id).delete();
//     await FirebaseStorage.instance.ref('attachments/$filename').delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> uploads = FirebaseFirestore.instance
//         .collection('attachments')
//         .where('asset', isEqualTo: assetDocId.toString())
//         .snapshots();
//     return Container(
//       padding: const EdgeInsets.only(left: 15, right: 15),
//       child: SingleChildScrollView(
//         child: SizedBox(
//           height: 300,
//           width: double.infinity,
//           child: StreamBuilder(
//               stream: uploads,
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return const Text('Something went wrong');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Text("Loading...");
//                 }

//                 return ListView(
//                     children:
//                         snapshot.data!.docs.map((DocumentSnapshot document) {
//                   Map<String, dynamic> data =
//                       document.data()! as Map<String, dynamic>;

//                   return Container(
//                     margin: const EdgeInsets.only(top: 10),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 240,
//                           height: 20,
//                           alignment: Alignment.centerLeft,
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Text(data['name'] + ' -',
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.normal)),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               width: 160,
//                               alignment: Alignment.centerLeft,
//                               child: Text(data['type'],
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.normal)),
//                             ),
//                             Container(
//                               width: 40,
//                               height: 20,
//                               alignment: Alignment.center,
//                               child: GestureDetector(
//                                   onTap: () {
//                                     String fileNameDel = data['name'];
//                                     FirebaseFirestore.instance
//                                         .collection('attachments')
//                                         .doc(document.id)
//                                         .delete();
//                                     FirebaseStorage.instance
//                                         .ref()
//                                         .child('attachments/$fileNameDel')
//                                         .delete();
//                                   },
//                                   child: const SizedBox(
//                                     child: Icon(
//                                       Icons.cancel,
//                                       color: Colors.white,
//                                       size: 18,
//                                     ),
//                                     height: 20,
//                                     width: 20,
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList());
//               }),
//         ),
//       ),
//     );
//   }
// }
