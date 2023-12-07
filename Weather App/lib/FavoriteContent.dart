import 'package:flutter/material.dart';
import 'consts.dart';
import 'SearchCity.dart';
import 'weather_service.dart';

class FavoriteContent extends StatefulWidget {
  final Function(String, bool) onFavoriteChanged;
  final List<String> selectedCities;

  FavoriteContent({Key? key, required this.selectedCities, required this.onFavoriteChanged,}) : super(key: key);

  @override
  _FavoriteContentState createState() => _FavoriteContentState();
}

class _FavoriteContentState extends State<FavoriteContent> {
  late WeatherService _weatherService;

  @override
  Widget build(BuildContext context) {
    _weatherService = WeatherService(apiKey: WEATHER_API_KEY);

    return Scaffold(
      backgroundColor: Color(0xFFF3F4FB),
      appBar: AppBar(
        title: Text(
          'Favourite',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFFF3F4FB),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 40.0, top: 20.0, right: 40.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.selectedCities.length,
                itemBuilder: (context, index) {
                  String cityName = widget.selectedCities[index];
                  return _buildFavoriteItem(cityName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(String cityName) {
    return FutureBuilder(
      future: _weatherService.getWeather(cityName),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading weather data');
        } else {
          Map<String, dynamic>? weatherData = snapshot.data;
          String weatherStatus = weatherData?['current']['condition']['text'] ?? '';
          int temperature = (weatherData?['current']?['temp_c'] ?? 0).toInt();
          int wind = (weatherData?['current']?['wind_kph'] ?? 0).toInt();
          int humidity = (weatherData?['current']?['humidity'] ?? 0).toInt();

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(
                cityName,
                style: TextStyle(
                  fontFamily: 'ubuntu',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Column(
                children: [
                  Text(
                    '$weatherStatus',
                    style: TextStyle(
                      fontFamily: 'inter',
                      fontSize: 16.0,
                      color: Color(0xFF6066A6),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Wind: $wind km/h',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 14.0,
                          color: Color(0xFFA2A2BE),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Temp: $temperature℃',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 14.0,
                          color: Color(0xFFA2A2BE),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Humidity: $humidity%',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 14.0,
                          color: Color(0xFFA2A2BE),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                _onCitySelected(cityName);
              },
            ),
          );
        }
      },
    );
  }

  void _onCitySelected(String city) {
    if (city.isNotEmpty) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchCity(
              cityName: city,
              onFavoriteChanged: widget.onFavoriteChanged,
              selectedCities: widget.selectedCities,
            ),
          ),
        );
      });
    }
  }
}
