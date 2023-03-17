import 'package:OMTECH/tools/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:OMTECH/screens/dashScreens/home.dart';
import 'package:OMTECH/screens/dashScreens/profile.dart';
import 'package:OMTECH/screens/dashScreens/projects.dart';

Widget _currentPage = MyWidget();

final pages = <String, WidgetBuilder>{
  'home': (context) => const MyWidget(),
  'projects': (context) => const Assigned(),
  'profile': (context) => const Profile(),
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

class ClientDash extends ConsumerStatefulWidget {
  ClientDash({Key? key, this.from}) : super(key: key);
  String? from;
  @override
  ConsumerState<ClientDash> createState() => _ClientDashState(from: from);
}

class _ClientDashState extends ConsumerState<ClientDash> {
  _ClientDashState({this.from});
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.only(top: 400),
                    child: BottomNav()),
              ),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: InkWell(
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
          width: double.infinity,
          height: 65,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 65,
                width: 0.75,
                color: const Color.fromRGBO(46, 55, 73, 1),
              ),
              SvgPicture.asset(
                'assets/images/Path 1.svg',
                width: 375,
                height: 65,
              ),
              Container(
                height: 65,
                width: 0.75,
                color: const Color.fromRGBO(46, 55, 73, 1),
              ),
            ],
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final content = ref.watch(selectedNavPageBuilderProvider);
    return Scaffold(
      body: content(context),
    );
  }
}
