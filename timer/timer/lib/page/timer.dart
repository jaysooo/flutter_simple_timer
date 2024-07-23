import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

class TimerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerPageState();
  }
}

class _TimerPageState extends State<TimerPage> {
  Duration duration = Duration();
  bool isCountdown = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // startTimer();
    //reset();
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    // timer 객체에 addTime()을 통해 리턴 된 duration 을 할당
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  void reset() {
    setState(() => duration = Duration(minutes: 25));
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(
            seconds: seconds); // Duration 객체를 갱신된 초로 생성후 duration 변수에 할당
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: buildTime()),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTimeCard(time: hours, header: 'HOUR'),
            const SizedBox(width: 8),
            buildTimeCard(time: minutes, header: 'MINUTES'),
            const SizedBox(width: 8),
            buildTimeCard(time: seconds, header: 'SECONDS'),
            const SizedBox(width: 8)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const SizedBox(height: 50), buildButton()],
        )
      ],
    );
  }

  Widget buildButton() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isComplted = duration.inSeconds == 0;

    return isRunning || !isComplted
        ? Row(children: [
            ElevatedButton(
                onPressed: () {
                  if (isRunning) {
                    stopTimer(resets: false);
                  } else {
                    startTimer(resets: false);
                  }
                },
                child: Text(isRunning ? 'STOP' : 'RESUME')),
            const SizedBox(width: 15),
            ElevatedButton(onPressed: stopTimer, child: Text("CANCEL"))
          ])
        : ElevatedButton(
            onPressed: () => (startTimer(resets: true)),
            child: Text("Start Timer ! "));
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(time,
              style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(header)
      ],
    );
  }
}
