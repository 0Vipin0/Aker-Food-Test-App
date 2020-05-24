import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationService {
  FirebaseUser user;
  AuthResult result;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user = result.user;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          {
            Fluttertoast.showToast(msg: e.message);
          }
          break;
        case "ERROR_WEAK_PASSWORD":
          {
            Fluttertoast.showToast(msg: e.message);
          }
          break;
        default:
          {
            Fluttertoast.showToast(msg: "Success");
          }
      }
    } finally {
      print("SignUp with Email and Password Accessed");
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = result.user;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ERROR_USER_NOT_FOUND":
          {
            Fluttertoast.showToast(msg: e.message);
          }
          break;
        case "ERROR_WRONG_PASSWORD":
          {
            Fluttertoast.showToast(msg: e.message);
          }
          break;
        default:
          {
            Fluttertoast.showToast(msg: "Success");
          }
      }
    } finally {
      print("SignIn with Email and Password is Accessed");
    }
  }

  void signOutWithFirebase() async {
    await FirebaseAuth.instance.signOut();
    print("User Sign Out on Firebase Sign In");
  }
}
