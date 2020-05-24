import 'package:equatable/equatable.dart';

abstract class DataEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetData extends DataEvent {
  final String parameter;
  final String region;
  GetData({this.parameter, this.region});
  @override
  List<Object> get props => [parameter, region];
}
