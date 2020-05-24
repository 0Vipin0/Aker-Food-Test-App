import 'dart:async';

import 'package:flutterakerapp/Blocs/LocationBloc/LocationEvent.dart';
import 'package:flutterakerapp/Blocs/LocationBloc/LocationState.dart';
import 'package:flutterakerapp/Services/LocationService.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';

class LocationBloc extends Bloc {
  LocationService _locationService;
  Position currentPosition;

  StreamController _locationController = StreamController.broadcast();
  StreamSink get locationEventSink => _locationController.sink;
  Stream get _locationEventStream => _locationController.stream;

  StreamController<LocationState> _locationStateController =
      StreamController<LocationState>.broadcast();
  StreamSink<LocationState> get _locationStateSink =>
      _locationStateController.sink;
  Stream<LocationState> get locationStateStream =>
      _locationStateController.stream;

  void changeLocationState({LocationState state}) =>
      _locationStateSink.add(state);

  LocationBloc({LocationService locationService})
      : assert(locationService != null),
        _locationService = locationService {
    _locationEventStream.listen((event) {
      _mapEventToState(event);
    });
  }

  _mapEventToState(LocationEvent event) {
    if (event is GetUserLocation) {
      changeLocationState(
        state: LocationState(
          locationStatus: LocationStatus.LOCATION_FETCHING,
          message: "Fetching",
        ),
      );
      _locationService.getCurrentLocation();
      Position position = _locationService?.currentPosition;
      if (position != null) {
        currentPosition = position;
        changeLocationState(
          state: LocationState(
            locationStatus: LocationStatus.LOCATION_FETCHED,
            message: "Fetched",
          ),
        );
      } else {
        changeLocationState(
          state: LocationState(
            locationStatus: LocationStatus.LOCATION_ERROR,
            message: "Error",
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _locationController.close();
    _locationStateController.close();
  }
}
