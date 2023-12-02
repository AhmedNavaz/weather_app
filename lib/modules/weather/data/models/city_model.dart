import '../../business/entities/city_entity.dart';

class CityModel extends CityEntity {
  CityModel({
    required String id,
    required String name,
    required String country,
  }) : super(
          id: id,
          name: name,
          country: country,
        );

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
    };
  }
}
