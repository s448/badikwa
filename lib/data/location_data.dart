class LocationService {
  Future<Location> getCurrentLocation() async {
    // قم هنا باستخدام حزمة تحديد الموقع لجلب الموقع الحالي
    // على سبيل المثال باستخدام `geolocator` أو أي خدمة مفضلة لك.
    return Location(latitude: 30.033, longitude: 31.235); // موقع افتراضي
  }

  Future<Location> updateLocation(double latitude, double longitude) async {
    // قم هنا بتحديث الموقع في حال كان لديك خوارزمية أو API
    return Location(latitude: latitude, longitude: longitude);
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});
}
