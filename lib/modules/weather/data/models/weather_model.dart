class WeatherModel {
  double? lat;
  double? lon;
  String? timezone;
  int? timezoneOffset;
  Current? current;
  List<Hourly>? hourly;
  List<Daily>? daily;

  WeatherModel(
      {this.lat,
      this.lon,
      this.timezone,
      this.timezoneOffset,
      this.current,
      this.hourly,
      this.daily});

  factory WeatherModel.fromJson(Map<dynamic, dynamic> json) {
    return WeatherModel(
      lat: json['lat'],
      lon: json['lon'],
      timezone: json['timezone'],
      timezoneOffset: json['timezone_offset'],
      current:
          json['current'] != null ? Current.fromJson(json['current']) : null,
      hourly: json['hourly'] != null
          ? (json['hourly'] as List)
              .map((i) => Hourly.fromJson(i))
              .toList()
              .cast<Hourly>()
          : null,
      daily: json['daily'] != null
          ? (json['daily'] as List)
              .map((i) => Daily.fromJson(i))
              .toList()
              .cast<Daily>()
          : null,
    );
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    data['timezone'] = timezone;
    data['timezone_offset'] = timezoneOffset;
    if (current != null) {
      data['current'] = current!.toJson();
    }
    if (hourly != null) {
      data['hourly'] = hourly!.map((v) => v.toJson()).toList();
    }
    if (daily != null) {
      data['daily'] = daily!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Current {
  int? dt;
  int? sunrise;
  int? sunset;
  int? temp;
  double? feelsLike;
  int? pressure;
  int? humidity;
  int? dewPoint;
  double? uvi;
  int? clouds;
  int? visibility;
  double? windSpeed;
  int? windDeg;
  double? windGust;
  List<Weather>? weather;

  Current(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
      this.windGust,
      this.weather});

  Current.fromJson(Map<dynamic, dynamic> json) {
    dt = json['dt'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    temp = json['temp'].toInt();
    feelsLike = json['feels_like'].toDouble();
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json['dew_point'].toInt();
    uvi = json['uvi'].toDouble();
    clouds = json['clouds'];
    visibility = json['visibility'];
    windSpeed = json['wind_speed'].toDouble();
    windDeg = json['wind_deg'];
    if (json['wind_gust'] != null) {
      windGust = json['wind_gust'].toDouble();
    }
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['uvi'] = uvi;
    data['clouds'] = clouds;
    data['visibility'] = visibility;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    data['wind_gust'] = windGust;
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({this.id, this.main, this.description, this.icon});

  Weather.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}

class Hourly {
  int? dt;
  int? temp;
  double? feelsLike;
  int? pressure;
  int? humidity;
  int? dewPoint;
  double? uvi;
  int? clouds;
  int? visibility;
  double? windSpeed;
  int? windDeg;
  double? windGust;
  List<Weather>? weather;
  double? pop;

  Hourly(
      {this.dt,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
      this.windGust,
      this.weather,
      this.pop});

  Hourly.fromJson(Map<dynamic, dynamic> json) {
    dt = json['dt'];
    temp = json['temp'].toInt();
    feelsLike = json['feels_like'].toDouble();
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json['dew_point'].toInt();
    uvi = json['uvi'].toDouble();
    clouds = json['clouds'];
    visibility = json['visibility'];
    windSpeed = json['wind_speed'].toDouble();
    windDeg = json['wind_deg'];
    windGust = json['wind_gust'].toDouble();
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    pop = json['pop'].toDouble();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['uvi'] = uvi;
    data['clouds'] = clouds;
    data['visibility'] = visibility;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    data['wind_gust'] = windGust;
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    data['pop'] = pop;
    return data;
  }
}

class Daily {
  int? dt;
  int? sunrise;
  int? sunset;
  int? moonrise;
  int? moonset;
  double? moonPhase;
  String? summary;
  Temp? temp;
  FeelsLike? feelsLike;
  int? pressure;
  int? humidity;
  int? dewPoint;
  double? windSpeed;
  int? windDeg;
  double? windGust;
  List<Weather>? weather;
  int? clouds;
  double? pop;
  double? uvi;

  Daily(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.moonrise,
      this.moonset,
      this.moonPhase,
      this.summary,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.windSpeed,
      this.windDeg,
      this.windGust,
      this.weather,
      this.clouds,
      this.pop,
      this.uvi});

  Daily.fromJson(Map<dynamic, dynamic> json) {
    dt = json['dt'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    moonrise = json['moonrise'];
    moonset = json['moonset'];
    moonPhase = json['moon_phase'].toDouble();
    summary = json['summary'];
    temp = json['temp'] != null ? Temp.fromJson(json['temp']) : null;
    feelsLike = json['feels_like'] != null
        ? FeelsLike.fromJson(json['feels_like'])
        : null;
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json['dew_point'].toInt();
    windSpeed = json['wind_speed'].toDouble();
    windDeg = json['wind_deg'];
    windGust = json['wind_gust'].toDouble();
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    clouds = json['clouds'];
    pop = json['pop'].toDouble();
    uvi = json['uvi'].toDouble();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['moonrise'] = moonrise;
    data['moonset'] = moonset;
    data['moon_phase'] = moonPhase;
    data['summary'] = summary;
    if (temp != null) {
      data['temp'] = temp!.toJson();
    }
    if (feelsLike != null) {
      data['feels_like'] = feelsLike!.toJson();
    }
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    data['wind_gust'] = windGust;
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    data['clouds'] = clouds;
    data['pop'] = pop;
    data['uvi'] = uvi;
    return data;
  }
}

class Temp {
  int? day;
  int? min;
  int? max;
  int? night;
  int? eve;
  int? morn;

  Temp({this.day, this.min, this.max, this.night, this.eve, this.morn});

  Temp.fromJson(Map<dynamic, dynamic> json) {
    day = json['day'].toInt();
    min = json['min'].toInt();
    max = json['max'].toInt();
    night = json['night'].toInt();
    eve = json['eve'].toInt();
    morn = json['morn'].toInt();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['min'] = min;
    data['max'] = max;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}

class FeelsLike {
  int? day;
  int? night;
  int? eve;
  int? morn;

  FeelsLike({this.day, this.night, this.eve, this.morn});

  FeelsLike.fromJson(Map<dynamic, dynamic> json) {
    day = json['day'].toInt();
    night = json['night'].toInt();
    eve = json['eve'].toInt();
    morn = json['morn'].toInt();
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['night'] = night;
    data['eve'] = eve;
    data['morn'] = morn;
    return data;
  }
}
