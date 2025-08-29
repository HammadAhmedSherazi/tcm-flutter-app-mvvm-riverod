import '../data/network/http_client.dart';
import '../export_all.dart';

class GetWeatherRepo {
  Future<WeatherDataModel?>? getWeatherData(String city) async {
    try {
      final response = await HttpClient.instance.get(
        ApiEndpoints.getValue(APIPath.getCityWeather),
        params: {
          "appid": BaseApiServices.weatherAppId,
          "units": "metric",
          "q": city
        },
        isCustomUrl: true,
        isToken: false,
      );
      appLog("Response - $response");

      return WeatherDataModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }


  Future setLocation({required input, required query})async{
    try {
      final response = await HttpClient.instance.post({
          'query': query,
          'variables': input,
        },isToken: true);
      
      return response;
      
    } catch (e) {
      throw Exception(e);
    }

  }
  
}