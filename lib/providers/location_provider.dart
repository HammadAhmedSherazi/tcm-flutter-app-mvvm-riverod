
import 'package:permission_handler/permission_handler.dart';
import 'package:tcm/utils/app_extensions.dart';
import '../export_all.dart';



class GetCurrentLocation extends ChangeNotifier {
  LocationData currentLocation = LocationData(
      lat: 0.0,
      lon: 0.0,
      placeName: "-----------",
      cityName: "-------",
      country: "-------",
      state: "-------");
  final GetWeatherRepo weatherRepo = GetWeatherRepo();
  final MapsRepository mapRepo = MapsRepository();
  late ApiResponse<WeatherDataModel> apiResponse = ApiResponse();

  Future<void> checkLocationPermission() async {
    try {
      var status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        final position = await _getLocation();
        if (position != null) {
          changeLocation(position.latitude, position.longitude);
        }
      } 
      // else {
      //   _showLocationDisabledDialog(checkLocationPermission());
      // }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Position?> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return await Geolocator.getCurrentPosition();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.unableToDetermine) {
          return null;
        }
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      throw Exception(e);
    }
  }

  

 Future fetchWeatherOfCity(String city) async {
    try {
      apiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await weatherRepo.getWeatherData(city);
      if (response != null) {
        apiResponse = ApiResponse.completed(response);
      } else {
        apiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      apiResponse =
          ApiResponse.errors();
      notifyListeners();
    }
  }
  Future< LocationData?> getLocationDetail(double lat, double lon)async{
    try{
      final result = await mapRepo.getLocationDetail(lat, lon);
      return result; 
    }catch(e){
      return null;
    }
  }

  void changeLocation(double lat, double lon) async {
    final LocationData? place =await getLocationDetail(lat, lon);
    if (place != null) {
      // weatherRepo.setLocation(input: {}, query: GraphQLQueries.locationSetQuery);
    
      currentLocation = place;
      if (currentLocation.placeName != "") {
        fetchWeatherOfCity(currentLocation.cityName);
      }
    }
  }
}

final currentLocationProvider =
    ChangeNotifierProvider<GetCurrentLocation>((ref) => GetCurrentLocation());
void showLocationDisabledDialog(Future<void> fun) {
  showModalBottomSheet(
    context: AppRouter.navKey.currentState!.context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const GenericTranslateWidget( 
              'Location Disabled',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            10.ph,
            const GenericTranslateWidget( 
              'Please enable location services to use this feature.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Open device settings to enable location
                AppSettings.openAppSettings().then((c) {
                  fun;
                });
                // if (isEnabled) {
                Navigator.pop(context); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const GenericTranslateWidget( 
                'Enable Location',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            10.ph
          ],
        ),
      );
    },
  );
}
