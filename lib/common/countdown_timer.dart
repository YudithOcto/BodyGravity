import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onTimerEnd;
  final bool restart;

  const CountdownTimer(
      {super.key,
      required this.seconds,
      required this.onTimerEnd,
      required this.restart});

  @override
  createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingSeconds;
  late Timer timer;

  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.restart) {
      timer.cancel();
      startTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    remainingSeconds = widget.seconds;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingSeconds == 0) {
        widget.onTimerEnd();
        timer.cancel();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Resend OTP in $remainingSeconds seconds',
      style: const TextStyle(fontSize: 16),
    );
  }
}
