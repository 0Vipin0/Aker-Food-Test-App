enum LocationStatus {
  LOCATION_FETCHING,
  LOCATION_FETCHED,
  LOCATION_ERROR,
}

class LocationState {
  final LocationStatus locationStatus;
  final String message;

  LocationState({
    this.locationStatus,
    this.message,
  });
}
