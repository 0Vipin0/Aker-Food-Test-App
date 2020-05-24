import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserEvent.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserState.dart';
import 'package:flutterakerapp/Services/AuthenticationService.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class UserBloc extends Bloc {
  AuthenticationService _authenticationService;

  StreamController<UserEvent> _userEventController =
      StreamController<UserEvent>.broadcast();
  StreamSink<UserEvent> get userEventSink => _userEventController.sink;
  Stream<UserEvent> get _userEventStream => _userEventController.stream;

  StreamController<LoginState> _loginStateController =
      StreamController<LoginState>.broadcast();
  StreamSink<LoginState> get _loginStateSink => _loginStateController.sink;
  Stream<LoginState> get loginStateStream => _loginStateController.stream;

  void changeLoginState({LoginState state}) => _loginStateSink.add(state);

  UserBloc({@required AuthenticationService authenticationService})
      : assert(authenticationService != null),
        _authenticationService = authenticationService {
    _userEventStream.listen((event) {
      _mapEventToState(event);
    });
  }

  _mapEventToState(UserEvent event) async {
    if (event is AddUserByEmailPassword) {
      changeLoginState(
        state: LoginState(
          status: LoginStatus.LOGGING,
          message: "logging",
        ),
      );
      _authenticationService
          .signUpWithEmailAndPassword(
        event.email,
        event.password,
      )
          .then((_) {
        FirebaseUser user = _authenticationService?.user;
        if (user != null) {
          changeLoginState(
            state: LoginState(
              status: LoginStatus.LOGIN_SUCCESS,
              message: "Login Success",
            ),
          );
        } else {
          changeLoginState(
            state: LoginState(
              status: LoginStatus.LOGIN_ERROR,
              message: "Login Success",
            ),
          );
        }
      });
    } else if (event is GetUserByEmailPassword) {
      changeLoginState(
        state: LoginState(
          status: LoginStatus.LOGGING,
          message: "logging",
        ),
      );
      _authenticationService
          .signInWithEmailAndPassword(
        event.email,
        event.password,
      )
          .then((_) {
        FirebaseUser user = _authenticationService?.user;
        if (user != null) {
          changeLoginState(
            state: LoginState(
              status: LoginStatus.LOGIN_SUCCESS,
              message: "Login Success",
            ),
          );
        } else {
          changeLoginState(
            state: LoginState(
              status: LoginStatus.LOGIN_ERROR,
              message: "Login Success",
            ),
          );
        }
      });
    } else if (event is SignOutWithFirebase) {
      _authenticationService.signOutWithFirebase();
    }
  }

  @override
  void dispose() {
    _userEventController.close();
    _loginStateController.close();
  }
}
