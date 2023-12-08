import 'package:flutter/material.dart';
import 'consts.dart';
import 'SearchCity.dart';
import 'weather_service.dart';

class FavoriteContent extends StatefulWidget {
  final Function(String, bool) onFavoriteChanged;
  final List<String> selectedCities;

  FavoriteContent({
    Key? key,
    required this.selectedCities,
    required this.onFavoriteChanged,
  }) : super(key: key);

  @override
  _FavoriteContentState createState() => _FavoriteContentState();
}

class _FavoriteContentState extends State<FavoriteContent> {
  late WeatherService _weatherService;

  String _getWeatherImage(String conditions) {
    conditions = conditions.toLowerCase();

    if (conditions == null) {
      return 'assets/weather/empty.png';
    }

    if (conditions.contains('thunder') || conditions.contains('thundering')) {
      return 'assets/weather/thunder.png';
    } else if (conditions.contains('rain') ||
        conditions.contains('rainy') ||
        conditions.contains('drizzle')) {
      return 'assets/weather/rainy.png';
    } else if (conditions.contains('cloud') || conditions.contains('cloudy')) {
      return 'assets/weather/cloudy.png';
    } else if (conditions.contains('sun') || conditions.contains('sunny')) {
      return 'assets/weather/sunny.png';
    } else {
      return 'assets/weather/def1.png';
    }
  }

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
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.selectedCities.length,
          itemBuilder: (context, index) {
            String cityName = widget.selectedCities[index];
            return _buildFavoriteItem(cityName);
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(String cityName) {
    return FutureBuilder(
      future: _weatherService.getWeather(cityName),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error loading weather data');
        } else {
          Map<String, dynamic>? weatherData = snapshot.data;
          String weatherStatus = weatherData?['current']['condition']['text'] ?? '';
          int temperature = (weatherData?['current']?['temp_c'] ?? 0).toInt();
          int wind = (weatherData?['current']?['wind_kph'] ?? 0).toInt();
          int humidity = (weatherData?['current']?['humidity'] ?? 0).toInt();

          String cityNameOnly = cityName.split(",")[0].trim();

          return Card(
            elevation: 5,
            margin: EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Color(0xFFFFFFFF),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Row(
                children: [
                  Text(
                    cityNameOnly,
                    style: TextStyle(
                      fontFamily: 'ubuntu',
                      fontSize: 14.0,
                      color: Color(0xFF3D394F),
                    ),
                  ),
                  // Add a space between city name and temperature
                  SizedBox(width: 8),
                ],
              ),
              subtitle: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$temperature℃',
                        style: TextStyle(
                          fontFamily: 'ubuntu',
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                      ),
                      // Align the condition image to the right
                      Image.asset(
                        _getWeatherImage(weatherStatus),
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.air, color: Color(0xFF3D394F), size: 18),
                          SizedBox(width: 4),
                          Text(
                            '$wind km/h',
                            style: TextStyle(
                              fontFamily: 'inter',
                              fontSize: 14.0,
                              color: Color(0xFF3D394F),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.opacity, color: Color(0xFF3D394F), size: 18),
                          SizedBox(width: 4),
                          Text(
                            '$humidity%',
                            style: TextStyle(
                              fontFamily: 'inter',
                              fontSize: 14.0,
                              color: Color(0xFF3D394F),
                            ),
                          ),
                        ],
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
