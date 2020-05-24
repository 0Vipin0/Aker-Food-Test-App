import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorBloc.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorEvent.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserBloc.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserEvent.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserState.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '../LandingScreen.dart';

class LoginEmail extends StatefulWidget {
  static String route = "login_email";
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final GlobalKey<FormBuilderState> _loginEmailKey =
      GlobalKey<FormBuilderState>();
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    userBloc.loginStateStream.listen((event) {
      print(event.status);
      if (event.status == LoginStatus.LOGIN_SUCCESS) {
        navigatorBloc.navigatorEventSink
            .add(NavigatorPushReplacementNamed(route: LandingScreen.route));
      }
    });
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FormBuilder(
            autovalidate: true,
            key: _loginEmailKey,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  attribute: "email",
                  decoration: InputDecoration(labelText: "Email"),
                  validators: [
                    FormBuilderValidators.email(),
                  ],
                  onChanged: (val) => email = val,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                ),
                FormBuilderTextField(
                  attribute: "password",
                  decoration: InputDecoration(labelText: "Password"),
                  validators: [
                    FormBuilderValidators.minLength(6),
                  ],
                  onChanged: (val) => password = val,
                  obscureText: true,
                  maxLines: 1,
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                      child: Text("Submit"),
                      onPressed: () {
                        if (_loginEmailKey.currentState.saveAndValidate()) {
                          print(_loginEmailKey.currentState.value);
                          userBloc.userEventSink.add(
                            GetUserByEmailPassword(
                              email: email,
                              password: password,
                            ),
                          );
                        }
                      },
                    ),
                    MaterialButton(
                      child: Text("Reset"),
                      onPressed: () {
                        _loginEmailKey.currentState.reset();
                      },
                    ),
                  ],
                ),
                StreamBuilder<LoginState>(
                  stream: userBloc.loginStateStream,
                  builder: (context, AsyncSnapshot<LoginState> snapshot) {
                    if (!snapshot.hasData) return Container();

                    switch (snapshot.data.status) {
                      case LoginStatus.LOGGING:
                        return _buildLoadingWidget();

                      case LoginStatus.LOGIN_ERROR:
                        return _buildErrorWidget(snapshot.data.message);

                      case LoginStatus.NON_LOGIN:
                      default:
                        return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Loading data from API...",
            textDirection: TextDirection.ltr,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Loading error data from API...",
              textDirection: TextDirection.ltr),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
