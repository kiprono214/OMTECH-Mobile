import 'package:flutter/material.dart';

class ViewMedia extends StatefulWidget {
  ViewMedia({Key? key}) : super(key: key);

  @override
  State<ViewMedia> createState() => _ViewMediaState();
}

class _ViewMediaState extends State<ViewMedia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: 60,
                                alignment: Alignment.bottomLeft,
                                child: const Icon(Icons.arrow_back))),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const Text(
                            'Work Order Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                  ]))
            ]))));
  }
}
