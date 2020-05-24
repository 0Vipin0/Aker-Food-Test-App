import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {}

class AddUserByEmailPassword extends UserEvent {
  final String email;
  final String password;
  final String name;
  AddUserByEmailPassword({this.email, this.password, this.name});

  @override
  List<Object> get props => [email, password, name];
}

class GetUserByEmailPassword extends UserEvent {
  final String email;
  final String password;
  GetUserByEmailPassword({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class SignOutWithFirebase extends UserEvent {
  @override
  List<Object> get props => [];
}
