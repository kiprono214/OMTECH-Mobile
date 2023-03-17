import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier(),
);

class TimerTextWidget extends HookConsumerWidget {
  const TimerTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeLeft = ref.watch(timerProvider).timeLeft;
    print('building TimerTextWidget $timeLeft');
    return Text(
      timeLeft,
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class ButtonsContainer extends StatelessWidget {
  const ButtonsContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PauseButton(),
        SizedBox(width: 20),
        ResetButton(),
      ],
    );
  }
}

TextEditingController commentWidget = TextEditingController(text: '');

class StartButton extends HookConsumerWidget {
  const StartButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        // startWork();
        // startWorkComment();
        // // _setTimer.startStopwatch();
        // getComments();
        // setState(() {});

        ref.read(timerProvider.notifier).start();
        commentWidget.text = 'started';
      },
      child: Container(
        height: 30,
        width: 100,
        alignment: Alignment.center,
        child: Text(
          'Start',
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 122, 255, 1),
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class PauseButton extends HookConsumerWidget {
  const PauseButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(timerProvider.notifier).pause();
        commentWidget.text = 'paused';
        // setState(() {
        //   hold = 'yes';
        // });
        // attachedMedia.clear();
        // // _setTimer.stopStopwatch();
      },
      child: Container(
        height: 30,
        width: 100,
        alignment: Alignment.center,
        child: Text(
          'Hold',
          style: TextStyle(
              color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 2, color: Colors.blue)),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.replay),
    );
  }
}

class TimerModel {
  const TimerModel(this.timeLeft, this.buttonState);
  final String timeLeft;
  final ButtonState buttonState;
}

enum ButtonState {
  initial,
  started,
  paused,
  finished,
}

class TimerNotifier extends StateNotifier<TimerModel> {
  TimerNotifier() : super(_initialState);

  static const int _initialDuration = 0;
  static final _initialState = TimerModel(
    _durationString(_initialDuration),
    ButtonState.initial,
  );

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  static String _durationString(int duration) {
    final hours = ((duration / 3600) % 24).floor().toString().padLeft(2, '0');
    final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final seconds = (duration % 60).floor().toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void start() {
    if (state.buttonState == ButtonState.paused) {
      _restartTimer();
    } else {
      _startTimer();
    }
  }

  void _restartTimer() {
    _tickerSubscription?.resume();
    state = TimerModel(state.timeLeft, ButtonState.started);
  }

  void _startTimer() {
    _tickerSubscription?.cancel();

    _tickerSubscription = _ticker.tick(ticks: 0).listen((duration) {
      state = TimerModel(_durationString(duration), ButtonState.started);
    });

    _tickerSubscription?.onDone(() {
      state = TimerModel(state.timeLeft, ButtonState.finished);
    });

    state = TimerModel(_durationString(_initialDuration), ButtonState.started);
  }

  void pause() {
    _tickerSubscription?.pause();
    state = TimerModel(state.timeLeft, ButtonState.paused);
  }

  void reset() {
    _tickerSubscription?.cancel();
    state = _initialState;
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      Duration(seconds: 1),
      (x) => ticks + x + 1,
    );
  }
}




// StreamBuilder<int>(
//                                                       stream: _setTimr
//                                                           .stopWatchStream(),
//                                                       initialData: 0,
//                                                       builder: (context, snap) {
//                                                         final value = snap.data;
//                                                         // elapsedTime =
//                                                         //     StopWatchTimer
//                                                         //         .getDisplayTime(
//                                                         //             value!);
//                                                         final displayTime =
//                                                             StopWatchTimer
//                                                                 .getDisplayTime(
//                                                                     value!);
//                                                         return Column(
//                                                           children: <Widget>[
//                                                             Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(2),
//                                                               child: Text(
//                                                                 displayTime,
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         30,
//                                                                     fontFamily:
//                                                                         'Helvetica',
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                             ),
//                                                             // Padding(
//                                                             //   padding:
//                                                             //       const EdgeInsets
//                                                             //           .all(8),
//                                                             //   child: Text(
//                                                             //     value.toString(),
//                                                             //     style: TextStyle(
//                                                             //         fontSize: 40,
//                                                             //         fontFamily:
//                                                             //             'Helvetica',
//                                                             //         fontWeight:
//                                                             //             FontWeight
//                                                             //                 .w400),
//                                                             //   ),
//                                                             // ),
//                                                           ],
//                                                         );
//                                                       },
//                                                     // ),