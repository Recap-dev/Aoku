import 'package:google_maps_flutter/google_maps_flutter.dart';

class AoiSound {
  AoiSound({
    required this.title,
    required this.fileName,
    required this.location,
    required this.length,
    required this.city,
    required this.province,
  });

  final String title;
  final String fileName;
  final LatLng location;
  final int length;
  final String city;
  final String province;
}
