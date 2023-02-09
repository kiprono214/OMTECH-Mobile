import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TagDetails extends StatefulWidget {
  TagDetails(
      {required this.id,
      required this.name,
      required this.address,
      required this.room,
      required this.project,
      required this.asset,
      required this.assetId,
      required this.description});

  String id;
  String name;
  String address;
  String room;
  String project;
  String asset;
  String assetId;
  String description;

  @override
  State<TagDetails> createState() => _TagDetailsState();
}

class _TagDetailsState extends State<TagDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                    'Action Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 244, 249, 1),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tag Issue',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Asset Name',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.asset,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Asset Id',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.assetId,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Room Location',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.room,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Project',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.project,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Address',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.address,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 160,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      widget.description,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
