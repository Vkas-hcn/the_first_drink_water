import 'package:flutter/material.dart';

class LTFDW extends WidgetsBindingObserver {
  final Function onAppResumed;
  final Function onAppPaused;

  LTFDW({required this.onAppResumed, required this.onAppPaused});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("生命周期-resumed");
        onAppResumed();
        break;
      case AppLifecycleState.paused:
        print("生命周期-paused");
        onAppPaused();
        break;
      case AppLifecycleState.inactive:
        print("生命周期-inactive");
        break;
      case AppLifecycleState.detached:
        print("生命周期-detached");
        break;
      case AppLifecycleState.hidden:
        print("生命周期-hidden");
        break;
      default:
        break;
    }
  }
}
