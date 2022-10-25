import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:OMTECH/screens/dashScreens/home.dart';
import 'package:OMTECH/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:OMTECH/tools/jumping_dots.dart';
import 'package:OMTECH/tools/three_bounce.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omtech Client',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      home: JumpingDots(),
    );
  }
}
