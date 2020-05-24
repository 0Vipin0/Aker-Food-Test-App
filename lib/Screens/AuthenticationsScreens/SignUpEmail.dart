import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorBloc.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorEvent.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserBloc.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserEvent.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserState.dart';
import 'package:flutterakerapp/Screens/LandingScreen.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class SignUpEmail extends StatefulWidget {
  static String route = "signup_email";
  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  final GlobalKey<FormBuilderState> _signUpEmailKey =
      GlobalKey<FormBuilderState>();
  String name;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    NavigatorBloc navigatorBloc = BlocProvider.of<NavigatorBloc>(context);
    userBloc.loginStateStream.listen((event) {
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
            key: _signUpEmailKey,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  attribute: "name",
                  decoration: InputDecoration(labelText: "Name"),
                  validators: [
                    FormBuilderValidators.max(20),
                  ],
                  onChanged: (val) => name = val,
                  maxLines: 1,
                ),
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
                        if (_signUpEmailKey.currentState.saveAndValidate()) {
                          print(_signUpEmailKey.currentState.value);
                          userBloc.userEventSink.add(
                            AddUserByEmailPassword(
                              email: email,
                              password: password,
                              name: name,
                            ),
                          );
                        }
                      },
                    ),
                    MaterialButton(
                      child: Text("Reset"),
                      onPressed: () {
                        _signUpEmailKey.currentState.reset();
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

                      case LoginStatus.LOGIN_SUCCESS:
                        return Center(
                          child: Text("${snapshot.data.message}"),
                        );

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
      child: CircularProgressIndicator(),
    );
  }
}
