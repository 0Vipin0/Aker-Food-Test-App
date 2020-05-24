import 'dart:async';

import 'package:flutterakerapp/Blocs/DataBloc/DataEvent.dart';
import 'package:flutterakerapp/Blocs/DataBloc/DataStates.dart';
import 'package:flutterakerapp/Models/DataAPI.dart';
import 'package:flutterakerapp/Repositories/DataRepository.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class DataBloc extends Bloc {
  DataRepository _dataRepository;
  List<DataAPI> data;

  StreamController<DataEvent> _dataEventController =
      StreamController<DataEvent>.broadcast();
  StreamSink<DataEvent> get dataEventSink => _dataEventController.sink;
  Stream<DataEvent> get _dataEventStream => _dataEventController.stream;

  DataBloc({DataRepository dataRepository})
      : assert(dataRepository != null),
        _dataRepository = dataRepository {
    _dataEventStream.listen((event) {
      _mapEventToState(event);
    });
  }

  StreamController<DataState> _dataStateController =
      StreamController<DataState>.broadcast();
  StreamSink<DataState> get _dataStateSink => _dataStateController.sink;
  Stream<DataState> get dataStateStream => _dataStateController.stream;

  void changeDataState({DataState state}) => _dataStateSink.add(state);

  _mapEventToState(DataEvent event) async {
    if (event is GetData) {
      changeDataState(
        state: DataState(status: DataStatus.FETCHING, message: "Fetching"),
      );
      switch (event.parameter) {
        case "Max Temp":
          _dataRepository.getData(event.region, "Tmax").then((_) {
            data = _dataRepository.data;
            changeDataState(
              state: DataState(status: DataStatus.FETCHED, message: "Fetched"),
            );
          }).catchError((e) {
            changeDataState(
              state: DataState(
                  status: DataStatus.FETCH_ERROR, message: "Fetch Error"),
            );
          });
          break;

        case "Min Temp":
          _dataRepository.getData(event.region, "Tmin").then((_) {
            data = _dataRepository.data;
            changeDataState(
              state: DataState(status: DataStatus.FETCHED, message: "Fetched"),
            );
          }).catchError((e) {
            changeDataState(
              state: DataState(
                  status: DataStatus.FETCH_ERROR, message: "Fetch Error"),
            );
          });
          break;

        case "Mean Temp":
          _dataRepository.getData(event.region, "Tmean").then((_) {
            data = _dataRepository.data;
            changeDataState(
              state: DataState(status: DataStatus.FETCHED, message: "Fetched"),
            );
          }).catchError((e) {
            changeDataState(
              state: DataState(
                  status: DataStatus.FETCH_ERROR, message: "Fetch Error"),
            );
          });
          break;

        default:
      }
    }
  }

  @override
  void dispose() {
    _dataEventController.close();
    _dataStateController.close();
  }
}
