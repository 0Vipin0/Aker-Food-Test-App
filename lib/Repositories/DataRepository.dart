import 'package:flutterakerapp/Models/DataAPI.dart';
import 'package:http/http.dart' as http;

class DataRepository {
  List<DataAPI> data;
  List<String> headers;

  Future<void> getData(String region, String parameter) async {
    String file = await http.read(
        "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/$parameter/date/$region.txt");
    int yearIndex = file.lastIndexOf("year");
    String startingData = file.substring(yearIndex);
    List<String> dataRows = startingData.split("\n");
    List<DataAPI> tempData = List<DataAPI>();
    List<String> tempHeaders = dataRows[0].split("   ");
    for (int i = 1; i < dataRows.length; i++) {
      List<String> data = dataRows[i].split("   ");
      try {
        tempData.add(
          DataAPI(
            int.parse(data[0]),
            double.parse(data[1]),
            double.parse(data[2]),
            double.parse(data[3]),
            double.parse(data[4]),
            double.parse(data[5]),
            double.parse(data[6]),
            double.parse(data[7]),
            double.parse(data[8]),
            double.parse(data[9]),
            double.parse(data[10]),
            double.parse(data[11]),
            double.parse(data[12]),
            double.parse(data[13]),
            double.parse(data[14]),
            double.parse(data[15]),
            double.parse(data[16]),
            double.parse(data[17]),
          ),
        );
      } on Exception catch (e) {
        print("Index is : $i with Exception $e");
      }
    }
    print(
        "DataRows length is : ${dataRows.length} and tempData length is ${tempData.length}");
    print(tempData[5].year.toString());
    data = tempData;
    headers = tempHeaders;
  }
}
