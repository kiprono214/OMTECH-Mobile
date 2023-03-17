import 'package:OMTECH/screens/worker_screens/asset_details.dart';
import 'package:OMTECH/screens/worker_screens/asset_work_orders.dart';
import 'package:OMTECH/screens/worker_screens/assets.dart';
import 'package:OMTECH/screens/worker_screens/assigned.dart';
import 'package:OMTECH/screens/worker_screens/engineer_details.dart';
import 'package:OMTECH/tools/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:OMTECH/screens/worker_screens/profile copy.dart';
import 'package:OMTECH/screens/worker_screens/home.dart';
import 'assets.dart';
import 'create_asset.dart';

Widget _currentPage = MyWidget();

String titleClick = '';

// String _assetId = '';
// String _imgUrl = '';
// String _date = '';
// String _id = '';
// String _name = '';
// String _location = '';
// String _project = '';
// String _design = '';
// String _serial = '';
// String _model = '';
// String _status = '';
// String _system = '';
// String _subsystem = '';
// String _type = '';
// String _engineer = '';
// String _expectancy = '';
// String _details = '';

final pages = <String, WidgetBuilder>{
  'home': (context) => const MyWidget(),
  'projects': (context) => const Assigned(),
  'engineers': (context) => const Engineers(),
  'profile': (context) => const Profile(),
  'assets': (context) => AssetsStream(title: titleClick),
  // 'create asset': (context) => CreateAsset(),
  'scan': (context) => ScanScreen()
};

final selectedNavPageNameProvider = StateProvider<String>((ref) {
  // default value
  return pages.keys.first;
});

final selectedNavPageBuilderProvider = Provider<WidgetBuilder>((ref) {
  // watch for state changes inside selectedPageNameProvider
  final selectedPageKey = ref.watch(selectedNavPageNameProvider.state).state;
  // return the WidgetBuilder using the key as index
  return pages[selectedPageKey]!;
});

class WorkerHome extends ConsumerStatefulWidget {
  WorkerHome({Key? key, this.from}) : super(key: key);

  String? from;

  @override
  ConsumerState<WorkerHome> createState() => _WorkerHomeState(from: from);
}

