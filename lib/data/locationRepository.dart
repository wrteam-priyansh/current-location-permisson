import 'package:geolocator/geolocator.dart';

class LocationRepository {
  Future<Position> getCurrentLocation() async {
    try {
      //
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Please enable location");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        throw Exception("User denied permission forever");
      } else if (permission == LocationPermission.unableToDetermine) {
        throw Exception("Unable to get permission details");
      }
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
