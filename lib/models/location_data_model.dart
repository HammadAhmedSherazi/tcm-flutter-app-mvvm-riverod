class LocationData {
  final double lat;
  final double lon;
  final String placeName;
  final String cityName;
  final String country;
  final String state;
  final String? countryCode;
  final String? zipCode;
  final String? provinceCode;

  LocationData({
    required this.lat,
    required this.lon,
    required this.placeName,
    required this.cityName,
    required this.country,
    required this.state,
    this.countryCode,
    this.provinceCode,
    this.zipCode,
  });

  /// 1st `fromJson` - simple direct mapping
  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      lat: json['lat'] != null
          ? double.tryParse(json['lat'].toString()) ?? 0.0
          : 0.0,
      lon: json['lon'] != null
          ? double.tryParse(json['lon'].toString()) ?? 0.0
          : 0.0,
      placeName: json['address_line'] as String? ?? 'Unknown address',
      cityName: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zipCode: json['zip_code'] ?? "",
      provinceCode: json['province_code'] as String?,
      countryCode: json['country_code'] as String?,
    );
  }

  /// 1st `fromJson` - simple direct mapping
  factory LocationData.fromJson2(Map<String, dynamic> json, LocationData loc) {
    final Map<String, dynamic> data = json['postalCodes'][0];
    return LocationData(
      lat: loc.lat,
      lon: loc.lon,
      placeName: loc.placeName,
      cityName: loc.cityName,
      country: loc.country,
      state: loc.state,
      provinceCode: data['ISO3166-2'] ?? "",
      zipCode:
          data['postalCode']  ?? "",
      countryCode: data['countryCode'] ?? "",
    );
  }

  /// 2nd `fromGoogleMapApi` - mapping Google Maps API response
  factory LocationData.fromGoogleMapApi(
      Map<String, dynamic> json, double lat, double lon) {
    final results = json['results'] as List<dynamic>?;

    if (results == null || results.isEmpty) {
      return LocationData(
        placeName: "",
        cityName: "",
        country: "",
        countryCode: null,
        lat: lat,
        lon: lon,
        provinceCode: null,
        state: "",
        zipCode: null,
      );
    }

    final firstResult = results.first as Map<String, dynamic>;
    final addressComponents =
        firstResult['address_components'] as List<dynamic>? ?? [];

    String getComponent(String type) {
      try {
        final comp = addressComponents.firstWhere(
          (c) => (c['types'] as List<dynamic>).contains(type),
          orElse: () => null,
        );
        return comp?['long_name'];
      } catch (_) {
        return "";
      }
    }

    // Get SHORT NAME (code like PK, SD)
    String getShortName(String type) {
      try {
        final comp = addressComponents.firstWhere(
          (c) => (c['types'] as List<dynamic>).contains(type),
          orElse: () => null,
        );
        return comp?['short_name'];
      } catch (_) {
        return "";
      }
    }

    // Get LONG NAME (full name)
    String getLongName(String type) {
      try {
        final comp = addressComponents.firstWhere(
          (c) => (c['types'] as List<dynamic>).contains(type),
          orElse: () => null,
        );
        return comp?['long_name'];
      } catch (_) {
        return "";
      }
    }

    return LocationData(
      placeName: firstResult['formatted_address'] ?? '',
      cityName: getComponent('locality'),
      country: getComponent('country'),
      countryCode: getShortName('country'),
      lat: lat,
      lon: lon,
      provinceCode: getShortName('administrative_area_level_1'),
      state: getComponent('administrative_area_level_1'),
      zipCode: getLongName('postal_code'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
      'address_line': placeName,
      'city': cityName,
      'country': country,
      'state': state,
     
    };
  }
  Map<String, dynamic> toJson2() {
    return {
      'address_line': placeName,
      'city': cityName,
      'country': country,
      'state': state,
      'zip_code': zipCode,
      'province_code': provinceCode,
      'country_code': countryCode,
    };
  }
}
