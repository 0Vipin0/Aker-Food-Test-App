import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutterakerapp/Blocs/DataBloc/DataBloc.dart';
import 'package:flutterakerapp/Blocs/DataBloc/DataEvent.dart';
import 'package:flutterakerapp/Blocs/DataBloc/DataStates.dart';
import 'package:flutterakerapp/Models/DataAPI.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class GraphScreen extends StatefulWidget {
  static String route = "graph_screen";
  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  String region = 'UK';
  String parameter = "Max Temp";
  @override
  Widget build(BuildContext context) {
    DataBloc dataBloc = BlocProvider.of<DataBloc>(context);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  DropdownButton<String>(
                    value: region,
                    items: <String>[
                      'UK',
                      'England',
                      'Wales',
                      'Scotland',
                      'Northern_Ireland'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        region = val;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: parameter,
                    items: <String>[
                      'Max Temp',
                      'Min Temp',
                      'Mean Temp',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        parameter = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            FlatButton(
              child: Text("Click Me"),
              onPressed: () {
                dataBloc.dataEventSink
                    .add(GetData(parameter: parameter, region: region));
              },
            ),
            StreamBuilder<DataState>(
              stream: dataBloc.dataStateStream,
              builder: (context, AsyncSnapshot<DataState> snapshot) {
                if (!snapshot.hasData) return Container();

                switch (snapshot.data.status) {
                  case DataStatus.FETCHING:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  case DataStatus.FETCH_ERROR:
                    return Text(snapshot.data.message.toString());

                  case DataStatus.FETCHED:
                    List<charts.Series<DataAPI, num>> seriesList = [
                      charts.Series<DataAPI, num>(
                        id: "Temperature",
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (DataAPI data, _) => data.year,
                        measureFn: (DataAPI data, _) => data.aut,
                        data: dataBloc.data,
                      )
                    ];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 4,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: charts.LineChart(
                          seriesList,
                          animate: false,
                          behaviors: [
                            charts.SeriesLegend(),
                            charts.SlidingViewport(),
                            charts.PanAndZoomBehavior(),
                          ],
                          defaultRenderer:
                              charts.LineRendererConfig(includePoints: true),
                          primaryMeasureAxis: charts.NumericAxisSpec(
                              renderSpec: charts.GridlineRendererSpec(
                            labelAnchor: charts.TickLabelAnchor.before,
                            labelJustification:
                                charts.TickLabelJustification.outside,
                          )),
                        ),
                      ),
                    );

                  default:
                    return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
