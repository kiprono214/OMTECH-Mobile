import 'dart:io';

import 'package:OMTECH/authentication/login.dart';
import 'package:OMTECH/screens/company_screens/company_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:intl/intl.dart';

import '../../tools/drop_buttons.dart';

class CreateWorker extends StatefulWidget {
  CreateWorker({Key? key}) : super(key: key);

  @override
  State<CreateWorker> createState() => _CreateWorkerState();
}

var password = RandomPasswordGenerator();

class _CreateWorkerState extends State<CreateWorker> {
  @override
  static final TextEditingController email = TextEditingController(text: '');
  static final TextEditingController name = TextEditingController(text: '');
  static final TextEditingController phone = TextEditingController(text: '');
  static final TextEditingController address = TextEditingController(text: '');

  String id = '0';
  String user = '0';
  var now = DateTime.now();

  Future<void> _showDialogA(String? message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1)).then((_) {
          // addNewW(context);
          createAuth(email.text, context);
        });
        return AlertDialog(
            insetPadding: const EdgeInsets.only(top: 230, bottom: 230),
            title: Text(message!),
            content: SpinKitCircle(
              color: Colors.black,
            ));
      },
    );
  }

  Future<void> getData() {
    //  final DocumentReference user =
    List users = [];
    return FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        users.add(doc.id);
        var temp = users.length;
        if (users.contains(temp.toString())) {
          setState(() {
            user = (temp + 1).toString();
          });
        } else {
          setState(() {
            user = users.length.toString();
          });
        }
      }
    });
  }

  void getId() async {
    List users = [];
    FirebaseFirestore.instance
        .collection("workers")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        users.add(doc.id);
        var temp = users.length;
        if (users.contains(temp.toString())) {
          setState(() {
            id = (temp + 1).toString();
          });
        } else {
          setState(() {
            id = users.length.toString();
          });
        }
      }
    });
  }

  void goBack() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CompanyHome()));
  }

  Future<void> _showDialogConsumer(String string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(string),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('This is a demo alert dialog.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                goBack();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _showDialog(String? message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message!),
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
                // pop current page
                if (message == 'Worker Added') {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CollectionReference authors =
      FirebaseFirestore.instance.collection('workers');

  void createAuth(String email, BuildContext context) async {
    String? errorMessage;
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: thisPassword)
          .then((uid) {
        // _showDialog('User email added');
        sendLink(email, context);
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'firebaseAuth/email-already-in-use') {
        errorMessage = 'That email address is already in use!';
        _showDialog(errorMessage);
      } else if (error.code == 'firebaseAuth/invalid-email') {
        errorMessage = 'That email address is invalid!';
        _showDialog(errorMessage);
      } else {
        _showDialog('Email error!');
      }
    }
  }

  Future<void> sendLink(String email, BuildContext context) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await firebaseAuth.sendPasswordResetEmail(email: email).then((uid) {
      // _showMyDialog('Email sent to user account');

      addUser(context);
    });
  }

  Future<void> addUser(BuildContext context) {
    String val = user.toString();
    return users
        .doc(val)
        .set({'email': email.text, 'access': 'worker'})
        .then((value) => {
              // _showDialog('Worker added to Users'),
              addProjectManager(context)
            })
        .catchError((error) => print("Failed to add user: $error"));
  }

  // void getDoc() async {
  //   var snapshot = FirebaseFirestore.instance.collection("workers");

  //   snapshot.doc(w_aid).update({
  //     'name': name.text,
  //     'email': w_email,
  //     'address': address.text,
  //     'phone': phone.text,
  //     'company': companyAssign
  //   }).then((_) {
  //     print('updated');
  //     _showDialogConsumer('Worker Updated');
  //   });
  //   return;
  // }

  Future<void> addProjectManager(BuildContext context) {
    String val = id.toString();
    String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
    return authors.doc(val).set({
      'email': email.text,
      'name': name.text,
      'company': username,
      'phone': phone.text,
      'address': address.text,
      'date': dateNow,
      'id': id,
      'status': 'active'
    }).then((value) {
      print("User Added");
      Navigator.pop(context);
      _showMyDialog('Worker Added');
    }).catchError((error) {
      Navigator.pop(context);
      _showDialog("Failed to add user: $error");
    });
  }

  Future<void> _showMyDialog(String alert) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alert),
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CompanyHome()));
              },
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  String thisPassword = password.randomPassword(
      letters: true,
      uppercase: false,
      numbers: false,
      specialChar: false,
      passwordLength: 8);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    email.text = '';
    name.text = '';
    phone.text = '';
    address.text = '';

    getData();
    getId();
    getProf();
  }

  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }

          return null;
        },
        onSaved: (value) {
          email.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Email',
          filled: true,
          fillColor: Colors.transparent,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));

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
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Name',
          filled: true,
          fillColor: Colors.transparent,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));

    final phoneField = TextFormField(
        autofocus: false,
        controller: phone,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation
          if (!RegExp("^[0-9]").hasMatch(value)) {
            return ("Please Enter required details");
          }
          if (value.length < 10 || value.length > 12) {
            return ('Your input is not valid');
          }
          if (RegExp("^[A-Za-z]").hasMatch(value)) {
            return ("Please Enter required details");
          }
          return null;
        },
        onSaved: (value) {
          phone.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Phone',
          filled: true,
          fillColor: Colors.transparent,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));

    final companyField = CompaniesDropDown(
      from: '',
    );

    final addressfield = TextFormField(
        autofocus: false,
        controller: address,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty || value == '') {
            return ("Please enter required details");
          }
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          address.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Address',
          filled: true,
          fillColor: Colors.transparent,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black87, width: 0.2),
          ),
        ));

    final button = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(8),
      color: Colors.transparent,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          height: 40,
          minWidth: 180,
          onPressed: () {
            if (email.text.isEmpty ||
                name.text.isEmpty ||
                phone.text.isEmpty ||
                address.text.isEmpty ||
                companyAssign == null) {
              _showDialog('All fields are required');
            } else if (_formKey.currentState!.validate()) {
              _showDialogA('Uploading');
            }
          },
          child: const Text(
            "",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    child: Column(children: [
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              width: 60,
                              alignment: Alignment.bottomLeft,
                              child: const Icon(Icons.arrow_back))),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          'Fill Worker Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22),
                        ),
                      )
                    ],
                  ),
                ])),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: getHolder(),
                ),
                SizedBox(height: 20),
                Container(width: double.infinity, height: 50, child: nameField),
                SizedBox(height: 10),
                Container(
                    width: double.infinity, height: 50, child: phoneField),
                SizedBox(height: 10),
                Container(
                    width: double.infinity, height: 50, child: emailField),
                SizedBox(height: 10),
                Container(
                    width: double.infinity, height: 50, child: addressfield),
                SizedBox(height: 10),
                SizedBox(height: 10),
                SizedBox(height: 10),
                SizedBox(height: 10),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _showDialogA('Uploading...');
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
                Container(
                  margin: const EdgeInsets.only(top: 100),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? workerProf;

  Widget getHolder() {
    if (workerProf == null) {
      return GestureDetector(
        onTap: (() {
          pickImage();
        }),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(54),
          child: SvgPicture.asset(
            'assets/images/Group 48462.svg',
            height: 108,
            width: 108,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: (() {
          pickImage();
        }),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(54),
          child: Image.network(
            workerProf!,
            height: 108,
            width: 108,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  void getProf() async {
    workerProf = await FirebaseStorage.instance
        .ref()
        .child('workers/$id')
        .getDownloadURL();
    print('"""""""""""""""""$workerProf');
    setState(() {});
  }

  String? assetImg;

  String? imgAsset;

  String? imgUrl;

  File? image;
  Future pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'svg'],
      );

      PlatformFile plat = result!.files.first;

      // final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (image == null) return;
      final imageTemp = File(plat.path!);

      setState(() {
        image = imageTemp;
        imgAsset = plat.name;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    await FirebaseFirestore.instance
        .collection('images')
        .doc(userId.toString())
        .set({'name': imgAsset, 'asset': userId.toString()});

    if (image != null) {
      //Upload to Firebase
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('workers/$userId')
          .putFile(image!);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        workerProf = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
  }
}
