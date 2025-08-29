
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tcm/utils/app_logger.dart';
import '../models/place_detail_model.dart';
// import '../export_all.dart';

class CustomGoogleMapWidget extends StatefulWidget {
  final double lat;
  final double long;
  final double? zoom;
  final PlaceDetailModel? location;
  final Set<Circle>? radiusCircle;
  final void Function(GoogleMapController)? onMapCreated;
  const CustomGoogleMapWidget(
      {super.key,
      required this.lat,
      required this.long,
      this.location,
      this.radiusCircle,
      this.onMapCreated,
      this.zoom});

  @override
  State<CustomGoogleMapWidget> createState() => _CustomGoogleMapWidgetState();
}

class _CustomGoogleMapWidgetState extends State<CustomGoogleMapWidget> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  late final CameraPosition kGooglePlex;
  // static const CameraPosition kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    
    kGooglePlex = CameraPosition(
      target: LatLng(widget.lat, widget.long),
      zoom: widget.zoom ?? 15.4746,
    );
    final marker = widget.location == null ?  Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(widget.lat, widget.long),
      infoWindow: const InfoWindow(
        title: 'you can add any message here',
      ),
    ): Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(widget.location?.result?.geometry?.location?.lat ??0.0, widget.location?.result?.geometry?.location?.lng ??0.0),
      infoWindow:  InfoWindow(
        title: widget.location?.result?.vicinity,
      ),
    );
    _markers['myLocation'] = marker;
 
    appLog("Google Map Initialize");
    setState(() {});
  }
  

  @override
  Widget build(BuildContext context) {
     appLog("Google Map Set");
    return GoogleMap(
      
      mapType: MapType.normal,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition:widget.location == null ? kGooglePlex : CameraPosition(
      target: LatLng(widget.lat, widget.long),
      zoom: widget.zoom ?? 15.4746,
    ),
      circles: widget.radiusCircle ?? const <Circle>{},
      markers: widget.location == null
          ? _markers.values.toSet()
          : {
              Marker(
                  markerId: const MarkerId('myLocation'),
                  position: LatLng(
                      widget.location?.result?.geometry?.location?.lat ?? 0.0,
                      widget.location?.result?.geometry?.location?.lng ?? 0.0),
                      infoWindow: InfoWindow(
                      title: widget.location?.result?.vicinity ?? ""))
            },
      // onTap: (LatLng latlng) {

      //       final marker = Marker(
      //         markerId: const MarkerId('myLocation'),
      //         position: LatLng(latlng.latitude, latlng.longitude),
      //         infoWindow: const InfoWindow(
      //           title: 'AppLocalizations.of(context).will_deliver_here',
      //         ),
      //       );
      //       setState(() {
      //         _markers['myLocation'] = marker;
      //       });
      //     },
      onMapCreated: widget.onMapCreated,
    );
  }
}
