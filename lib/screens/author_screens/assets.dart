import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          _selectPage(context, ref, 'projects');
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

class AssetsStream extends StatefulWidget {
  AssetsStream({Key? key}) : super(key: key);

  @override
  State<AssetsStream> createState() => _AssetsStreamState();
}

class _AssetsStreamState extends State<AssetsStream> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    searchController.addListener(() {
      setState(() {});
    });
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
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Stack(
              children: [
                BackPress(),
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
                        margin: const EdgeInsets.only(left: 220),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromRGBO(46, 55, 73, 1)),
                        child: SvgPicture.asset(
                            'assets/images/Combined Shape.svg')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
