import 'package:flutter/material.dart';
import 'package:flutterakerapp/Blocs/DataBloc/DataBloc.dart';
import 'package:flutterakerapp/Blocs/LocationBloc/LocationBloc.dart';
import 'package:flutterakerapp/Blocs/LocationBloc/LocationEvent.dart';
import 'package:flutterakerapp/Repositories/DataRepository.dart';
import 'package:flutterakerapp/Screens/GraphScreen.dart';
import 'package:flutterakerapp/Services/LocationService.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'Blocs/NavigatorBloc/NavigatorBloc.dart';
import 'Blocs/UserBloc/UserBloc.dart';
import 'Screens/AuthenticationsScreens/LoginEmail.dart';
import 'Screens/AuthenticationsScreens/SignUpEmail.dart';
import 'Screens/LandingScreen.dart';
import 'Screens/OnBoardingScreen.dart';
import 'Services/AuthenticationService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthenticationService authenticationService = AuthenticationService();
  final LocationService locationService = LocationService();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final DataRepository dataRepository = DataRepository();
  runApp(BlocProvider<DataBloc>(
    bloc: DataBloc(dataRepository: dataRepository),
    child: BlocProvider<LocationBloc>(
      bloc: LocationBloc(locationService: locationService)
        ..locationEventSink.add(GetUserLocation()),
      child: BlocProvider<NavigatorBloc>(
        bloc: NavigatorBloc(navigatorKey: navigatorKey),
        child: BlocProvider<UserBloc>(
          bloc: UserBloc(
            authenticationService: authenticationService,
          ),
          child: MyApp(navigatorKey: navigatorKey),
        ),
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  MyApp({this.navigatorKey});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Aker Food',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnBoardingScreen(),
      routes: {
        OnBoardingScreen.route: (context) => OnBoardingScreen(),
        SignUpEmail.route: (context) => SignUpEmail(),
        LoginEmail.route: (context) => LoginEmail(),
        LandingScreen.route: (context) => LandingScreen(),
        GraphScreen.route: (context) => GraphScreen(),
      },
    );
  }
}
