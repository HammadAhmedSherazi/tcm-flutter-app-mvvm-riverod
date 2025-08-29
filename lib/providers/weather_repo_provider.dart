
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../data/network/api_response.dart';

// import '../models/weather_data_model.dart';
// import '../repository/get_weather_repo.dart';
// import '../utils/helper.dart';

// class WeatherProvider extends ChangeNotifier {
//   late GetWeatherRepo _getWeatherRepo;
//   late ApiResponse<WeatherDataModel> _apiResponse;


// String selectedCity = "Karachi";

// ApiResponse<WeatherDataModel> get weatherResponse => _apiResponse;
// WeatherProvider(){
//   _getWeatherRepo = GetWeatherRepo();
//   _apiResponse = ApiResponse<WeatherDataModel>();
// }
// Future fetchWeatherOfCity(String city) async{

//     try {
//       _apiResponse = ApiResponse.loading('loading... ');
//       notifyListeners();
//       final response = await _getWeatherRepo.getWeatherData("Karachi");
//       if(response != null){
//       _apiResponse = ApiResponse.completed(response);
      

//       }
//       else{
//       _apiResponse = ApiResponse.error("Something went wrong!");

//       }
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _apiResponse =
//           ApiResponse.errors(Helper.genericErrorHandler(e.toString()));
//       notifyListeners();
//       return false;
//     }

//   }
//   void changeChangeCity( int index){
   
   

//     fetchWeatherOfCity(selectedCity);
//     notifyListeners();



//   }




// }

// final weatherProvider = ChangeNotifierProvider<WeatherProvider>((ref) {
//   return WeatherProvider();
// });