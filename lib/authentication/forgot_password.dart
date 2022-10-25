import 'package:flutter/material.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:OMTECH/authentication/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:OMTECH/screens/splashscreen.dart';

class GetLink extends StatefulWidget {
  const GetLink({Key? key}) : super(key: key);

  @override
  State<GetLink> createState() => _GetLinkState();
}

class _GetLinkState extends State<GetLink> {
  final TextEditingController emailController = new TextEditingController();

  // final user = FirebaseAuth.instance.currentUser!;

  var acs = ActionCodeSettings(
      // URL you want to redirect back to. The domain (www.example.com) for this
      // URL must be whitelisted in the Firebase Console.
      url: 'https://www.example.com/finishSignUp?cartId=1234',
      // This must be true
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      // installIfNotAvailable
      androidInstallApp: true,
      // minimumVersion
      androidMinimumVersion: '12');
  String statusText = "";

  @override
  Widget build(BuildContext context) {
    if (statusText == "Email sent") {
      _showAlert3(context, "", 0);
    }
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
        decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            //prefixIcon: Icon(Icons.mail),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            // hintText: "Email",
            border: InputBorder.none,
            hintText: 'Email'));

    final loginButton = Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(8),
      color: Colors.orangeAccent,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          height: 56,
          minWidth: 340,
          onPressed: () {
            sendLink();
            // sendEmail(emailController.text);
            // signIn(emailController.text, passwordController.text);
            // logIt(emailController.text, passwordController.text);
          },
          child: const Text(
            "Send Link",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 59, 73, 1),
      body: Stack(
        children: [
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
              height: 1018,
              child: Column(
                children: [
                  const SizedBox(
                    height: 170,
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
                    height: 60,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        child: const Text(
                            'Please note that a password reset link will be  \n sent to below email, only if it is registered with us',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.2,
                                fontSize: 12)),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/Rectangle 3.png"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        margin: const EdgeInsets.fromLTRB(40, 5, 40, 0),
                        child: emailField,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 40, right: 40),
                      child: loginButton),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: toLogin,
                      child: Container(
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        width: double.infinity,
                        child: const Text(
                          'Log In',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void toLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()));
  }

  void sendEmail(String email) async {
    final serviceId = 'service_57hjv3l';
    final templateId = 'template_v1uevni';
    final userId = 'dHvR76_JtXa5-g5OQ';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url, headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    }, body: {
      json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {'user_email': email}
      })
    });
  }

  Future<void> sendLink() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await firebaseAuth
        .sendPasswordResetEmail(email: emailController.text)
        .then((uid) => {_showMyDialog()});
  }

  void sendVerification(String email) async {
    var emailAuth = 'someemail@domain.com';
    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  void _showAlert3(BuildContext context, String text, int seconds) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Email sent"),
              content: Text(text),
            )).then((val) {});
    await Future.delayed(Duration(seconds: seconds));
    Navigator.of(context).pop(true);
  }

  void toforgot() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Login(
              key: Key('value'),
            )));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email sent'),
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
                toDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void toDialog() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()));
  }
}
