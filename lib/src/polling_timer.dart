import 'dart:async';

import 'package:flutter/material.dart';

class PollingTimer extends Object {
  final Duration duration;
  final ValueChanged<PollingTimer> callback;
  final bool debug;

  DateTime? _lastfiredDatetime;
  Timer? _timer;

  bool _paused = false;
  bool get isPaused => _paused;

  PollingTimer(
      {required this.duration, required this.callback, this.debug = false});

  void start() {
    if (_timer?.isActive == true) {
      cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_lastfiredDatetime == null) {
        _updateTime();
      }

      if (_paused) {
        return;
      }

      if (DateTime.now().difference(_lastfiredDatetime!) >= duration) {
        _updateTime();
        callback(this);
      }
    });

    _log('timer started');
  }

  void _updateTime() {
    _lastfiredDatetime = DateTime.now();
  }

  void cancel() {
    _timer?.cancel();
    _lastfiredDatetime = null;
    _log('timer canceled');
  }

  void pause() {
    _paused = true;
    _log('timer paused');
  }

  void resume() {
    _paused = false;
    _log('timer resumed');
  }

  void reset() {
    _updateTime();
  }

  void _log(Object obj) {
    if (debug) {
      print(obj);
    }
  }
}
