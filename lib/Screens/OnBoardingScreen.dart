import 'package:flutter/material.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorBloc.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorEvent.dart';
import 'package:flutterakerapp/Screens/AuthenticationsScreens/LoginEmail.dart';
import 'package:flutterakerapp/Screens/AuthenticationsScreens/SignUpEmail.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class OnBoardingScreen extends StatelessWidget {
  static String route = "onboarding_screen";
  @override
  Widget build(BuildContext context) {
    NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                child: Text("SignUp with Email/Password"),
                onPressed: () {
                  navigatorBloc.navigatorEventSink
                      .add(NavigatorPushNamed(route: SignUpEmail.route));
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                child: Text("Login with Email Password"),
                onPressed: () {
                  navigatorBloc.navigatorEventSink
                      .add(NavigatorPushNamed(route: LoginEmail.route));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
