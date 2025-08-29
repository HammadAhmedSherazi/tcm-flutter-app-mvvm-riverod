import '../data/network/http_client.dart';
import '../export_all.dart';
import '../models/place_detail_model.dart';

class MapsRepository {

  Future<PlaceListingModel?> getPlaceListing(String input) async {
    try {
      var jsonData = await HttpClient.instance.get(
        "${ApiEndpoints.getValue(APIPath.googleMapApi)}place/autocomplete/json",
        params: {
          "input":input,
          "key": "AIzaSyCUrF7t8LjdeDSx8t94CIS_6xEwSE145hA",
          
        },
        isCustomUrl: true,
        isToken: false,
      
    );

    PlaceListingModel result = PlaceListingModel.fromJson(jsonData);

    return result;
    } catch (e) {
     return null;
    }
  }

  Future<PlaceDetailModel?> getPlaceDetails(String placeId) async {
    try {
        var jsonData = await HttpClient.instance.get(
        "${ApiEndpoints.getValue(APIPath.googleMapApi)}place/details/json",
        params: {
          "place_id" :placeId,
           "key": "AIzaSyCUrF7t8LjdeDSx8t94CIS_6xEwSE145hA",
          
        },
        isCustomUrl: true,
        isToken: false,
        
      );

      PlaceDetailModel result = PlaceDetailModel.fromJson(jsonData);

      return result;
    } catch (e) {
      return null;
    }
      
  }

  Future<LocationData?> getLocationDetail(double lat, double lon) async {
  try {
    var jsonData = await HttpClient.instance.get(
      "${ApiEndpoints.getValue(APIPath.googleMapApi)}geocode/json",
      params: {
        "latlng": "$lat,$lon",
        "key": "AIzaSyCUrF7t8LjdeDSx8t94CIS_6xEwSE145hA",
      },
      isCustomUrl: true,
      isToken: false,
    );

    return LocationData.fromGoogleMapApi(jsonData, lat, lon);
  } catch (e) {
    // print('Error in getLocationDetail: $e');
    return null;
  }
}
Future<LocationData?> getAdditionalLocationDetail(LocationData loc) async {
  try {
    var jsonData = await HttpClient.instance.get(
      "http://api.geonames.org/postalCodeSearchJSON",
      params: {
        "placename": loc.cityName,
        "country" :loc.countryCode ?? "",
        "username" :"bilalalilive"
      },
      isCustomUrl: true,
      isToken: false,
    );
    return LocationData.fromJson2(jsonData, loc);
    
  } catch (e) {
    // print('Error in getLocationDetail: $e');
    return null;
  }
}
}
