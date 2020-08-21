import 'package:geolocator/geolocator.dart';

class Location{

  Position position;
  double lat, lon;

  Future<bool> getCurrentLocation() async {
    try {
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low).timeout(Duration(seconds: 7));
      lat = position.latitude;
      lon = position.longitude;
      return true;
    } catch (e) {
      return false;
    }
  }
}