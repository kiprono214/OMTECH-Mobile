import 'dart:io';

import 'package:OMTECH/screens/author_screens/author_home.dart';
import 'package:OMTECH/tools/drop_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../authentication/login.dart';
import 'asset_work_orders.dart';

DateTime currentDate = DateTime.now();
DateTime lastMaintainedDate = DateTime.now();

class CreateWorkOrder extends StatefulWidget {
  CreateWorkOrder({Key? key, required this.assetId}) : super(key: key);

  String assetId;

  @override
  State<CreateWorkOrder> createState() => _CreateWorkOrderState();
}

class _CreateWorkOrderState extends State<CreateWorkOrder> {
  TextEditingController name = TextEditingController(text: '');
  TextEditingController comment = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFrequency.addListener(() {
      setState(() {});
      getLastMaintained();
    });
    getId();
    getAsset();
    companyAssign = null;
    natureButton = null;
    frequencyButton = null;
    textFrequency.text = '';
  }

  final _formKey = GlobalKey<FormState>();

  void getAsset() async {
    FirebaseFirestore.instance
        .collection('assets')
        .where('unique_id', isEqualTo: widget.assetId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          assetName.text = doc.get('name');
          w_o_engineer.text = doc.get('engineer');
          w_o_category.text = doc.get('subsystem');
          assetIdController.text = doc.id;
          assetDesignRef.text = doc.get('design');
          uniqueAssetId.text = doc.get('unique_id');
          assetProject.text = doc.get('project');
          assetLocation.text = doc.get('room');
        });
      }
    });
    getProjectDoc();
  }

  @override
  Widget build(BuildContext context) {
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
        cursorColor: Colors.black45,
        cursorWidth: 0.8,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Task name',
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
    final commentField = TextFormField(
        autofocus: false,
        controller: comment,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          comment.text = value!;
        },
        cursorColor: Colors.black45,
        cursorWidth: 0.8,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Comment',
          filled: true,
          fillColor: Colors.transparent,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.transparent, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.transparent, width: 0.2),
          ),
        ));
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(children: [
                      Stack(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AssetWorkOrders(
                                        uniqueId: widget.assetId)));
                              },
                              child: Container(
                                  width: 60,
                                  alignment: Alignment.bottomLeft,
                                  child: const Icon(Icons.arrow_back))),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Fill Work Order Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22),
                            ),
                          )
                        ],
                      ),
                    ])),
                SizedBox(height: 20),
                Container(width: double.infinity, height: 50, child: nameField),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: Nature(),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: getFrequency(),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black87, width: 0.2),
                      ),
                      child: Stack(
                        children: [
                          Text(
                            datePicked,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child:
                                  SvgPicture.asset('assets/images/Icons.svg'))
                        ],
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: Priority(),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _selectLastDate(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black87, width: 0.2),
                      ),
                      child: Stack(
                        children: [
                          Text(
                            lastMaintainedPicked,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child:
                                  SvgPicture.asset('assets/images/Icons.svg'))
                        ],
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: CompaniesDropDown(from: 'kwenu'),
                ),
                SizedBox(height: 10),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: commentField,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black87, width: 0.2),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 18,
                              width: 18,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 18,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Add Image',
                                style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        _pickVideo();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 18,
                              width: 18,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 15,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Colors.black),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              height: 18,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Add Video',
                                style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var att in attachments)
                            Container(
                              height: 24,
                              width: 120,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                      width: 60,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(att[1])),
                                  GestureDetector(
                                    onTap: () {
                                      updatedAttachmentsDelete(
                                          workOrderId.toString(), att[0]);
                                    },
                                    child: const Icon(
                                      Icons.cancel_sharp,
                                      size: 20,
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      addNewWorkOrder();
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

  void addNewWorkOrder() async {
    String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
    // getAssetId();
    if (comment.text == '') {
      // comment.text = 'Work Order Created on $dateNow';
    }

    await FirebaseFirestore.instance
        .collection('projects')
        .where('title', isEqualTo: assetProject.text)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          address = doc.get('address');
          author = doc.get('managerName');
          client = doc.get('client');
        });
      }
    });
    // if (companyAssign == null || natureButton == null) {
    //   _showAttDialog('Some details missing');
    //   return;
    // }
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(workOrderId.toString())
        .set({
      'date_created': dateNow,
      'name': name.text,
      'assignee': companyAssign!,
      'frequency': frequencyButton!,
      'date': datePicked,
      'last_maintained': lastMaintainedPicked,
      'nature': natureButton!,
      'project': assetProject.text,
      'status': 'Pending Approval',
      'room': assetLocation.text,
      'asset': assetName.text,
      'engineer': w_o_engineer.text,
      'address': address,
      'author': author,
      'client': client,
      'category': w_o_category.text,
      'asset_id': widget.assetId,
      'created_by': username,
      'creator_access': 'worker',
      'priority': priorityButton!
    }).then((value) {
      addComment();
    });
  }

  String address = '';
  String author = '';
  String client = '';

  void getProjectDoc() async {
    await FirebaseFirestore.instance
        .collection('projects')
        .where('title', isEqualTo: assetProject.text)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          address = doc.get('address');
          author = doc.get('managerName');
          client = doc.get('client');
        });
      }
    });
  }

  List<List> attachments = [];

  Future<void> getMedia() async {
    List<List> temp = [];
    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(workOrderId.toString())
        .collection('attachments')
        // .where('type', isEqualTo: 'image')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        List obj = [doc.id, doc.get('name')];
        temp.add(obj);
        setState(() {
          attachments.clear();
          attachments.addAll(temp);
        });
      }
    });
  }

  // Future<void> getMedia() async {
  //   List<List> temp = [];
  //   await FirebaseFirestore.instance
  //       .collection('n_w_o_images')
  //       .doc(workOrderId.toString())
  //       .collection('attachments')
  //       .where('type', isEqualTo: 'image')
  //       .get()
  //       .then((value) {
  //     for (var doc in value.docs) {
  //       List obj = [doc.id, doc.get('name')];
  //       temp.add(obj);
  //       setState(() {
  //         attachments.clear();
  //         attachments.addAll(temp);
  //       });
  //     }
  //   });
  // }

  Future<void> updatedAttachmentsDelete(String id, String roomId) async {
    getMedia();
    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(id)
        .collection('attachments')
        .doc(roomId)
        .delete();

    String tempId = workOrderId.toString();
    FirebaseStorage.instance
        .ref()
        .child('new_work_orders/$tempId/$attId')
        .delete();

    for (var att in attachments) {
      if (att[0] == roomId) {
        setState(() {
          attachments.remove(att);
        });
      }
    }
    getMedia();
    return;
  }

  String attId = '0';

  Future<void> addMedia() async {
    getMedia();
    setState(() {
      int tempIdd = attachments.length + 1;
      attId = tempIdd.toString();
    });
    List ids = [];
    for (var att in attachments) {
      ids.add(att[0]);
    }
    if (ids.contains(attId)) {
      setState(() {
        attId = (attachments.length + 2).toString();
      });
    }
    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(workOrderId.toString())
        .delete();
    if (imgAsset!.contains('.mp4')) {
      await FirebaseFirestore.instance
          .collection('n_w_o_images')
          .doc(workOrderId.toString())
          .collection('attachments')
          .doc(attId)
          .set({'name': 'Video ' + attId, 'type': 'video'}).then((value) {
        getMedia();
      });
    } else {
      await FirebaseFirestore.instance
          .collection('n_w_o_images')
          .doc(workOrderId.toString())
          .collection('attachments')
          .doc(attId)
          .set({'name': 'Image ' + attId, 'type': 'image'}).then((value) {
        getMedia();
      });
    }
  }

  Widget getFrequency() {
    if (textFrequency.text == 'Reactive') {
      frequencyButton = 'N/A';
      return Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 0.2),
        ),
        alignment: Alignment.centerLeft,
        child: Text(frequencyButton!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      );
    } else {
      frequencyButton = null;
      return Frequency();
    }
  }

  TextEditingController assetId = TextEditingController(text: '');

  String commentId = '0';

  void getAssetId() async {
    await FirebaseFirestore.instance
        .collection('assets')
        .where('name', isEqualTo: assetName.text)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          assetId.text = doc.get('unique_id');
          assetProject.text = doc.get('project');
          assetLocation.text = doc.get('room_location');
        });
      }
    });
  }

  dynamic assetImg;

  String? imgAsset;

  Future<void> _pickImage() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    //   allowMultiple: false,
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'png', 'svg', 'mp4'],
    // );

    File plat = File(result!.path);

    // if no file is picked
    if (result == null) return;

    setState(() {
      assetImg = result.path;
      imgAsset = result.name;
    });

    getMedia();
    addMedia();

    String tempId = workOrderId.toString();

    await FirebaseStorage.instance
        .ref('new_work_orders/$tempId/$attId')
        .putData(assetImg);

    // await _showAttDialog('Attachment File Added');
  }

  Future<void> _pickVideo() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result =
        await ImagePicker.platform.getVideo(source: ImageSource.gallery);
    //   allowMultiple: false,
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'png', 'svg', 'mp4'],
    // );

    File plat = File(result!.path);

    // if no file is picked
    if (result == null) return;

    setState(() {
      assetImg = result.path;
      imgAsset = result.name;
    });

    getMedia();
    addMedia();

    String tempId = workOrderId.toString();

    await FirebaseStorage.instance
        .ref('new_work_orders/$tempId/$attId')
        .putData(assetImg);

    // await _showAttDialog('Attachment File Added');
  }

  Future<void> _showAttDialog(String string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(string),
            content: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  height: 80,
                  width: 200,
                  alignment: Alignment.center,
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ));
      },
    );
  }

  String datePicked = 'Date to be Performed';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        datePicked = DateFormat("dd/MM/yyyy").format(currentDate);
      });
    }
  }

  String lastMaintainedPicked = 'Last Maintained';

  Future<void> _selectLastDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        lastMaintainedDate = pickedDate;
        lastMaintainedPicked =
            DateFormat("dd/MM/yyyy").format(lastMaintainedDate);
      });
    }
  }

  String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  int workOrderId = 0;

  void getId() async {
    List ids = [];
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        ids.add(doc.id);
      }
      String check = ids.length.toString();
      if (ids.contains(check)) {
        setState(() {
          workOrderId = ids.length + 1;
        });
      } else {
        setState(() {
          workOrderId = ids.length;
        });
      }
    });
  }

  void getLastMaintained() {
    if (natureButton != null) {
      setState(() {
        textFrequency.text = natureButton!;
      });
    }

    if (textFrequency.text == 'Reactive') {
      lastMaintainedPicked = 'N/A';
    } else {
      lastMaintainedPicked = 'Last Maintained';
    }
  }

  TextEditingController taskName = TextEditingController(text: '');
  // TextEditingController date = TextEditingController(text: '');
  TextEditingController lastMaintained = TextEditingController(text: '');
  // TextEditingController comment = TextEditingController(text: '');

  void addComment() async {
    String dateNow = DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());

    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(workOrderId.toString())
        .collection('comments')
        .doc(commentId)
        .set({
      'user_task': 'creator',
      'comment': comment.text,
      'user': username,
      'user_type': 'worker',
      'date': dateNow,
      'caption': dateNow
    }).then((value) => _showDialog('Work Order Added'));
  }

  Future<void> _showDialog(String string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(string),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                OK()
                // Text('This is a demo alert dialog.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }
}

