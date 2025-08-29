import '../export_all.dart';
import '../models/place_detail_model.dart';


class GoogleMapAPIProvider extends ChangeNotifier {
  late ApiResponse<PlaceListingModel> placeListApiResponse = ApiResponse();
  late ApiResponse<PlaceDetailModel> placeDetailApiResponse = ApiResponse();
  final MapsRepository mapRepo = MapsRepository();

  Future searchPlace(String keyword) async {
    try {
      placeListApiResponse = ApiResponse.loading();
      notifyListeners();
      final response = await mapRepo.getPlaceListing(keyword);
      if (response != null) {
        placeListApiResponse = ApiResponse.completed(response);
      } else {
        placeListApiResponse = ApiResponse.error();
      }
      notifyListeners();
    } catch (e) {
      placeListApiResponse =
          ApiResponse.errors();
      notifyListeners();
    }
  }

  Future<PlaceDetailModel?> getPlaceDetail(String placeId) async {
    try {
      placeDetailApiResponse = ApiResponse.loading();
      // notifyListeners();
      final response = await mapRepo.getPlaceDetails(placeId);
      if (response != null) {
        placeDetailApiResponse = ApiResponse.completed(response);
        return placeDetailApiResponse.data;
      } else {
        placeDetailApiResponse = ApiResponse.error();
        return null;
      }
      // notifyListeners();
    } catch (e) {
      placeDetailApiResponse =
          ApiResponse.errors();
      return null;
      // notifyListeners();
    }
  }
}

final googleMapApiProvider = ChangeNotifierProvider<GoogleMapAPIProvider>(
  (ref) => GoogleMapAPIProvider(),
);
