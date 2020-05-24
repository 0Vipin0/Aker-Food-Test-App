import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User extends Equatable {
  final String uid;
  final String name;
  final String phoneNumber;
  final String email;
  final String fcmToken;
  final String password;

  User({
    @required this.uid,
    this.name,
    this.phoneNumber,
    this.email,
    this.fcmToken,
    this.password,
  });

  toJson() {
    return {
      "uid": this.uid,
      "name": this.name ?? null,
      "phoneNumber": this.phoneNumber ?? null,
      "email": this.email ?? null,
      "fcmToken": this.fcmToken ?? null,
      "password": this.password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      fcmToken: map['fcmToken'],
      password: map['password'],
    );
  }

  @override
  List<Object> get props => [uid, name, email, phoneNumber, fcmToken, password];

  @override
  bool get stringify => true;
}
