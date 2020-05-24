enum DataStatus {
  FETCHING,
  FETCHED,
  FETCH_ERROR,
}

class DataState {
  final DataStatus status;
  final String message;

  DataState({this.status, this.message});
}
