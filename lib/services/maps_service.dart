import 'package:url_launcher/url_launcher.dart';
import 'package:bmdxf/models/gps_coordinates.dart';

abstract class MapsService {
  Future<void> openLocation(GpsCoordinates coords);
}

class GoogleMapsService implements MapsService {
  // Singleton
  GoogleMapsService._();
  static final MapsService instance = GoogleMapsService._();

  @override
  Future<void> openLocation(GpsCoordinates coords) async {
    final uri = coords.googleMapsUri;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
