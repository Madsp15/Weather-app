import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:weatherapp/models/models.dart';
import 'package:http/http.dart' as http;

import 'models/time_series.dart';

abstract class DataSource{
  Future<WeeklyForecastDto>getWeeklyForecast();
  Future<WeatherChartData> getChartData();
}

class FakeDataSource implements DataSource{
  @override
  Future<WeeklyForecastDto>getWeeklyForecast() async{
    final json = await rootBundle.loadString('assets/weekly_forecast.json');
    return WeeklyForecastDto.fromJson(jsonDecode(json));
  }
  @override
  Future<WeatherChartData> getChartData() async {
    final json = await rootBundle.loadString("assets/chart_data.json");
    return WeatherChartData.fromJson(jsonDecode(json));
  }
}

class RealDataSource implements DataSource{
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final location = await Location.instance.getLocation();
    final apiUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&daily=weather_code,temperature_2m_max,temperature_2m_min&wind_speed_unit=ms&timezone=Europe%2FBerlin';
    final response = await http.get(Uri.parse(apiUrl));
    return WeeklyForecastDto.fromJson(jsonDecode(response.body));
  }
  @override
  Future<WeatherChartData> getChartData() async {
    final location = await Location.instance.getLocation();
    final apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&hourly=temperature_2m&daily=apparent_temperature_max,apparent_temperature_min&timezone=Europe%2FBerlin";
    final response = await http.get(Uri.parse(apiUrl));
    return WeatherChartData.fromJson(jsonDecode(response.body));
  }

}