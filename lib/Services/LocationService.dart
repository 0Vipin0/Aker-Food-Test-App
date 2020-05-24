import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Geolocator _geolocator = Geolocator()..forceAndroidLocationManager = true;
  Position currentPosition;
  Placemark currentPlacemark;

  Future<void> getCurrentLocation() {
    return _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((position) {
      currentPosition = position;
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  Future<Placemark> getCurrentPosition(Position userPosition) {
    return _geolocator
        .placemarkFromCoordinates(userPosition.latitude, userPosition.latitude)
        .then((p) async {
      currentPlacemark = p[0];
      Placemark place = p[0];
      print(
          " ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}");
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    });
  }
}
