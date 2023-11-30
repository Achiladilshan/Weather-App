// weather_service.dart
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

  Future<List<String>> getSuggestedCities(String prefix) async {
    final String apiUrl = 'https://api.weatherapi.com/v1/search.json?key=$apiKey&q=$prefix';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> suggestions = json.decode(response.body);

        if (suggestions is List) {
          return suggestions
              .map<String>((dynamic item) => _formatCityAndCountry(item))
              .toList();
        } else {
          throw Exception('Unexpected format in suggestions');
        }
      } else {
        throw Exception('Failed to load suggested cities');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  String _formatCityAndCountry(dynamic item) {
    final String city = item['name'].toString();
    final String country = item['country'].toString();

    if (country.isNotEmpty) {
      return '$city, $country';
    } else {
      return city;
    }
  }
}
