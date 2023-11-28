import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.weatherapi.com/v1/current.json';

  WeatherService({required this.apiKey});

  Future<Map<String, dynamic>> getWeather(String cityName) async {
    final String apiUrl = '$baseUrl?key=$apiKey&q=$cityName';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<Map<String, dynamic>> getWeatherByLocation(double latitude, double longitude) async {
    final String apiUrl = '$baseUrl?key=$apiKey&q=$latitude,$longitude';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
