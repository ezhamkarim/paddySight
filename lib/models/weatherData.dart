class WeatherData {
  String main;
  String description;
  double temp;
  int humidity;
  dynamic wind;
  int cloud;
  String translation;

  WeatherData(
      {this.main,
      this.description,
      this.temp,
      this.humidity,
      this.wind,
      this.cloud,
      this.translation});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      main: json["weather"][0]["main"],
      description: json["weather"][0]["description"],
      temp: json["main"]["temp"] - 273,
      humidity: json["main"]["humidity"],
      wind: json["wind"]["speed"],
      cloud: json["clouds"]["all"],
    );
  }
}

class SoilData {
  double soil;

  SoilData({this.soil});

  factory SoilData.fromJson(Map<String, dynamic> json) {
    return SoilData(soil: json['moisture'] * 100);
  }
}