class OK extends ConsumerStatefulWidget {
  OK({Key? key}) : super(key: key);

  @override
  ConsumerState<OK> createState() => _OKState();
}

class _OKState extends ConsumerState<OK> {
  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
          height: 80,
          width: 200,
          alignment: Alignment.center,
          child: const Text(
            'OK',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          )),
      onPressed: () {
        Navigator.pop(context);

        _selectPage(context, ref, 'assets');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AuthorHome()));
      },
    );
  }
}

class EditWorkOrder extends StatefulWidget {
  EditWorkOrder(
      {Key? key,
      required this.assetId,
      required this.name,
      required this.category,
      required this.date,
      required this.address,
      required this.project,
      required this.author,
      required this.client,
      required this.date_created,
      required this.company,
      required this.room,
      required this.creator,
      required this.frequency,
      required this.nature,
      required this.lastMaintained,
      required this.asset,
      required this.engineer,
      required this.id,
      required this.assetDesignRef,
      required this.imgUrl});

  String? from;

  String name;
  String category;
  String date;
  String address;
  String project;
  String author;
  String client;
  String date_created;
  String company;
  String room;
  String creator;
  String frequency;
  String nature;
  String lastMaintained;
  String asset;
  String engineer;
  String id;
  String assetId;
  String assetDesignRef;
  String imgUrl;

