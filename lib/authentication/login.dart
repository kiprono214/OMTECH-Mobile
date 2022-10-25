import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:OMTECH/authentication/forgot_password.dart';
import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:OMTECH/screens/dashScreens/client_home.dart';
import 'package:OMTECH/screens/dashScreens/home.dart';
import 'package:OMTECH/screens/engineer_screens/engineer_home.dart';
import 'package:OMTECH/screens/temp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

late String username, userEmail, userPassword, userId;

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController emailController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  final TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Timer scheduleTimeout([int milliseconds = 2000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            //prefixIcon: Icon(Icons.mail),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            // hintText: "Email",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Colors.orangeAccent, width: 2),
            ),
            hintText: 'Email'));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
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
                  const BorderSide(color: Colors.transparent, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Colors.orangeAccent, width: 2),
            ),
            hintText: 'Password'));

    final loginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(5),
      color: Colors.transparent,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            userEmail = emailController.text;
            userPassword = passwordController.text;
            signIn(emailController.text, passwordController.text);
            // logIt(emailController.text, passwordController.text);
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )),
    );

    //signIn

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(46, 59, 73, 1),
          body: Stack(children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                'assets/images/Pattern.svg',
                height: 112,
                width: 180,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: 1061,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    const Image(
                      image: AssetImage('assets/images/omlogo.png'),
                      height: 81,
                      width: 170,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      ' OMTECH',
                      style: TextStyle(
                          color: Colors.white70,
                          letterSpacing: 0.25,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 45),
                              child: const Text(
                                'Please Login',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity * 0.8,
                              margin: EdgeInsets.fromLTRB(40, 5, 40, 0),
                              child: emailField,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 50,
                              width: double.infinity * 0.8,
                              margin: EdgeInsets.fromLTRB(40, 10, 40, 0),
                              child: passwordField,
                            ),
                            GestureDetector(
                                onTap: toForgot,
                                child: Container(
                                  height: 20,
                                  width: double.infinity,
                                  alignment: Alignment.bottomRight,
                                  margin: const EdgeInsets.only(
                                      bottom: 0, top: 5, left: 40, right: 40),
                                  child: const Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 56,
                              width: double.infinity,
                              alignment: Alignment.bottomCenter,
                              margin: const EdgeInsets.only(
                                  bottom: 0, top: 30, left: 40, right: 40),
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/button.png"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                              child: loginButton,
                            ),
                          ]),
                    ),
                    Expanded(
                        child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.all(20),
                      child: const Image(
                          image: AssetImage('assets/images/Rectangle 24.png')),
                    ))
                  ],
                ),
              ),
            )
          ])),
    );
  }

  void signIn(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                // Fluttertoast.showToast(msg: "Login Successful"),
                getData(email, password),
                showMyDialog()
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      _showDialog(errorMessage);

      // Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  String loading = 'true';

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2)).then((_) {
          Navigator.pop(context);
        });
        return AlertDialog(
          elevation: 0,
          backgroundColor: const Color.fromRGBO(46, 55, 73, 1),
          title: const Text(
            'Loading...',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[],
            ),
          ),
          actions: const <Widget>[
            Center(
              child: SpinKitCircle(
                color: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> getData(String email, String password) async {
    //  final DocumentReference user =
    FirebaseFirestore.instance
        .collection("users")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.get('email') == email) {
          setState(() {
            access = doc.get('access');
          });
          handleTimeout();
        }
      }
    });
  }

  void toEngineerDash() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => EngineerDash(
              from: 'login',
            )));
  }

  void toWorkerDash() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  void toAuthorDash() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AuthorHome(
              from: 'login',
            )));
  }

  void toClientDash() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ClientDash(
              from: 'login',
            )));
  }

  void toCompanyDash() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  Future<void> getCompanyStatus() async {
    return FirebaseFirestore.instance
        .collection('companies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String tempEmail = doc.get('email');
        if (tempEmail == emailController.text) {
          username = doc.get('name');
          userId = doc.id;
          String status = doc.get('status');
          if (status == 'active') {
            toCompanyDash();
          } else {
            setState(() {
              loading = 'false';
              emailController.text = '';
              passwordController.text = '';
            });
            _showStatusDialog('Your account is currently inactive');
          }
        }
      }
    });
  }

  Future<void> getClientStatus() async {
    return FirebaseFirestore.instance
        .collection('clients')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String tempEmail = doc.get('email');
        if (tempEmail == emailController.text) {
          username = doc.get('name');
          userId = doc.id;
          String status = doc.get('status');
          if (status == 'active') {
            toClientDash();
          } else {
            setState(() {
              loading = 'false';
              emailController.text = '';
              passwordController.text = '';
            });
            _showStatusDialog('Your account is currently inactive');
          }
        }
      }
    });
  }

  Future<void> getAuthorStatus() async {
    return FirebaseFirestore.instance
        .collection('authors')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String tempEmail = doc.get('email');
        if (tempEmail == emailController.text) {
          username = doc.get('name');
          userId = doc.id;
          String status = doc.get('status');
          if (status == 'active') {
            toAuthorDash();
          } else {
            setState(() {
              loading = 'false';
              emailController.text = '';
              passwordController.text = '';
            });
            _showStatusDialog('Your account is currently inactive');
          }
        }
      }
    });
  }

  Future<void> getEngineerStatus() async {
    return FirebaseFirestore.instance
        .collection('engineers')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String tempEmail = doc.get('email');
        if (tempEmail == emailController.text) {
          username = doc.get('name');
          userId = doc.id;
          String status = doc.get('status');
          if (status == 'active') {
            toEngineerDash();
          } else {
            setState(() {
              loading = 'false';
              emailController.text = '';
              passwordController.text = '';
            });
            _showStatusDialog('Your account is currently inactive');
          }
        }
      }
    });
  }

  Future<void> getWorkerStatus() async {
    return FirebaseFirestore.instance
        .collection('workers')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String tempEmail = doc.get('email');
        if (tempEmail == emailController.text) {
          username = doc.get('name');
          userId = doc.id;
          String status = doc.get('status');
          if (status == 'active') {
            toWorkerDash();
          } else {
            setState(() {
              loading = 'false';
              emailController.text = '';
              passwordController.text = '';
            });
            _showStatusDialog('Your account is currently inactive');
          }
        }
      }
    });
  }

  Future<void> _showDialog(String? errorMesssage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorMessage!),
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
                Navigator.pop(context); // pop current page
                Navigator.pushNamed(context, "Setting"); // push it back in
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showStatusDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
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
                Navigator.pop(context); // pop current page
                Navigator.pushNamed(context, "Setting"); // push it back in
              },
            ),
          ],
        );
      },
    );
  }

  void toForgot() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => GetLink()));
  }

  String access = '';

  void handleTimeout() {
    if (access == 'client') {
      getClientStatus();
    } else if (access == 'manager') {
      getAuthorStatus();
    } else if (access == 'company') {
      getCompanyStatus();
    } else if (access == 'engineer') {
      getEngineerStatus();
    } else if (access == 'worker') {
      getWorkerStatus();
    } else {
      _showDialog('Something went wrong');
    }
  }
}
