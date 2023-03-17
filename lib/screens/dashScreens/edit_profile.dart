import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:OMTECH/authentication/login.dart';
import 'package:OMTECH/screens/dashScreens/client_home.dart';
import 'package:OMTECH/screens/dashScreens/profile.dart';

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
            .push(MaterialPageRoute(builder: (context) => ClientDash()));
        _selectPage(context, ref, 'profile');
      },
      child: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }
}

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  Future<dynamic> getData() async {
    //  final DocumentReference user =
    return FirebaseFirestore.instance
        .collection('clients')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.get('name') == username) {
          setState(() {
            email = doc.get('email');
            address = doc.get('address');
            phone = doc.get('phone');
            id = doc.id;
          });
        }
      }
    });
  }

  String complete = 'false';

  void checkPass() {
    if (oldPassword.text != userPassword) {
      _showErrorDialog('Old Password Incorrect');
    } else {
      checkNewPass();
    }
  }

  void checkNewPass() {
    if (newPassword.text != confirmPassword.text) {
      _showErrorDialog('New Passwords Mismatch');
    } else {
      changePassword();
      setState(() {
        complete = 'true';
      });
    }
  }

  Future<void> _showErrorDialog(String errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorMessage),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                // Text('This is a demo alert dialog.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            OK(
              message: errorMessage,
            )
          ],
        );
      },
    );
  }

  Future<dynamic> changePassword() async {
    //  final DocumentReference user =
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      firebaseAuth.currentUser?.updatePassword(newPassword.text).then((value) {
        _showErrorDialog('Password Changed');
        setState(() {
          complete = 'true';
        });
      });
    } catch (error) {
      _showErrorDialog('error!');
    }
  }

  String email = '', address = '', phone = '', id = '';

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    BackPress(),
                    const SizedBox(
                      width: 100,
                    ),
                    const Text('My Profile',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: const Color.fromRGBO(237, 245, 255, 1),
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 108,
                      width: 108,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(46, 55, 73, 1),
                          borderRadius: BorderRadius.circular(54)),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 21,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Personal Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25, left: 5, right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 163,
                                  child: const Text('Name',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300)),
                                ),
                                Text(
                                  username,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  width: 163,
                                  alignment: Alignment.centerLeft,
                                  child: const Text('User Level',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300)),
                                ),
                                const Text(
                                  'Client',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 163,
                                  child: const Text('Company',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300)),
                                ),
                                Text(
                                  'Omtech Ltd',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 21,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Private Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25, left: 5, right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 163,
                                  child: const Text('Email',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300)),
                                ),
                                SingleChildScrollView(
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      email,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  width: 163,
                                  alignment: Alignment.centerLeft,
                                  child: const Text('Phone Number',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300)),
                                ),
                                Text(
                                  phone,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 163,
                                  child: const Text('Address',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300)),
                                ),
                                Container(
                                  width: 120,
                                  child: Text(
                                    address,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDialog();
                      },
                      child: Container(
                          height: 50,
                          width: 285,
                          alignment: Alignment.center,
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w500),
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 122, 255, 1),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 107,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController oldPassword = TextEditingController(text: '');
  TextEditingController newPassword = TextEditingController(text: '');
  TextEditingController confirmPassword = TextEditingController(text: '');

  final _formKey = GlobalKey<FormState>();

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final oldPasswordField = TextFormField(
            autofocus: false,
            controller: oldPassword,
            obscureText: true,
            validator: (value) {
              RegExp regex = new RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return ("Password is required");
              }
              if (!regex.hasMatch(value)) {
                return ("Enter Valid Password(Min. 6 Character)");
              }
            },
            onSaved: (value) {
              oldPassword.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              //prefixIcon: Icon(Icons.vpn_key),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              // hintText: "Password",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 1),
              ),
            ));
        final newPasswordField = TextFormField(
            autofocus: false,
            controller: newPassword,
            obscureText: true,
            validator: (value) {
              RegExp regex = new RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return ("Password is required");
              }
              if (!regex.hasMatch(value)) {
                return ("Enter Valid Password(Min. 6 Character)");
              }
            },
            onSaved: (value) {
              newPassword.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              //prefixIcon: Icon(Icons.vpn_key),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              // hintText: "Password",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 1),
              ),
            ));
        final confirmPasswordField = TextFormField(
            autofocus: false,
            controller: confirmPassword,
            obscureText: true,
            validator: (value) {
              RegExp regex = new RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return ("Password is required");
              }
              if (!regex.hasMatch(value)) {
                return ("Enter Valid Password(Min. 6 Character)");
              }
            },
            onSaved: (value) {
              confirmPassword.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              //prefixIcon: Icon(Icons.vpn_key),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              // hintText: "Password",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 1),
              ),
            ));

        return Form(
          key: _formKey,
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            contentPadding:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
            content: Container(
              height: 450,
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 25, right: 25, top: 0, bottom: 20),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(237, 245, 254, 1),
                  borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                          width: double.infinity,
                          height: 30,
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.cancel,
                              size: 30,
                              color: Colors.orangeAccent,
                            ),
                          )),
                      Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text('Change Password',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Enter Old Password',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      oldPasswordField,
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Enter New Password',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      newPasswordField,
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Repeat New Password',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      confirmPasswordField,
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            checkPass();
                          }
                          if (complete == 'true') {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                            height: 50,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 122, 255, 1),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OK extends ConsumerWidget {
  OK({Key? key, required this.message}) : super(key: key);
  String message;

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text('OK'),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.pop(context);
        if (message == 'Password Changed') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login()));
          _selectPage(context, ref, 'home');
        }
      },
    );
  }
}
