// A simple data class representing parameters for weather information.
class WeatherParams {
  // Latitude of the location
  final double lat;

  // Longitude of the location
  final double lon;

  // Name of the city
  final String cityName;

  const WeatherParams({
    required this.lat,
    required this.lon,
    required this.cityName,
  });
}
