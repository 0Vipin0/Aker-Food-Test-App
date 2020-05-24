import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutterakerapp/Blocs/LocationBloc/LocationBloc.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorBloc.dart';
import 'package:flutterakerapp/Blocs/NavigatorBloc/NavigatorEvent.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserBloc.dart';
import 'package:flutterakerapp/Blocs/UserBloc/UserEvent.dart';
import 'package:flutterakerapp/Screens/GraphScreen.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as LatLong;

class LandingScreen extends StatefulWidget {
  static String route = "home_screen";
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  GoogleMapController _controller;
  final Map<String, Marker> _markers = {};
  LatLng _userLocation;
  LatLng temp;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  Future<LatLng> _initialLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _userLocation = LatLng(currentLocation.latitude, currentLocation.longitude);
    return _userLocation;
  }

  void _setMarker(LatLng value) {
    _markers.clear();
    final marker = Marker(
      markerId: MarkerId("current_loc"),
      position: LatLng(value.latitude, value.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    _markers["Current Location"] = marker;
  }

  void _getLocation() async {
    LatLng currentLocation = await _initialLocation();
    print(
        "Location is ${currentLocation.latitude}+${currentLocation.longitude}");
    setState(() {
      _setMarker(currentLocation);
    });
  }

  UserBloc userBloc;
  NavigatorBloc navigatorBloc;
  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userBloc = BlocProvider.of(context);
    navigatorBloc = BlocProvider.of(context);
    LocationBloc locationBloc = BlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        centerTitle: true,
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              userBloc.userEventSink.add(SignOutWithFirebase());
              navigatorBloc.navigatorEventSink.add(NavigatorPop());
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Builder(builder: (context) {
            return FloatingActionButton(
              heroTag: "Graph",
              child: Icon(Icons.graphic_eq),
              onPressed: () {
                final LatLong.Distance space = LatLong.Distance();
                double distanceInMeters = space(
                    LatLong.LatLng(temp.latitude, temp.longitude),
                    LatLong.LatLng(
                        _userLocation.latitude, _userLocation.longitude));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      content: Text("Distance is $distanceInMeters meters"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "Map",
            child: Icon(Icons.map),
            onPressed: () {
              navigatorBloc.navigatorEventSink
                  .add(NavigatorPushNamed(route: GraphScreen.route));
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(40.688841, -74.044015),
              zoom: 20,
            ),
            markers: _markers.values.toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: _userLocation, zoom: 20.0),
                ),
              );
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onLongPress: (LatLng val) {
              temp = val;
              setState(() {
                _setMarker(temp);
              });
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: FloatingActionButton(
              heroTag: "complaint_button",
              backgroundColor: Colors.red,
              onPressed: () {
                _getLocation();
              },
              child: Icon(Icons.location_on),
            ),
          ),
        ],
      ),
    );
  }
}
