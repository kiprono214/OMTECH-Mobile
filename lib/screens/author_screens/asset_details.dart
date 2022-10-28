import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          _selectPage(context, ref, 'projects');
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

class AssetDetails extends StatefulWidget {
  AssetDetails(
      {Key? key,
      required this.date,
      required this.id,
      required this.name,
      required this.project,
      required this.design,
      required this.serial,
      required this.location,
      required this.model,
      required this.status,
      required this.system,
      required this.subsystem,
      required this.type,
      required this.engineer,
      required this.expectancy,
      required this.details})
      : super(key: key);

  String date,
      id,
      name,
      location,
      project,
      design,
      serial,
      model,
      status,
      system,
      subsystem,
      type,
      engineer,
      expectancy,
      details;

  @override
  // ignore: no_logic_in_create_state
  State<AssetDetails> createState() => _AssetDetailsState(
      date: date,
      id: id,
      name: name,
      location: location,
      project: project,
      design: design,
      serial: serial,
      model: model,
      status: status,
      system: system,
      subsystem: subsystem,
      type: type,
      engineer: engineer,
      expectancy: expectancy,
      details: details);
}

class _AssetDetailsState extends State<AssetDetails> {
  _AssetDetailsState(
      {Key? key,
      required this.date,
      required this.id,
      required this.name,
      required this.project,
      required this.design,
      required this.serial,
      required this.location,
      required this.model,
      required this.status,
      required this.system,
      required this.subsystem,
      required this.type,
      required this.engineer,
      required this.expectancy,
      required this.details});

  String date,
      id,
      name,
      location,
      project,
      design,
      serial,
      model,
      status,
      system,
      subsystem,
      type,
      engineer,
      expectancy,
      details;

  final TextEditingController titleController = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getManufacturerDetails();
    getImg();
  }

  String manf_name = '',
      manf_email = '',
      manf_phone = '',
      manf_web = '',
      manf_address1 = '',
      manf_address2 = '',
      manf_address3 = '',
      manf_address_4 = '';

  void getManufacturerDetails() {
    FirebaseFirestore.instance
        .collection('manufacturers')
        .where('asset', isEqualTo: '')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          manf_name = doc.get('name');
          manf_email = doc.get('email');
          manf_web = doc.get('web_link');
          manf_phone = doc.get('phone');
          manf_address1 = doc.get('address_one');
          manf_address2 = doc.get('address_two');
          manf_address3 = doc.get('address_three');
        });
      }
    });
  }

  String imgUrl = '';

  Future<void> getImg() async {
    await FirebaseFirestore.instance
        .collection('images')
        .where('asset', isEqualTo: '')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          imgUrl = doc.get('name');
          print('');
        });
      }
    });
    final ref = FirebaseStorage.instance.ref().child('asset_images/$imgUrl');
    // no need of the file extension, the name will do fine.
    String temp = await ref.getDownloadURL();
    setState(() {
      imgUrl = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                                'Assets Details',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22),
                              ),
                            )
                          ],
                        ),
                      ])),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    width: double.infinity,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(height: 100, width: 100),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              child: Row(
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                  Stack(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/Vector (7).svg',
                                          height: 14,
                                          width: 14),
                                      Container(
                                        height: 14,
                                        width: 14,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/images/Vector (6).svg',
                                          height: 2.7,
                                          width: 4.2,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Project Name: ',
                                        style: TextStyle(fontSize: 12),
                                      )),
                                  Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        project,
                                        style: TextStyle(fontSize: 12),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Room Location: ',
                                        style: TextStyle(fontSize: 12),
                                      )),
                                  Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        location,
                                        style: TextStyle(fontSize: 12),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Group (1).svg',
                                    height: 17,
                                    width: 17,
                                  ),
                                  Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Update Asset Details',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromRGBO(0, 122, 255, 1)),
                                      )),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 40, right: 20, top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(246, 250, 255, 1)),
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/images/Group 48433.svg',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                width: 120,
                                child: const Text(
                                  'System',
                                  style: TextStyle(fontSize: 16),
                                )),
                            Container(
                                height: double.infinity,
                                width: 120,
                                child: Text(
                                  system,
                                  style: const TextStyle(fontSize: 16),
                                ))
                          ]),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/images/Group 48433.svg',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                width: 120,
                                child: const Text(
                                  'Sub-System',
                                  style: TextStyle(fontSize: 16),
                                )),
                            Container(
                                height: double.infinity,
                                width: 120,
                                child: Text(
                                  subsystem,
                                  style: const TextStyle(fontSize: 16),
                                )),
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                SvgPicture.asset(
                                  'assets/images/Group 48433.svg',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: const Text(
                                      'Serial N0.',
                                      style: TextStyle(fontSize: 16),
                                    )),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: Text(
                                      serial,
                                      style: const TextStyle(fontSize: 16),
                                    ))
                              ]),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                SvgPicture.asset(
                                  'assets/images/Group 48433.svg',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: const Text(
                                      'Asset Design Ref',
                                      style: TextStyle(fontSize: 16),
                                    )),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: Text(
                                      design,
                                      style: const TextStyle(fontSize: 16),
                                    ))
                              ]),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                SvgPicture.asset(
                                  'assets/images/Group 48433.svg',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: const Text(
                                      'Unique Asset ID',
                                      style: TextStyle(fontSize: 16),
                                    )),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: Text(
                                      id,
                                      style: const TextStyle(fontSize: 16),
                                    ))
                              ]),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                SvgPicture.asset(
                                  'assets/images/Group 48433.svg',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: const Text(
                                      'Asset Type',
                                      style: TextStyle(fontSize: 16),
                                    )),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: Text(
                                      type,
                                      style: const TextStyle(fontSize: 16),
                                    ))
                              ]),
                            ),
                            Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                SvgPicture.asset(
                                  'assets/images/Group 48433.svg',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: const Text(
                                      'Manufacturer',
                                      style: TextStyle(fontSize: 16),
                                    )),
                                Container(
                                    height: double.infinity,
                                    width: 120,
                                    child: Text(
                                      'Manufacturer',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromRGBO(0, 122, 255, 1)),
                                    ))
                              ]),
                            )
                          ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 40, right: 20, top: 10),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                  height: double.infinity,
                                  width: 120,
                                  child: const Text(
                                    'Documents',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 174, 0, 1),
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: const Text(
                            'View Work Orders',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  )
                ]))));
  }
}
