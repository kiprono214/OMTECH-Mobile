import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dots.dart';
import 'dart:async';
import '../authentication/login.dart';

class JumpingDots extends StatefulWidget {
  final int numberOfDots;

  const JumpingDots({Key? key, this.numberOfDots = 12}) : super(key: key);

  @override
  _JumpingDotsState createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State<JumpingDots>
    with TickerProviderStateMixin {
  List<AnimationController> _animationControllers = [];

  List<Animation<double>> _animations = [];

  int animationDuration = 200;

  Timer scheduleTimeout([int milliseconds = 5000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);
  void handleTimeout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
    // Do some work.
  }
  // _SplashState(){
  //    _timer = new Timer(const Duration(milliseconds: 800), () {
  //       setState(() {

  //       });
  //       _timer = new Timer(const Duration(seconds: 1), () {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) =>Login()));
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _initAnimation();
    scheduleTimeout(5000);
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          decoration: BoxDecoration(
              color: const Color.fromRGBO(46, 59, 73, 1),
              borderRadius: BorderRadius.circular(0)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  'assets/images/Pattern.svg',
                  height: 112,
                  width: 180,
                ),
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 250,
                    ),
                    const Image(
                      image: AssetImage('assets/images/omlogo.png'),
                      height: 81,
                      width: 170,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      ' OMTECH',
                      style: TextStyle(
                          color: Colors.white70,
                          letterSpacing: 0.25,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 220,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.numberOfDots, (index) {
                        //AnimatedBuilder widget will rebuild it self when
                        //_animationControllers[index] value changes.
                        return AnimatedBuilder(
                          animation: _animationControllers[index],
                          builder: (context, child) {
                            return Container(
                              padding: EdgeInsets.all(1.2),
                              //Transform widget's translate constructor will help us to move the dot
                              //in upward direction by changing the offset of the dot.
                              //X-axis position of dot will not change.
                              //Only Y-axis position will change.
                              child: Transform.translate(
                                offset: Offset(0, _animations[index].value),
                                child: DotWidget(),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void _initAnimation() {
    ///initialization of _animationControllers
    ///each _animationController will have same animation duration
    _animationControllers = List.generate(
      widget.numberOfDots,
      (index) {
        return AnimationController(
            vsync: this, duration: Duration(milliseconds: animationDuration));
      },
    ).toList();

    ///initialization of _animations
    ///here end value is -20
    ///end value is amount of jump.
    ///and we want our dot to jump in upward direction
    for (int i = 0; i < widget.numberOfDots; i++) {
      _animations.add(
          Tween<double>(begin: 0, end: -20).animate(_animationControllers[i]));
    }

    for (int i = 0; i < widget.numberOfDots; i++) {
      _animationControllers[i].addStatusListener((status) {
        //On Complete
        if (status == AnimationStatus.completed) {
          //return of original postion
          _animationControllers[i].reverse();
          //if it is not last dot then start the animation of next dot.
          if (i != widget.numberOfDots - 1) {
            _animationControllers[i + 1].forward();
          }
        }
        //if last dot is back to its original postion then start animation of the first dot.
        // now this animation will be repeated infinitely
        if (i == widget.numberOfDots - 1 &&
            status == AnimationStatus.dismissed) {
          _animationControllers[0].forward();
        }
      });
    }

    //trigger animtion of first dot to start the whole animation.
    _animationControllers.first.forward();
  }
}
