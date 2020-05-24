import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class NavigatorBloc extends Bloc {
  GlobalKey<NavigatorState> navigatorKey;

  StreamController _navigatorController = StreamController.broadcast();
  StreamSink get navigatorEventSink => _navigatorController.sink;
  Stream get _navigatorEventStream => _navigatorController.stream;

  NavigatorBloc({this.navigatorKey}) {
    _navigatorEventStream.listen((event) {
      _mapEventToState(event);
    });
  }
  _mapEventToState(NavigatorEvent event) {
    if (event is NavigatorPop) {
      navigatorKey.currentState.pop();
    } else if (event is NavigatorPushNamed) {
      navigatorKey.currentState.pushNamed(event.route);
    } else if (event is NavigatorPushReplacementNamed) {
      navigatorKey.currentState.pushReplacementNamed(event.route);
    }
  }

  @override
  void dispose() {
    _navigatorController.close();
  }
}
