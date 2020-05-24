import 'package:equatable/equatable.dart';

abstract class NavigatorEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NavigatorPop extends NavigatorEvent {}

class NavigatorPushNamed extends NavigatorEvent {
  final String route;
  NavigatorPushNamed({this.route});
  @override
  List<Object> get props => [route];
}

class NavigatorPushReplacementNamed extends NavigatorEvent {
  final String route;
  NavigatorPushReplacementNamed({this.route});
  @override
  List<Object> get props => [route];
}