class _WorkerHomeState extends ConsumerState<WorkerHome> {
  _WorkerHomeState({this.from});
  String? from;
  static String selected = 'home';
  static String visHome = 'true';
  static String visProj = '';
  static String projSel = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Color textColor(String select) {
      if (select == selected) {
        return const Color.fromRGBO(255, 174, 0, 1);
      } else {
        return Colors.white;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Content(
                from: from,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.only(top: 600),
                    child: BottomNav()),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      _selectPage(context, ref, 'scan');
                    },
                    child: Container(
                      height: 76,
                      width: 76,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 600, bottom: 24),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(46, 55, 73, 1),
                          borderRadius: BorderRadius.circular(38)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/scan.svg',
                            height: 26.67,
                            width: 26.67,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('Scan',
                              style: TextStyle(
                                  fontSize: 10, color: textColor('scan')))
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  String selected = 'home';
  String visHome = 'true';
  String visProj = '';
  String projSel = '';

  SvgPicture getHomeSvg(String selected) {
    if (selected == 'home') {
      return SvgPicture.asset(
        'assets/images/home (1).svg',
        height: 24,
        width: 24,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/home.svg',
        height: 24,
        width: 24,
      );
    }
  }

  SvgPicture getProjSvg(String selected) {
    if (selected == 'proj') {
      return SvgPicture.asset(
        'assets/images/office bag (1).svg',
        height: 24,
        width: 24,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/office bag.svg',
        height: 24,
        width: 24,
      );
    }
  }

  BoxDecoration getVis(String visible) {
    if (visible == 'true') {
      return BoxDecoration(
          color: const Color.fromRGBO(32, 29, 29, 1),
          borderRadius: BorderRadius.circular(20));
    } else {
      return const BoxDecoration(color: Colors.transparent);
    }
  }

  late List<Widget> _pages;

  late Widget _page1;

  late Widget _page2;

  late int _currentIndex;

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  void setHome() {
    setState(() {
      visHome = 'true';
      visProj = '';
      projSel = '';
      selected = 'home';
    });
  }

  void setProjects() {
    setState(() {
      visProj = 'true';
      visHome = '';
      projSel = 'proj';
      selected = 'proj';
    });
  }

  Color textColor(String select) {
    if (select == selected) {
      return const Color.fromRGBO(255, 174, 0, 1);
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(selectedNavPageNameProvider.state).state == 'home') {
      setHome();
    } else if (ref.watch(selectedNavPageNameProvider.state).state ==
        'projects') {
      setProjects();
    } else {
      setState(() {
        visProj = '';
        visHome = '';
        projSel = '';
        selected = '';
      });
    }
    return Stack(
      children: [
        Container(
            height: 65,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 1),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: const Color.fromRGBO(46, 55, 76, 1),
                  height: 65,
                  width: 70,
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: const Color.fromRGBO(46, 55, 76, 1),
                    height: 65,
                    width: 70,
                  ),
                ))
              ],
            )),
        Container(
          height: 65,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(
            'assets/images/Path 1.svg',
            width: double.infinity,
            height: 65,
            fit: BoxFit.fitHeight,
          ),
        ),
        Container(
            height: 65,
            width: double.infinity,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setHome();
                    _selectPage(context, ref, 'home');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 100),
                    alignment: Alignment.center,
                    height: 65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: getVis(visHome),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setHome();
                                  _selectPage(context, ref, 'home');
                                },
                                child: Container(
                                    width: 33,
                                    height: 33,
                                    alignment: Alignment.center,
                                    child: getHomeSvg(selected)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Home',
                          style:
                              TextStyle(fontSize: 10, color: textColor('home')),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setProjects();
                    _selectPage(context, ref, 'projects');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 100),
                    alignment: Alignment.center,
                    height: 65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setProjects();
                            _selectPage(context, ref, 'projects');
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: getVis(visProj),
                            child: Stack(
                              children: [
                                Container(
                                    width: 33,
                                    height: 33,
                                    alignment: Alignment.center,
                                    child: getProjSvg(projSel)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Projects',
                          style:
                              TextStyle(fontSize: 10, color: textColor('proj')),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}

class Content extends ConsumerWidget {
  Content({Key? key, this.from}) : super(key: key);

  String? from;

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  void checkFrom(BuildContext context, WidgetRef ref) {
    if (from != null) {
      if (from == 'login') {
        _selectPage(context, ref, 'home');
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(selectedNavPageBuilderProvider);
    return Scaffold(
      body: content(context),
    );
  }
}

class AssetDetailClick extends ConsumerStatefulWidget {
  AssetDetailClick(
      {required this.assetId,
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

  @override
  ConsumerState<AssetDetailClick> createState() => _AssetDetailClickState(
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

class _AssetDetailClickState extends ConsumerState<AssetDetailClick> {
  _AssetDetailClickState(
      {required this.assetId,
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

  void _selectPage(BuildContext context, WidgetRef ref, String pageName) {
    if (ref.read(selectedNavPageNameProvider.state).state != pageName) {
      ref.read(selectedNavPageNameProvider.state).state = pageName;
    }
  }

  String imgUrl = '';

  String assetId;

  Future<void> getImg() async {
    await FirebaseFirestore.instance
        .collection('images')
        .where('asset', isEqualTo: assetId)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        setState(() {
          imgUrl = doc.get('name');
          print(assetId);
        });
      }
    });
    final ref =
        await FirebaseStorage.instance.ref().child('asset_images/$imgUrl');
    // no need of the file extension, the name will do fine.
    String temp = await ref.getDownloadURL();
    setState(() {
      imgUrl = temp;
      print('????????????????????????????????????' + imgUrl);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImg();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AssetDetails(
                  assetId: assetId,
                  date: date,
                  id: id,
                  imgUrl: imgUrl,
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
          alignment: Alignment.centerLeft,
          height: 120,
          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.5),
              color: const Color.fromRGBO(0, 122, 255, 0.1)),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.all(0.25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), child: getPic()),
              ),
              Container(
                  height: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      height: 30,
                                      width: 48,
                                      alignment: Alignment.centerLeft,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: const Text("Title : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                          height: 30,
                                          width: 120,
                                          alignment: Alignment.centerLeft,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(name,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14)),
                                          )))
                                ]),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  height: 30,
                                  width: 46,
                                  alignment: Alignment.centerLeft,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: const Text("Type : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                      height: 30,
                                      width: 120,
                                      alignment: Alignment.centerLeft,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(type,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14)),
                                      )))
                            ]),
                          ),
                          Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Row(children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  height: 30,
                                  width: 48,
                                  alignment: Alignment.centerLeft,
                                  child: const Text("Room : ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  height: 30,
                                  width: 120,
                                  alignment: Alignment.centerLeft,
                                  child: Text(location,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14)))
                            ]),
                          ),
                        ]),
                  )),
            ],
          ),
        ));
  }

  Widget getPic() {
    if (imgUrl == '') {
      return SvgPicture.asset(
        'assets/images/image 3.svg',
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        imgUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    }
  }
}
