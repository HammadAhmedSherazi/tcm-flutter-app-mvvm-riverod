import '../../export_all.dart';

class ApiEndpoints {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.getCityWeather:
      return "https://api.openweathermap.org/data/2.5/weather"; 

      case APIPath.googleMapApi:
      return "https://maps.googleapis.com/maps/api/";
      default:
      return "";

    }
  }
}