  @override
  State<EditWorkOrder> createState() => _EditWorkOrderState();
}

class _EditWorkOrderState extends State<EditWorkOrder> {
  TextEditingController name = TextEditingController(text: '');
  TextEditingController comment = TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFrequency.addListener(() {
      setState(() {});
      getLastMaintained();
    });
    getId();
    getAsset();
    name.text = widget.name;

    companyAssign = null;
    natureButton = null;
    frequencyButton = null;
    textFrequency.text = '';
  }

  final _formKey = GlobalKey<FormState>();

  void getAsset() async {
    FirebaseFirestore.instance
        .collection('assets')
        .where('unique_id', isEqualTo: widget.assetId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          assetName.text = doc.get('name');
          w_o_engineer.text = doc.get('engineer');
          w_o_category.text = doc.get('subsystem');
          assetIdController.text = doc.id;
          assetDesignRef.text = doc.get('design');
          uniqueAssetId.text = doc.get('unique_id');
          assetProject.text = doc.get('project');
          assetLocation.text = doc.get('room');
        });
      }
    });
    getProjectDoc();
  }

  @override
  Widget build(BuildContext context) {
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
        cursorColor: Colors.black45,
        cursorWidth: 0.8,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Task name',
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
    final commentField = TextFormField(
        autofocus: false,
        controller: comment,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          // reg expression for email validation

          return null;
        },
        onSaved: (value) {
          comment.text = value!;
        },
        cursorColor: Colors.black45,
        cursorWidth: 0.8,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Comment',
          filled: true,
          fillColor: Colors.transparent,
          //prefixIcon: Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.transparent, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.transparent, width: 0.2),
          ),
        ));
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(children: [
                      Stack(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AssetWorkOrders(
                                        uniqueId: widget.assetId)));
                              },
                              child: Container(
                                  width: 60,
                                  alignment: Alignment.bottomLeft,
                                  child: const Icon(Icons.arrow_back))),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text(
                              'Fill Work Order Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22),
                            ),
                          )
                        ],
                      ),
                    ])),
                SizedBox(height: 20),
                Container(width: double.infinity, height: 50, child: nameField),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: Nature(),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: getFrequency(),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black87, width: 0.2),
                      ),
                      child: Stack(
                        children: [
                          Text(
                            datePicked,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child:
                                  SvgPicture.asset('assets/images/Icons.svg'))
                        ],
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: Priority(),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _selectLastDate(context);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black87, width: 0.2),
                      ),
                      child: Stack(
                        children: [
                          Text(
                            lastMaintainedPicked,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child:
                                  SvgPicture.asset('assets/images/Icons.svg'))
                        ],
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: CompaniesDropDown(from: 'kwenu'),
                ),
                SizedBox(height: 10),
                Container(
                  height: 100,
                  width: double.infinity,
                  child: commentField,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black87, width: 0.2),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 18,
                          width: 18,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 15,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          height: 18,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Add Media',
                            style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 100,
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var att in attachments)
                            Container(
                              height: 24,
                              width: 120,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                      width: 60,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(att[1])),
                                  GestureDetector(
                                    onTap: () {
                                      updatedAttachmentsDelete(
                                          workOrderId.toString(), att[0]);
                                    },
                                    child: const Icon(
                                      Icons.cancel_sharp,
                                      size: 20,
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      addNewWorkOrder();
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

  void addNewWorkOrder() async {
    String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
    // getAssetId();
    if (comment.text == '') {
      // comment.text = 'Work Order Created on $dateNow';
    }

    await FirebaseFirestore.instance
        .collection('projects')
        .where('title', isEqualTo: assetProject.text)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          address = doc.get('address');
          author = doc.get('managerName');
          client = doc.get('client');
        });
      }
    });
    // if (companyAssign == null || natureButton == null) {
    //   _showAttDialog('Some details missing');
    //   return;
    // }
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(workOrderId.toString())
        .set({
      'date_created': dateNow,
      'name': name.text,
      'assignee': companyAssign!,
      'frequency': frequencyButton!,
      'date': datePicked,
      'last_maintained': lastMaintainedPicked,
      'nature': natureButton!,
      'project': assetProject.text,
      'status': 'Pending Approval',
      'room': assetLocation.text,
      'asset': assetName.text,
      'engineer': w_o_engineer.text,
      'address': address,
      'author': author,
      'client': client,
      'category': w_o_category.text,
      'asset_id': widget.assetId,
      'created_by': username,
      'creator_access': 'author',
      'priority': priorityButton!
    }).then((value) {
      addComment();
    });
  }

  String address = '';
  String author = '';
  String client = '';

  void getProjectDoc() async {
    await FirebaseFirestore.instance
        .collection('projects')
        .where('title', isEqualTo: assetProject.text)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          address = doc.get('address');
          author = doc.get('managerName');
          client = doc.get('client');
        });
      }
    });
  }

  List<List> attachments = [];

  Future<void> getMedia() async {
    List<List> temp = [];
    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(workOrderId.toString())
        .collection('attachments')
        // .where('type', isEqualTo: 'image')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        List obj = [doc.id, doc.get('name')];
        temp.add(obj);
        setState(() {
          attachments.clear();
          attachments.addAll(temp);
        });
      }
    });
  }

  // Future<void> getMedia() async {
  //   List<List> temp = [];
  //   await FirebaseFirestore.instance
  //       .collection('n_w_o_images')
  //       .doc(workOrderId.toString())
  //       .collection('attachments')
  //       .where('type', isEqualTo: 'image')
  //       .get()
  //       .then((value) {
  //     for (var doc in value.docs) {
  //       List obj = [doc.id, doc.get('name')];
  //       temp.add(obj);
  //       setState(() {
  //         attachments.clear();
  //         attachments.addAll(temp);
  //       });
  //     }
  //   });
  // }

  Future<void> updatedAttachmentsDelete(String id, String roomId) async {
    getMedia();
    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(id)
        .collection('attachments')
        .doc(roomId)
        .delete();

    String tempId = workOrderId.toString();
    FirebaseStorage.instance
        .ref()
        .child('new_work_orders/$tempId/$attId')
        .delete();

    for (var att in attachments) {
      if (att[0] == roomId) {
        setState(() {
          attachments.remove(att);
        });
      }
    }
    getMedia();
    return;
  }

  String attId = '0';

  Future<void> addMedia() async {
    getMedia();
    setState(() {
      int tempIdd = attachments.length + 1;
      attId = tempIdd.toString();
    });
    List ids = [];
    for (var att in attachments) {
      ids.add(att[0]);
    }
    if (ids.contains(attId)) {
      setState(() {
        attId = (attachments.length + 2).toString();
      });
    }
    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(workOrderId.toString())
        .delete();
    if (imgAsset!.contains('.mp4')) {
      await FirebaseFirestore.instance
          .collection('n_w_o_images')
          .doc(workOrderId.toString())
          .collection('attachments')
          .doc(attId)
          .set({'name': 'Video ' + attId, 'type': 'video'}).then((value) {
        getMedia();
      });
    } else {
      await FirebaseFirestore.instance
          .collection('n_w_o_images')
          .doc(workOrderId.toString())
          .collection('attachments')
          .doc(attId)
          .set({'name': 'Image ' + attId, 'type': 'image'}).then((value) {
        getMedia();
      });
    }
  }

  Widget getFrequency() {
    if (textFrequency.text == 'Reactive') {
      frequencyButton = 'N/A';
      return Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 0.2),
        ),
        alignment: Alignment.centerLeft,
        child: Text(frequencyButton!,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      );
    } else {
      frequencyButton = null;
      return Frequency();
    }
  }

  TextEditingController assetId = TextEditingController(text: '');

  String commentId = '0';

  void getAssetId() async {
    await FirebaseFirestore.instance
        .collection('assets')
        .where('name', isEqualTo: assetName.text)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          assetId.text = doc.get('unique_id');
          assetProject.text = doc.get('project');
          assetLocation.text = doc.get('room_location');
        });
      }
    });
  }

  dynamic assetImg;

  String? imgAsset;

  Future<void> _pickImage() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result =
        await ImagePicker.platform.getVideo(source: ImageSource.gallery);
    //   allowMultiple: false,
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'png', 'svg', 'mp4'],
    // );

    File plat = File(result!.path);

    // if no file is picked
    if (result == null) return;

    setState(() {
      assetImg = result.path;
      imgAsset = result.name;
    });

    getMedia();
    addMedia();

    String tempId = workOrderId.toString();

    await FirebaseStorage.instance
        .ref('new_work_orders/$tempId/$attId')
        .putData(assetImg);

    // await _showAttDialog('Attachment File Added');
  }

  Future<void> _showAttDialog(String string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(string),
            content: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  height: 80,
                  width: 200,
                  alignment: Alignment.center,
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ));
      },
    );
  }

  String datePicked = 'Date to be Performed';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        datePicked = DateFormat("dd/MM/yyyy").format(currentDate);
      });
    }
  }

  String lastMaintainedPicked = 'Last Maintained';

  Future<void> _selectLastDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        lastMaintainedDate = pickedDate;
        lastMaintainedPicked =
            DateFormat("dd/MM/yyyy").format(lastMaintainedDate);
      });
    }
  }

  String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  int workOrderId = 0;

  void getId() async {
    List ids = [];
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        ids.add(doc.id);
        String check = ids.length.toString();
        if (ids.contains(check)) {
          workOrderId = ids.length + 1;
        } else {
          workOrderId = ids.length;
        }
      }
    });
  }

  void getLastMaintained() {
    if (natureButton != null) {
      setState(() {
        textFrequency.text = natureButton!;
      });
    }

    if (textFrequency.text == 'Reactive') {
      lastMaintainedPicked = 'N/A';
    } else {
      lastMaintainedPicked = 'Last Maintained';
    }
  }

  TextEditingController taskName = TextEditingController(text: '');
  // TextEditingController date = TextEditingController(text: '');
  TextEditingController lastMaintained = TextEditingController(text: '');
  // TextEditingController comment = TextEditingController(text: '');

  void addComment() async {
    String dateNow = DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());

    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(workOrderId.toString())
        .collection('comments')
        .doc(commentId)
        .set({
      'user_task': 'creator',
      'comment': comment.text,
      'user': username,
      'user_type': 'worker',
      'date': dateNow,
      'caption': dateNow
    }).then((value) => _showDialog('Work Order Added'));
  }

  Future<void> _showDialog(String string) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(string),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                OK()
                // Text('This is a demo alert dialog.'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }
}
