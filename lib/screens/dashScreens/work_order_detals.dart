import 'dart:ffi';

import 'package:OMTECH/screens/dashScreens/client_home.dart';
import 'package:OMTECH/screens/author_screens/preventive.dart';
import 'package:OMTECH/screens/author_screens/reactive.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../authentication/login.dart';

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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ReactiveM()));
        },
        child: Container(
            width: 60,
            alignment: Alignment.bottomLeft,
            child: const Icon(Icons.arrow_back)));
  }
}

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

  String name;
  String status;
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

class _WorkOrderDetailsState extends State<WorkOrderDetails> {
  bool visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage(imageId);
    getMedia();
    getImg();
    getVideos();
    getComments();
  }

  Future<void> approveWork() async {
    String dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .update({'last_maintained': dateNow, 'status': 'Approved'}).then(
            (value) {
      setState(() {
        // widget.status = 'Complete';
      });
    });
  }

  TextEditingController comment = TextEditingController(text: '');

  Future<void> approveWorkComment() async {
    String dateNow = DateFormat("dd/MM/yyyy hh:mm").format(DateTime.now());
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .doc(comments.length.toString())
        .set({
      'user_task': 'approve',
      'comment': comment.text,
      'user': username,
      'user_type': 'client',
      'date': dateNow,
      'caption': dateNow
    });
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

  @override
  Widget build(BuildContext context) {
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
                              GestureDetector(
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
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              width: double.infinity,
                              child: Row(children: [
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
                                Column(children: [
                                  (widget.status == 'Submitted')
                                      ? Container()
                                      : Container(
                                          height: 70,
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
                                                      BorderRadius.circular(8)),
                                            ),
                                          ),
                                        ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 70,
                                    width: 170,
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
                                      ],
                                    ),
                                  ),
                                ])
                              ]))
                        ])),
                    SizedBox(
                      height: 12,
                    ),
                    (widget.status == 'Submitted')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 174, 0, 1),
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  approveWork();
                                  approveWorkComment();
                                  getComments();
                                  setState(() {});
                                },
                                child: Container(
                                  height: 30,
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Approve',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 122, 255, 1),
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              )
                            ],
                          )
                        : Container(),
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
                                  margin: const EdgeInsets.only(bottom: 11),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Assignee',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    height: 16.5,
                                    margin: const EdgeInsets.only(bottom: 11),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.company,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 152,
                                  height: 16.5,
                                  margin: const EdgeInsets.only(bottom: 11),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Project',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    height: 16.5,
                                    margin: const EdgeInsets.only(bottom: 11),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.project,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 152,
                                  height: 16.5,
                                  margin: const EdgeInsets.only(bottom: 11),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Asset Name',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    height: 16.5,
                                    margin: const EdgeInsets.only(bottom: 11),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.asset,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 152,
                                  height: 16.5,
                                  margin: const EdgeInsets.only(bottom: 11),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Asset Id',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    height: 16.5,
                                    margin: const EdgeInsets.only(bottom: 11),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.assetId,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 152,
                                  height: 16.5,
                                  margin: const EdgeInsets.only(bottom: 11),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Asset Design Ref',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    height: 16.5,
                                    margin: const EdgeInsets.only(bottom: 11),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.assetDesignRef,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 152,
                                  height: 16.5,
                                  margin: const EdgeInsets.only(bottom: 11),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Last Maintained',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    height: 16.5,
                                    margin: const EdgeInsets.only(bottom: 11),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.lastMaintained,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 152,
                                  height: 16.5,
                                  margin: const EdgeInsets.only(bottom: 11),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Maintenance Date',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                    width: double.infinity,
                                    height: 16.5,
                                    margin: const EdgeInsets.only(bottom: 11),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.date,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
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

    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(widget.id)
        .collection('attachments')
        .where('type', isEqualTo: 'image')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        String obj = doc.id;

        temp.add(obj);
      }
      setState(() {
        images.clear();
        images.addAll(temp);
        print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,>>>>>>>>>');
        print(images.length.toString());
      });

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

    await FirebaseFirestore.instance
        .collection('n_w_o_images')
        .doc(widget.id)
        .collection('attachments')
        .where('type', isEqualTo: 'video')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        String obj = doc.id;

        tempVideo.add(obj);
      }
      setState(() {
        videos.clear();
        videos.addAll(tempVideo);
        print(
            ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,>>>>>>>>>:::::');
        print(videos.length.toString());
      });

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
    final ref =
        FirebaseStorage.instance.ref().child('new_work_orders/$woId/$imageId');
    await ref.getDownloadURL().then((value) {
      imageUrls.add(value);
      print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
      print(imageUrls.length);
    });
  }

  Future<void> getVideo(String imageId) async {
    String woId = widget.id;
    final ref =
        FirebaseStorage.instance.ref().child('new_work_orders/$woId/$imageId');
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

  void getComments() async {
    comments.clear();
    await FirebaseFirestore.instance
        .collection('new_work_orders')
        .doc(widget.id)
        .collection('comments')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        comments.add(doc);
      }
    });
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
    } else if (user_task == 'starter') {
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
                comment!.get('caption'),
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
                    Container(
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