import 'dart:ffi';
import 'dart:io';
import 'package:OMTECH/screens/worker_screens/worker_home.dart';
import 'package:flutter_downloader/flutter_downloader.dart' as down;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../authentication/login.dart';
import '../../tools/stopwatch.dart';

class WorkOrderDetails extends StatefulWidget {
  WorkOrderDetails(
      {this.from,
      required this.name,
      required this.category,
      required this.status,
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
      required this.assetId,
      required this.assetDesignRef,
      required this.imgUrl});

  String? from;

  String status;

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
  State<WorkOrderDetails> createState() => _WorkOrderDetailsState();
}

String useIDD = '';

class _WorkOrderDetailsState extends State<WorkOrderDetails> {
  bool visible = false;

  void getComments() async {
    comments.clear();
    List<DocumentSnapshot> temp = [];
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .orderBy('caption', descending: false)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        temp.add(doc);
      }
    });
    comments.addAll(temp);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage(imageId);
    getMedia();
    getVideos();
    getComments();

    getImg();
    setState(() {
      useIDD = widget.id;
    });
    commentWidget.addListener(() {
      if (commentWidget.text == 'started') {
        startWork();
        startWorkComment();
        // _setTimer.startStopwatch();
        getComments();
        setState(() {});
      } else if (commentWidget.text == 'paused') {
        setState(() {
          hold = 'yes';
        });
        attachedMedia.clear();
      }
    });
  }

  List<String> attachedMedia = [];

  Future<void> _pickImage() async {
    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'svg'],
    );

    // File plat = File(result!.files.first.path!);

    String useName =
        'OMT-Work_Order_Media_File_' + attachedMedia.length.toString();

    PlatformFile plat = result!.files.first;

    if (result == null) return;

    String id = widget.id;

    String commentIdAtt = comments.length.toString();

    String attachAtt = attachedMedia.length.toString();

    final ref = FirebaseStorage.instance
        .ref()
        .child('work_order_held/$id/$commentIdAtt/$useName');
    // no need of the file extension, the name will do fine.
    String temp = await ref.getDownloadURL();

    attachedMedia.add(useName);
  }

  File? image;
  Future pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'svg'],
      );

      File plat = File(result!.files.first.path!);

      setState(() {
        this.image = File(plat.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }

    String useName =
        'OMT-Work_Order_Media_File_' + (attachedMedia.length + 1).toString();

    String id = widget.id;

    String commentIdAtt = comments.length.toString();

    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(comments.length.toString())
        .collection('attached')
        .doc(attachedMedia.length.toString())
        .set({'name': useName, 'type': 'image'});

    if (image != null) {
      //Upload to Firebase
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('work_order_held/$id/$commentIdAtt/$useName')
          .putFile(image!);
      var downloadUrl = await snapshot.ref.getDownloadURL();
    } else {
      print('No Image Path Received');
    }
    attachedMedia.add(useName);
    setState(() {});
  }

  Future<void> startWork() async {
    String dateNow = DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .update({'last_maintained': dateNow, 'status': 'In Progress'}).then(
            (value) {
      setState(() {
        widget.status = 'In Progress';
      });
    });
  }

  // Stream<QuerySnapshot> get stopwatches {
  //   return ref.snapshots();
  // }

  Future<void> pauseWork() async {
    String dateNow = DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .update({
      'last_maintained': dateNow,
      'nature': 'On Hold',
      'status': 'On Hold'
    }).then((value) {
      setState(() {
        widget.status = 'On Hold';
      });
    });
  }

  Future<void> completeWork() async {
    String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .update({'last_maintained': dateNow, 'status': 'Completed'}).then(
            (value) {
      setState(() {
        widget.status = 'Completed';
      });
    });
  }

  TextEditingController comment = TextEditingController(text: '');

  Future<void> startWorkComment() async {
    String dateNow = DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(comments.length.toString())
        .set({
      'user_task': 'start',
      'comment': comment.text,
      'user': username,
      'user_type': 'worker',
      'date': dateNow,
      'caption': comments.length.toString()
    });

    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(comments.length.toString())
        .collection('attached')
        .doc('0')
        .set({'name': '', 'type': ''});
  }

  Future<void> pauseWorkComment() async {
    String dateNow = DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(comments.length.toString())
        .set({
      'user_task': 'pause',
      'comment': comment.text,
      'user': username,
      'user_type': 'worker',
      'date': dateNow,
      'caption': comments.length.toString()
    });
  }

  Future<void> completeWorkComment() async {
    String dateNow = DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(comments.length.toString())
        .set({
      'user_task': 'complete',
      'comment': comment.text,
      'user': username,
      'user_type': 'worker',
      'date': dateNow,
      'caption': comments.length.toString()
    });
  }

  Future<void> downloadFileAndShowProgress(String fileUrl) async {
    final String fileName = fileUrl.split('/').last;
    final Reference reference = FirebaseStorage.instance.ref(fileUrl);
    final String savePath = await getFilePath('attachments/$fileUrl');

    print('+++++++++++++++++++     +++++++++++++++++++++++++     $savePath');

    final DownloadTask downloadTask = reference.writeToFile(File(savePath));

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id', 'channel name', 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/launcher_icon",

      // smallIcon: 'assets/images/omlogo.png',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    downloadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final double progress =
          snapshot.bytesTransferred / snapshot.totalBytes * 100;
      if (snapshot.state == TaskState.running) {
        flutterLocalNotificationsPlugin.show(
          0,
          'Downloading $fileName',
          '${progress.toStringAsFixed(2)}%',
          platformChannelSpecifics,
          payload: 'item x',
        );
      }
    }, onError: (Object e) {
      print('Error downloading file: $e');
    });

    await downloadTask.whenComplete(() async {
      flutterLocalNotificationsPlugin.cancel(0);
      flutterLocalNotificationsPlugin.show(
        0,
        'Download complete',
        '$fileName downloaded to $savePath',
        platformChannelSpecifics,
        payload: 'item x',
      );
    });
  }

  Future<String> getFilePath(String fileName) async {
    final Directory? directory = await getExternalStorageDirectory();
    return '${directory!.path}/Documents';
  }

  List attachments = [];

  Future<void> addHolddMedia(String fileName, String index) async {
    String dateNow = DateFormat("hh:mm:ss").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(comments.length.toString())
        .collection('attached')
        .doc(index)
        .set({'name': fileName, 'type': 'image'});
  }

  Color imagesTab = Color.fromRGBO(0, 122, 255, 1);
  Color videosTab = Color.fromRGBO(55, 56, 59, 0.3);
  FontWeight imageWeight = FontWeight.w600;
  FontWeight videoWeight = FontWeight.w500;

  Color imageCon = Colors.white;
  Color videoCon = Colors.transparent;

  List<String> videoUrls = [];
  List<String> imageUrls = [];

  String tabClicked = 'images';

  Future<void> getImg() async {
    String name = '';
    String design = '';
    await FirebaseFirestore.instance
        .collection('assets')
        .where('unique_id', isEqualTo: widget.assetId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          name = doc.id;
          design = doc.get('design');
          print(name);
        });
      }
    });
    await FirebaseFirestore.instance
        .collection('images')
        .where('asset', isEqualTo: name)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          name = doc.get('name');
          print(name);
        });
      }
    });
    final ref =
        await FirebaseStorage.instance.ref().child('asset_images/$name');
    // no need of the file extension, the name will do fine.
    String temp = await ref.getDownloadURL();
    setState(() {
      widget.imgUrl = temp;
      widget.assetDesignRef = design;
      print('????????????????????????????????????' + widget.imgUrl);
    });
  }

  String newUrl = '';

  Color leftClick = Colors.black54;
  Color rightClick = Colors.orange;

  String hold = 'no';
  String complete = 'no';

  @override
  Widget build(BuildContext context) {
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
    return WillPopScope(
        onWillPop: () async {
          // You can do some work here.
          // Returning true allows the pop to happen, returning false prevents it.
          return true;
        },
        child: Stack(children: [
          Scaffold(
              backgroundColor: Colors.white,
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
                              (hold == 'yes')
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          hold = 'no';
                                        });
                                        // if (widget.from! == 'Reactive') {
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               ReactiveM()));
                                        // } else if (widget.from! ==
                                        //     'Preventative') {
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               PreventiveM()));
                                        // } else if (widget.from! ==
                                        //     'AssetDetails') {
                                        //   Navigator.pop(context);
                                        // } else {
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               AuthorHome()));
                                        // }
                                      },
                                      child: Container(
                                          width: 60,
                                          alignment: Alignment.bottomLeft,
                                          child: const Icon(Icons.arrow_back)))
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        // if (widget.from! == 'Reactive') {
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               ReactiveM()));
                                        // } else if (widget.from! ==
                                        //     'Preventative') {
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               PreventiveM()));
                                        // } else if (widget.from! ==
                                        //     'AssetDetails') {
                                        //   Navigator.pop(context);
                                        // } else {
                                        //   Navigator.of(context).push(
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               AuthorHome()));
                                        // }
                                      },
                                      child: Container(
                                          width: 60,
                                          alignment: Alignment.bottomLeft,
                                          child: const Icon(Icons.arrow_back))),
                              (complete == 'yes')
                                  ? Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Complete Work Order',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    )
                                  : (hold == 'yes')
                                      ? Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Hold Work Order',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        )
                                      : Container(
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
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20),
                              width: double.infinity,
                              child: Row(children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: getHolder()),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(children: [
                                  Container(
                                    height: 70,
                                    width: 180,
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 170,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            widget.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        (widget.status == 'Completed')
                                            ? Container(
                                                width: 170,
                                                alignment: Alignment.bottomLeft,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      visible = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'View Media',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 174, 0, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                  ),
                                                ),
                                              )
                                            : Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/images/Icon Stopwatch.svg'),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  (widget.status ==
                                                          'In Progress')
                                                      ? Container(
                                                          child:
                                                              TimerTextWidget())
                                                      : (widget.status ==
                                                              'On Hold')
                                                          ? Container(
                                                              child:
                                                                  TimerTextWidget())
                                                          : Container()
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ])
                              ]))
                        ])),
                    SizedBox(
                      height: 12,
                    ),
                    (complete == 'yes')
                        ? Column(children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 40),
                              height: 30,
                              child: Text(
                                'Add Comments',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin:
                                  const EdgeInsets.only(left: 40, right: 40),
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(220, 242, 255, 0.3),
                                  border: Border.all(
                                      width: 0.1, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5)),
                              child: SingleChildScrollView(child: commentField),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin:
                                  const EdgeInsets.only(left: 40, right: 40),
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 0.2, color: Colors.blue)),
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  for (var name in attachedMedia)
                                    Container(
                                      height: 20,
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(left: 20, top: 6),
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blue),
                                      ),
                                    )
                                ],
                              )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   comment.text = '';
                                    // });

                                    pickImage();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 120,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Add Media',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1, color: Colors.blue)),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    completeWork();
                                    completeWorkComment();
                                    setState(() {
                                      complete = 'held';
                                    });

                                    getComments();
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 120,
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 122, 255, 1),
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ],
                            )
                          ])
                        : (hold == 'yes')
                            ? Column(children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(left: 40),
                                  height: 30,
                                  child: Text(
                                    'Add Comments',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(220, 242, 255, 0.3),
                                      border: Border.all(
                                          width: 0.1, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: SingleChildScrollView(
                                      child: commentField),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 0.2, color: Colors.blue)),
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      for (var name in attachedMedia)
                                        Container(
                                          height: 20,
                                          alignment: Alignment.centerLeft,
                                          margin:
                                              EdgeInsets.only(left: 20, top: 6),
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blue),
                                          ),
                                        )
                                    ],
                                  )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // setState(() {
                                        //   comment.text = '';
                                        // });

                                        pickImage();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 120,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Add Media',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1, color: Colors.blue)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        pauseWorkComment();
                                        setState(() {
                                          hold = 'held';
                                        });
                                        pauseWork();
                                        getComments();
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 120,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Confirm',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(0, 122, 255, 1),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  ],
                                )
                              ])
                            : Column(children: [
                                (widget.status == 'Completed')
                                    ? Container()
                                    : (widget.status == 'In Progress')
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              PauseButton(),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // completeWork();
                                                  // completeWorkComment();
                                                  // _setTimer.stopStopwatch();

                                                  setState(() {
                                                    complete = 'yes';
                                                  });
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Complete',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          0, 122, 255, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    visible = true;
                                                  });
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'View Media',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          33, 140, 192, 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Container(
                                                height: 30,
                                                width: 100,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Navigate',
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        33, 140, 192, 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              StartButton()
                                            ],
                                          ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 193,
                                  width: 315,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 152,
                                              height: 16.5,
                                              margin: const EdgeInsets.only(
                                                  bottom: 11),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'Assignee',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                height: 16.5,
                                                margin: const EdgeInsets.only(
                                                    bottom: 11),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.company,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 152,
                                              height: 16.5,
                                              margin: const EdgeInsets.only(
                                                  bottom: 11),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'Project',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                height: 16.5,
                                                margin: const EdgeInsets.only(
                                                    bottom: 11),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.project,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 152,
                                              height: 16.5,
                                              margin: const EdgeInsets.only(
                                                  bottom: 11),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'Asset Name',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                height: 16.5,
                                                margin: const EdgeInsets.only(
                                                    bottom: 11),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.asset,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 152,
                                              height: 16.5,
                                              margin: const EdgeInsets.only(
                                                  bottom: 11),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'Asset Id',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                height: 16.5,
                                                margin: const EdgeInsets.only(
                                                    bottom: 11),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.assetId,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 152,
                                              height: 16.5,
                                              margin: const EdgeInsets.only(
                                                  bottom: 11),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'Asset Design Ref',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                height: 16.5,
                                                margin: const EdgeInsets.only(
                                                    bottom: 11),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.assetDesignRef,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 152,
                                              height: 16.5,
                                              margin: const EdgeInsets.only(
                                                  bottom: 11),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'Last Maintained',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                height: 16.5,
                                                margin: const EdgeInsets.only(
                                                    bottom: 11),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.lastMaintained,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 152,
                                              height: 16.5,
                                              margin: const EdgeInsets.only(
                                                  bottom: 11),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'Maintenance Date',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                height: 16.5,
                                                margin: const EdgeInsets.only(
                                                    bottom: 11),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  widget.date,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text('Work Order Comments',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic)),
                                ),
                                Column(
                                  children: [
                                    for (var doc in comments)
                                      CommentBox(
                                        id: widget.id,
                                        commentId: doc.id,
                                      ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ])
                  ])))),
          Visibility(
              visible: visible,
              child: Scaffold(
                body: Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  visible = false;

                                  videosTab = Color.fromRGBO(55, 56, 59, 0.3);
                                  imagesTab = Color.fromRGBO(0, 122, 255, 1);

                                  imageWeight = FontWeight.w600;
                                  videoWeight = FontWeight.w500;

                                  imageCon = Colors.white;
                                  videoCon = Colors.transparent;

                                  index = 0;
                                  tabClicked = 'images';
                                  _controller!.dispose();

                                  leftClick = Colors.black45;

                                  if ((index + 1) == imageUrls.length) {
                                    rightClick = Colors.black45;
                                  } else {
                                    rightClick = Colors.orange;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text("View Media",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        if (tabClicked == 'videos') {
                          if ((index + 1) == videoUrls.length) {
                            setState(
                              () {
                                rightClick = Colors.black45;
                              },
                            );
                          }
                        }
                        return Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(top: 30),
                                height: 44,
                                width: 316,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(226, 240, 255, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            videosTab =
                                                Color.fromRGBO(55, 56, 59, 0.3);
                                            imagesTab =
                                                Color.fromRGBO(0, 122, 255, 1);

                                            imageWeight = FontWeight.w600;
                                            videoWeight = FontWeight.w500;

                                            imageCon = Colors.white;
                                            videoCon = Colors.transparent;

                                            tabClicked = 'images';

                                            _controller!.dispose();

                                            index = 0;

                                            leftClick = Colors.black45;

                                            if ((index + 1) ==
                                                imageUrls.length) {
                                              rightClick = Colors.black45;
                                            } else {
                                              rightClick = Colors.orange;
                                            }
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 150,
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: imageCon,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Images',
                                          style: TextStyle(
                                            color: imagesTab,
                                            fontWeight: imageWeight,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(
                                          () {
                                            imagesTab =
                                                Color.fromRGBO(55, 56, 59, 0.3);
                                            videosTab =
                                                Color.fromRGBO(0, 122, 255, 1);

                                            imageWeight = FontWeight.w500;
                                            videoWeight = FontWeight.w600;

                                            imageCon = Colors.transparent;
                                            videoCon = Colors.white;

                                            tabClicked = 'videos';

                                            index = 0;

                                            leftClick = Colors.black45;

                                            if ((index + 1) ==
                                                videoUrls.length) {
                                              rightClick = Colors.black45;
                                            } else {
                                              rightClick = Colors.orange;
                                            }
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 150,
                                        margin: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: videoCon,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Videos',
                                          style: TextStyle(
                                            color: videosTab,
                                            fontWeight: videoWeight,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () {
                                          // handle tap event
                                          if (index > 0) {
                                            setState(
                                              () {
                                                index = index - 1;
                                                if (tabClicked == 'images') {
                                                  if ((index + 1) ==
                                                      imageUrls.length) {
                                                    rightClick = Colors.black45;
                                                  } else {
                                                    rightClick = Colors.orange;
                                                  }
                                                } else {
                                                  if ((index + 1) ==
                                                      videoUrls.length) {
                                                    rightClick = Colors.black45;
                                                  } else {
                                                    rightClick = Colors.orange;
                                                  }
                                                }
                                                if (index > 0) {
                                                  leftClick = Colors.orange;
                                                } else {
                                                  leftClick = Colors.black45;
                                                }
                                              },
                                            );
                                          }
                                        },
                                        child: Container(
                                          // padding: EdgeInsets.only(top: 12),
                                          alignment: Alignment.center,
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: leftClick,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Icon(
                                            Icons.keyboard_arrow_left,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 270,
                                      width: 240,
                                      padding: const EdgeInsets.all(15),
                                      child: (tabClicked == 'images')
                                          ? (imageUrls.length == 0)
                                              ? Image.asset(
                                                  'assets/images/omlogo.png',
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.network(
                                                  imageUrls[index],
                                                  height: 270,
                                                  width: 240,
                                                  fit: BoxFit.contain,
                                                )
                                          : StatefulBuilder(
                                              builder: (context, setState) {
                                              _controller =
                                                  VideoPlayerController.network(
                                                      videoUrls[index]);
                                              _controller!.pause();
                                              _controller!.setLooping(false);
                                              _controller!.setVolume(0.5);
                                              _initializeVideoPlayerFuture =
                                                  _controller!.initialize();
                                              return FutureBuilder(
                                                future:
                                                    _initializeVideoPlayerFuture,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    // _controller!.initialize();
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          // If the video is playing, pause it.
                                                          // if (_controller!.value.isPlaying) {
                                                          //   _controller!.pause();
                                                          // } else {
                                                          //   // If the video is paused, play it.
                                                          //   _controller!.play();
                                                          // }
                                                        });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: _controller!
                                                                      .value
                                                                      .isInitialized
                                                                  ? ClipRRect(
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .fitHeight,
                                                                        child: Container(
                                                                            width:
                                                                                600,
                                                                            height:
                                                                                360,
                                                                            child:
                                                                                VideoPlayer(_controller!)),
                                                                      ),
                                                                    )
                                                                  : SizedBox()),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height:
                                                                double.infinity,
                                                            child: StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              return GestureDetector(
                                                                  onTap: () {
                                                                    if (_controller!
                                                                        .value
                                                                        .isPlaying) {
                                                                      _controller!
                                                                          .pause();
                                                                      setState(
                                                                          () {
                                                                        play =
                                                                            'no';
                                                                      });
                                                                    } else {
                                                                      // If the video is paused, play it.
                                                                      _controller!
                                                                          .play();
                                                                      setState(
                                                                          () {
                                                                        play =
                                                                            'yes';
                                                                      });
                                                                    }
                                                                  },
                                                                  child: _controller!
                                                                          .value
                                                                          .isPlaying
                                                                      ? const Icon(
                                                                          Icons
                                                                              .pause,
                                                                          color:
                                                                              Colors.transparent,
                                                                          size:
                                                                              50,
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .play_arrow,
                                                                          color:
                                                                              Colors.orange,
                                                                          size:
                                                                              50,
                                                                        ));
                                                            }),
                                                            // height: 168,
                                                            width: 280,
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    // return AspectRatio(
                                                    //   aspectRatio: _controller!.value.aspectRatio,
                                                    //   child: VideoPlayer(_controller!),
                                                    // );
                                                  } else {
                                                    return Container(
                                                      height: 300,
                                                      width: 400,
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          const CircularProgressIndicator(
                                                        color: Colors.orange,
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            })),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          // handle tap event
                                          if (tabClicked == 'images') {
                                            if ((index + 1) <
                                                imageUrls.length) {
                                              setState(
                                                () {
                                                  index += 1;
                                                  if ((index + 1) ==
                                                      imageUrls.length) {
                                                    rightClick = Colors.black45;
                                                  } else {
                                                    rightClick = Colors.orange;
                                                  }
                                                  if (index > 0) {
                                                    leftClick = Colors.orange;
                                                  }
                                                },
                                              );
                                            }
                                          } else {
                                            if (index < videoUrls.length) {
                                              setState(
                                                () {
                                                  index += 1;
                                                },
                                              );
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: rightClick,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      })
                    ],
                  ),
                ),
              ))
        ]));
  }

  Color forward = Color.fromRGBO(198, 201, 204, 1);
  Color back = Color.fromRGBO(198, 201, 204, 1);

  VideoPlayerController? _controller;
  Chewie? _chewie;
  ChewieController? _chewieController;
  Future<void>? _initializeVideoPlayerFuture;
  Future<void>? _initializeVideoPlayer;

  String play = 'no';

  Future<void> initVideoPlayer() async {
    _controller = VideoPlayerController.network(videoUrls[index]);
    _controller!.pause();
    _controller!.setLooping(false);
    _controller!.setVolume(0.5);
    _initializeVideoPlayerFuture = _controller!.initialize();
    setState(() {
      print('=========================================================');
      print(_controller!.value.aspectRatio);
      _chewieController = ChewieController(
          videoPlayerController: _controller!,
          aspectRatio: _controller!.value.aspectRatio,
          autoPlay: false,
          looping: false,
          autoInitialize: true);
    });
  }

  Color tab1 = Colors.white;
  Color tab2 = Color.fromRGBO(226, 240, 255, 1);
  Color tapped = Color.fromRGBO(0, 122, 255, 1);
  Color tap = Color.fromRGBO(42, 46, 49, 0.4);

  List<String> images = [];
  List<String> videos = [];

  TextEditingController viewImg = TextEditingController(text: '');

  Future<void> getMedia() async {
    List<String> temp = [];

    images.clear();

    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(widget.id)
        .collection('images')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        String obj = doc.id;

        temp.add(obj);
      }

      images.addAll(temp);
      print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,>>>>>>>>>');
      print(images.length.toString());

      for (var url in images) {
        getImage(url);
      }

      if ((index + 1) == imageUrls.length) {
        setState(() {
          rightClick == Colors.black45;
        });
      }
    });
  }

  Future<void> getVideos() async {
    List<String> tempVideo = [];

    videos.clear();

    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(widget.id)
        .collection('videos')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        String obj = doc.id;

        tempVideo.add(obj);
      }

      videos.addAll(tempVideo);
      print(
          ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,>>>>>>>>>:::::');
      print(videos.length.toString());

      for (var url in videos) {
        getVideo(url);
      }
    });
  }

  void getUrls() {
    for (var url in images) {
      getImage(url);
    }

    for (var url in videos) {
      getVideo(url);
    }
  }

  Future<void> getImage(String imageId) async {
    String woId = widget.id;
    print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
    print(woId);
    final ref = FirebaseStorage.instance
        .ref()
        .child('new_work_orders/$woId/images/$imageId');
    await ref.getDownloadURL().then((value) {
      imageUrls.add(value);
      print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
      print(imageUrls.length);
    });
  }

  Future<void> getVideo(String imageId) async {
    String woId = widget.id;
    final ref = FirebaseStorage.instance
        .ref()
        .child('new_work_orders/$woId/videos/$imageId');
    await ref.getDownloadURL().then((value) {
      videoUrls.add(value);
      print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,:::::::::');
      print(videoUrls.length);
    });
  }

  int index = 0;

  void backPress() {
    // _initializeVideoPlayer = _controller!.initialize();
  }

  String imageId = '1';
  String type = 'images';

  void forwardPress() {
    // _initializeVideoPlayer = _controller!.initialize();
  }

  Widget getConChild() {
    if (type == 'images') {
      if (newUrl == '') {
        newUrl = widget.imgUrl;
      }
      return Image.network(
        newUrl,
        height: double.infinity,
        width: double.infinity,
      );
    } else {
      // _initializeVideoPlayerFuture = _controller!.initialize();
      // initVideoPlayer();
      _controller = VideoPlayerController.network(newUrl);
      _controller!.pause();
      _controller!.setLooping(false);
      _controller!.setVolume(0.5);
      _initializeVideoPlayerFuture = _controller!.initialize();

      return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // _controller!.initialize();
            return GestureDetector(
              onTap: () {
                setState(() {
                  // If the video is playing, pause it.
                  // if (_controller!.value.isPlaying) {
                  //   _controller!.pause();
                  // } else {
                  //   // If the video is paused, play it.
                  //   _controller!.play();
                  // }
                });
              },
              child: Stack(
                children: [
                  Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: _controller!.value.isInitialized
                          ? ClipRRect(
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Container(
                                    width: 600,
                                    height: 360,
                                    child: VideoPlayer(_controller!)),
                              ),
                            )
                          : SizedBox()),
                  Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    child: StatefulBuilder(builder: (context, setState) {
                      return GestureDetector(
                          onTap: () {
                            if (_controller!.value.isPlaying) {
                              _controller!.pause();
                              setState(() {
                                play = 'no';
                              });
                            } else {
                              // If the video is paused, play it.
                              _controller!.play();
                              setState(() {
                                play = 'yes';
                              });
                            }
                          },
                          child: _controller!.value.isPlaying
                              ? const Icon(
                                  Icons.pause,
                                  color: Colors.transparent,
                                  size: 50,
                                )
                              : const Icon(
                                  Icons.play_arrow,
                                  color: Colors.orange,
                                  size: 50,
                                ));
                    }),
                    // height: 168,
                    width: 280,
                  ),
                ],
              ),
            );

            // return AspectRatio(
            //   aspectRatio: _controller!.value.aspectRatio,
            //   child: VideoPlayer(_controller!),
            // );
          } else {
            return Container(
              height: 300,
              width: 400,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }
        },
      );
    }
  }

  List<DocumentSnapshot> comments = [];

  String commentId = '0';

  Widget getHolder() {
    if (widget.imgUrl == '') {
      return GestureDetector(
        onTap: (() {
          pickImage();
        }),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child: SvgPicture.asset(
            'assets/images/image 3.svg',
            height: 86,
            width: 86,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: (() {
          pickImage();
        }),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            widget.imgUrl,
            height: 86,
            width: 86,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}

class CommentBox extends StatefulWidget {
  CommentBox({Key? key, required this.id, required this.commentId})
      : super(key: key);

  String id;
  String commentId;

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttachments();
  }

  DocumentSnapshot? comment;

  void getComment() async {
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(widget.commentId)
        .get()
        .then((value) {
      setState(() {
        comment = value;
      });
    });
  }

  String getCaption(String user_task) {
    if (user_task == 'creator') {
      return 'Created work order';
    } else if (user_task == 'start') {
      return 'Started work order';
    } else if (user_task == 'pause') {
      return 'Paused work order';
    } else if (user_task == 'complete') {
      return 'Completed work order';
    } else if (user_task == 'submit') {
      return 'Submitted order';
    } else if (user_task == 'approve') {
      return 'Approved work order';
    } else {
      return '';
    }
  }

  List<DocumentSnapshot> attachedFiles = [];

  void getAttachments() async {
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(widget.commentId)
        .collection('attached')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        attachedFiles.add(doc);
      }
    });
  }

  void getPerm(String name) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      downloadFileExample(name);
    }
  }

  Future<void> downloadFileExample(String name) async {
    String id = widget.id;
    String commentId = widget.commentId;
    //First you get the documents folder location on the device...
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    //Here you'll specify the file it should be saved as
    // File downloadToFile = File('${appDocDir.path}/$name');
    //Here you'll specify the file it should download from Cloud Storage
    String fileToDownload = 'work_order_held/$id/$commentId/$name';

    //Now you can try to download the specified file, and write it to the downloadToFile.
    // try {
    //   await FirebaseStorage.instance
    //       .ref(fileToDownload)
    //       .writeToFile(downloadToFile);
    // } on FirebaseException catch (e) {
    //   // e.g, e.code == 'canceled'
    //   print('Download error:');
    // }

    final instructionUrl =
        await FirebaseStorage.instance.ref(fileToDownload).getDownloadURL();

    var dir = await getExternalStorageDirectory();
    if (dir != null) {
      final taskId = await down.FlutterDownloader.enqueue(
        url: instructionUrl,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: dir.path,
        fileName: 'OMT/$id/$commentId/$name',
        showNotification:
            true, // show download progress in status bar (for Android)
        saveInPublicStorage: true,
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> downloadDocExample(String name) async {
    String id = widget.id;
    String commentId = widget.id;
    //First you get the documents folder location on the device...
    Directory appDocDir = await getApplicationDocumentsDirectory();
    //Here you'll specify the file it should be saved as
    File downloadToFile = File('${appDocDir.path}/$name');
    //Here you'll specify the file it should download from Cloud Storage
    String fileToDownload = 'work_order_held/$id/$commentId/$name';

    //Now you can try to download the specified file, and write it to the downloadToFile.
    try {
      await FirebaseStorage.instance
          .ref(fileToDownload)
          .writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print('Download error:');
    }

    final instructionUrl =
        await FirebaseStorage.instance.ref(fileToDownload).getDownloadURL();

    var dir = await getExternalStorageDirectory();
    if (dir != null) {
      final taskId = await down.FlutterDownloader.enqueue(
        url: instructionUrl,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: dir.path,
        /*fileName:"uniquename",*/
        showNotification:
            true, // show download progress in status bar (for Android)
        saveInPublicStorage: true,
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> downloadFileAndShowProgress(String fileUrl) async {
    String id = widget.id;
    String commentId = widget.commentId;
    final String fileName = fileUrl.split('/').last;
    final Reference reference =
        FirebaseStorage.instance.ref('work_order_held/$id/$commentId/$fileUrl');
    final String savePath =
        await getFilePath('work_order_held/$id/$commentId/$fileUrl');

    print('+++++++++++++++++++     +++++++++++++++++++++++++     $savePath');

    final DownloadTask downloadTask = reference.writeToFile(File(savePath));

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id', 'channel name', 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/launcher_icon",

      // smallIcon: 'assets/images/omlogo.png',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    downloadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final double progress =
          snapshot.bytesTransferred / snapshot.totalBytes * 100;
      if (snapshot.state == TaskState.running) {
        flutterLocalNotificationsPlugin.show(
          0,
          'Downloading $fileName',
          '${progress.toStringAsFixed(2)}%',
          platformChannelSpecifics,
          payload: 'item x',
        );
      }
    }, onError: (Object e) {
      print('Error downloading file: $e');
    });

    await downloadTask.whenComplete(() async {
      flutterLocalNotificationsPlugin.cancel(0);
      flutterLocalNotificationsPlugin.show(
        0,
        'Download complete',
        '$fileName downloaded to $savePath',
        platformChannelSpecifics,
        payload: 'item x',
      );
    });
  }

  Future<String> getFilePath(String fileName) async {
    final Directory? directory = await getExternalStorageDirectory();
    return '${directory!.path}/Documents';
  }

  @override
  Widget build(BuildContext context) {
    getComment();
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Container(
                height: 18,
                width: 55,
                alignment: Alignment.center,
                child: Text(
                  comment!.get('user_type'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w400),
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(77, 92, 125, 1),
                    borderRadius: BorderRadius.circular(9)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                comment!.get('user'),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Container(
                width: 180,
                alignment: Alignment.centerLeft,
                child: Text(
                  getCaption(comment!.get('user_task')),
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                comment!.get('date'),
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(74, 86, 110, 1),
                    fontSize: 8,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Column(
                children: [
                  Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      comment!.get('comment'),
                      style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  for (var doc in attachedFiles)
                    InkWell(
                      onTap: () {
                        downloadFileAndShowProgress(doc.get('name'));
                      },
                      child: Container(
                        width: 250,
                        height: 20,
                        margin: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          doc.get('name'),
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
