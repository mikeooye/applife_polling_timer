import 'package:applife_polling_timer/applife_polling_timer.dart';
import 'package:flutter/material.dart';

class ApplifePollingTimer extends PollingTimer with WidgetsBindingObserver {
  ApplifePollingTimer(
      {bool debug = false,
      required Duration duration,
      required ValueChanged<PollingTimer> callback})
      : super(
          debug: debug,
          duration: duration,
          callback: callback,
        ) {
    WidgetsBinding.instance!.addObserver(this);
  }

  bool _pausedBefore = false;

  @override
  void cancel() {
    super.cancel();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      _pausedBefore = super.isPaused;
      super.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (!_pausedBefore) {
        super.resume();
      }
    }
  }
}
