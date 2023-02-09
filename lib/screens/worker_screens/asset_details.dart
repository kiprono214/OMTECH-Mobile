import 'package:OMTECH/screens/worker_screens/asset_work_orders.dart';
import 'package:OMTECH/screens/worker_screens/worker_home.dart';
import 'package:OMTECH/screens/worker_screens/create_asset.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

String _assetId = '';
String _imgUrl = '';
String _date = '';
String _id = '';
String _name = '';
String _location = '';
String _project = '';
String _design = '';
String _serial = '';
String _model = '';
String _status = '';
String _system = '';
String _subsystem = '';
String _type = '';
String _engineer = '';
String _expectancy = '';
String _details = '';

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
          _selectPage(context, ref, 'assets');
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
      required this.assetId,
      required this.date,
      required this.id,
      required this.imgUrl,
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

  String assetId,
      date,
      imgUrl,
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
      assetId: assetId,
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
      required this.assetId,
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

  String assetId,
      date,
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
    getDocuments();
    if (widget.imgUrl == '') {
      getImg();
    }
  }

  Future<void> getImg() async {
    await FirebaseFirestore.instance
        .collection('images')
        .where('asset', isEqualTo: widget.assetId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          widget.imgUrl = doc.get('name');
          print(widget.assetId);
        });
      }
    });
    final ref = await FirebaseStorage.instance
        .ref()
        .child('asset_images/$widget.imgUrl');
    // no need of the file extension, the name will do fine.
    String temp = await ref.getDownloadURL();
    setState(() {
      widget.imgUrl = temp;
      print('????????????????????????????????????' + widget.imgUrl);
    });
  }

  String manf_name = '',
      manf_email = '',
      manf_phone = '',
      manf_web = '',
      manf_address1 = '',
      manf_address2 = '',
      manf_address3 = '',
      manf_address_4 = '';

  void getManufacturerDetails() async {
    await FirebaseFirestore.instance
        .collection('manufacturers')
        .where('asset', isEqualTo: widget.assetId)
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

  Widget getIconWidget(String docName) {
    String newString = docName.substring(docName.length - 4);
    if (newString == '.jpg') {
      return SvgPicture.asset(
        'assets/images/pdf (2) 1.svg',
        height: 21,
        width: 16,
      );
    } else if (newString == '.pdf') {
      return SvgPicture.asset(
        'assets/images/pdf (2) 1.svg',
        height: 21,
        width: 16,
      );
    } else if (newString == '.xls') {
      return SvgPicture.asset(
        'assets/images/Group (2).svg',
        height: 21,
        width: 16,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/pdf (2) 1.svg',
        height: 21,
        width: 16,
      );
    }
  }

  List<Map<String, String>> attachedDocs = [];

  void getDocuments() async {
    await FirebaseFirestore.instance
        .collection('attachments')
        .where('asset', isEqualTo: widget.assetId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        String type = doc.get('type');
        String name = doc.get('name');
        attachedDocs.add(<String, String>{type: name});
      }
    });
  }

  void _showManDialogue() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: const EdgeInsets.only(bottom: 200),
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                  width: 360,
                  height: 400,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(120, 122, 155, 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            'Manufacturer Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 240,
                          child: Row(
                            children: [
                              Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Name:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                  child: Text(manf_name,
                                      style: TextStyle(
                                        fontSize: 14,
                                      )))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 240,
                          child: Row(
                            children: [
                              Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Email:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                  width: 120,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      manf_email,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 240,
                          child: Row(
                            children: [
                              Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Telephone:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                  child: Text(
                                manf_phone,
                                style: TextStyle(fontSize: 14),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 240,
                          child: Row(
                            children: [
                              Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Web_Link:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                  child: Text(
                                manf_web,
                                style: TextStyle(fontSize: 14),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 240,
                          child: Row(
                            children: [
                              Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Address One:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                  child: Text(manf_address1,
                                      style: TextStyle(fontSize: 14))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 240,
                          child: Row(
                            children: [
                              Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Address Two:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                  child: Text(manf_address2,
                                      style: TextStyle(fontSize: 14))),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 240,
                          child: Row(
                            children: [
                              Container(
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Address Three:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Container(
                                  child: Text(
                                manf_address3,
                                style: TextStyle(fontSize: 14),
                              )),
                            ],
                          ),
                        ),
                      ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topLeft,
            height: 800,
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
                        Stack(
                          children: [
                            AssetDetailBackPress(),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const Text(
                                'Asset Details',
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
                        Container(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              widget.imgUrl,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 200,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 15,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            'assets/images/Vector (6).svg',
                                            height: 14,
                                            width: 14),
                                      ),
                                      Container(
                                        height: 15,
                                        width: 15,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/images/Vector (7).svg',
                                          height: 2.7,
                                          width: 4.5,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 20,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Project Name: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800),
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
                              height: 20,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                      width: 100,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Room Location: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800),
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
                              width: 200,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Group 4911.svg',
                                    height: 17,
                                    width: 17,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => EditAsset(
                                                  assetId: assetId,
                                                  date: date,
                                                  id: id,
                                                  name: name,
                                                  project: project,
                                                  design: design,
                                                  serial: serial,
                                                  location: location,
                                                  model: model,
                                                  status: status,
                                                  system: system,
                                                  subsystem: subsystem,
                                                  type: type,
                                                  engineer: engineer,
                                                  expectancy: expectancy,
                                                  details: details)));
                                    },
                                    child: Container(
                                        width: 130,
                                        alignment: Alignment.centerLeft,
                                        child: const Text(
                                          'Update Asset Details',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  0, 122, 255, 1)),
                                        )),
                                  ),
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
                              'assets/images/Group 55802.svg',
                              height: 26,
                              width: 26,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'System',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(
                                  system,
                                  style: const TextStyle(fontSize: 14),
                                ))
                          ]),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/images/Group 55802.svg',
                              height: 26,
                              width: 26,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'Sub-System',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(subsystem,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ))),
                          ]),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/images/Group 55804.svg',
                              height: 26,
                              width: 26,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'Serial N0.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(
                                  serial,
                                  style: const TextStyle(fontSize: 14),
                                ))
                          ]),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/images/Group 55804.svg',
                              height: 26,
                              width: 26,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'Asset Design Ref',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(
                                  design,
                                  style: const TextStyle(fontSize: 14),
                                ))
                          ]),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/images/Group 55802.svg',
                              height: 26,
                              width: 26,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'Unique Asset ID',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(
                                  id,
                                  style: const TextStyle(fontSize: 14),
                                ))
                          ]),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/images/Group 55807.svg',
                              height: 26,
                              width: 26,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'Asset Type',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: Text(
                                  type,
                                  style: const TextStyle(fontSize: 14),
                                ))
                          ]),
                        ),
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Row(children: [
                            SvgPicture.asset(
                              'assets/images/Group 55802.svg',
                              height: 26,
                              width: 26,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                height: double.infinity,
                                alignment: Alignment.centerLeft,
                                width: 120,
                                child: const Text(
                                  'Manufacturer',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                            GestureDetector(
                              onTap: () {
                                _showManDialogue();
                              },
                              child: Container(
                                  height: double.infinity,
                                  width: 120,
                                  alignment: Alignment.center,
                                  child: Text(
                                    manf_name,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                        color: Color.fromRGBO(0, 122, 255, 1)),
                                  )),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 20,
                      width: double.infinity,
                      alignment: Alignment.bottomLeft,
                      margin:
                          const EdgeInsets.only(left: 50, right: 20, top: 10),
                      child: const Text(
                        'Documents',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 50, right: 20, top: 6),
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var doc in attachedDocs)
                          Container(
                            height: 20,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 8),
                            alignment: Alignment.centerLeft,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        doc.entries.first.key,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  getIconWidget(doc.entries.first.value),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 120,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        doc.entries.first.value,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            decoration:
                                                TextDecoration.underline,
                                            color: const Color.fromRGBO(
                                                34, 130, 234, 1)),
                                      ),
                                    ),
                                  )
                                ]),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) =>
                              AssetWorkOrders(uniqueId: id))));
                    },
                    child: Container(
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
                    ),
                  )
                ]))));
  }
}
