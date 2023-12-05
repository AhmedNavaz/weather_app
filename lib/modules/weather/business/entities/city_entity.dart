class CityEntity {
  String name;
  final int time;
  final int timezoneOffset;
  final double lat;
  final double lon;

  CityEntity({
    required this.name,
    required this.time,
    required this.timezoneOffset,
    required this.lat,
    required this.lon,
  });
}
