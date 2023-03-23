import 'package:OMTECH/screens/company_screens/assets.dart';
import 'package:OMTECH/screens/company_screens/assigned.dart';
import 'package:OMTECH/screens/company_screens/create_asset.dart';
import 'package:OMTECH/screens/company_screens/workers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:OMTECH/screens/company_screens/profile.dart';
import 'package:OMTECH/screens/company_screens/home.dart';

Widget _currentPage = MyWidget();

String titleClick = '';

final pages = <String, WidgetBuilder>{
  'home': (context) => const MyWidget(),
  'workers': (context) => const Workers(),
  'profile': (context) => const Profile(),
  'projects': ((context) => const Assigned()),
  'assets': (context) => AssetsStream(title: titleClick),
  // 'create asset': (context) => CreateAsset(),
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

class CompanyHome extends ConsumerStatefulWidget {
  CompanyHome({Key? key, this.from}) : super(key: key);

  String? from;

  @override
  ConsumerState<CompanyHome> createState() => _CompanyHomeState(from: from);
}

class _CompanyHomeState extends ConsumerState<CompanyHome> {
  _CompanyHomeState({this.from});
  String? from;
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

  SvgPicture getWorkSvg(String selected) {
    if (selected == 'proj') {
      return SvgPicture.asset(
        'assets/images/Group 55609 (1).svg',
        height: 24,
        width: 24,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/Group 55609.svg',
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

  Color textColor(String select) {
    if (select == selected) {
      return const Color.fromRGBO(255, 174, 0, 1);
    } else {
      return Colors.white;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      _selectPage(context, ref, 'home');
                    },
                    child: Container(
                      height: 76,
                      width: 76,
                      margin: const EdgeInsets.only(bottom: 23),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(46, 55, 73, 1),
                          borderRadius: BorderRadius.circular(38)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getHomeSvg('home'),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('Home',
                              style: TextStyle(
                                  fontSize: 10, color: textColor('home')))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                  )
                ],
              )
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
  String visWork = '';
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

  SvgPicture getWorkSvg(String selected) {
    if (selected == 'workers') {
      return SvgPicture.asset(
        'assets/images/Group 55609 (1).svg',
        height: 24,
        width: 24,
      );
    } else {
      return SvgPicture.asset(
        'assets/images/Group 55609.svg',
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

  void setProjects() {
    setState(() {
      visWork = '';
      visProj = 'true';
      projSel = 'projects';
      selected = 'projects';
    });
  }

  void setWorkers() {
    setState(() {
      visProj = '';
      visWork = 'true';
      projSel = 'workers';
      selected = 'workers';
    });
  }

  SvgPicture getProjSvg(String selected) {
    if (selected == 'projects') {
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

  Color textColor(String select) {
    if (select == selected) {
      return const Color.fromRGBO(255, 174, 0, 1);
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(selectedNavPageNameProvider.state).state == 'projects') {
      setProjects();
    } else if (ref.watch(selectedNavPageNameProvider.state).state ==
        'workers') {
      setWorkers();
    } else {
      setState(() {
        visProj = '';
        visWork = '';
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
                  width: 35,
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: const Color.fromRGBO(46, 55, 76, 1),
                    height: 65,
                    width: 35,
                  ),
                ))
              ],
            )),
        Container(
          height: 65,
          width: double.infinity,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/images/Path 1.svg',
            width: double.infinity,
            height: 65,
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
                    setProjects();
                    _selectPage(context, ref, 'projects');
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
                          decoration: getVis(visProj),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setProjects();
                                  _selectPage(context, ref, 'projects');
                                },
                                child: Container(
                                    width: 33,
                                    height: 33,
                                    alignment: Alignment.center,
                                    child: getProjSvg(selected)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Projects',
                          style: TextStyle(
                              fontSize: 10, color: textColor('projects')),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setWorkers();
                    _selectPage(context, ref, 'workers');
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
                            setWorkers();
                            _selectPage(context, ref, 'workers');
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: getVis(visWork),
                            child: Stack(
                              children: [
                                Container(
                                    width: 33,
                                    height: 33,
                                    alignment: Alignment.center,
                                    child: getWorkSvg(projSel)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Workers',
                          style: TextStyle(
                              fontSize: 10, color: textColor('workers')),
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

  // Widget getPic() {
  //   if (imgUrl == '') {
  //     return SvgPicture.asset(
  //       'assets/images/image 3.svg',
  //       height: 100,
  //       width: 100,
  //       fit: BoxFit.cover,
  //     );
  //   } else {
  //     return Image.network(
  //       imgUrl,
  //       height: 100,
  //       width: 100,
  //       fit: BoxFit.cover,
  //     );
  //   }
  // }
}

class Content extends ConsumerWidget {
  Content({Key? key, this.from}) : super(key: key);

  String? from;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(selectedNavPageBuilderProvider);
    return Scaffold(
      body: content(context),
    );
  }
}
