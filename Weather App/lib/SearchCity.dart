import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'consts.dart';
import 'weather_service.dart';

class SearchCity extends StatefulWidget {
  final String cityName;

  SearchCity({required this.cityName});

  @override
  _SearchCityState createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  WeatherService weatherService = WeatherService(apiKey: WEATHER_API_KEY);
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeatherData(widget.cityName);
  }

  Future<void> fetchWeatherData(String cityName) async {
    try {
      final data = await weatherService.getWeather(cityName);
      setState(() {
        weatherData = data;
      });
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  String getWeatherImage() {
    String weatherStatus = weatherData?['current']['condition']['text'] ?? '';
    switch (weatherStatus.toLowerCase()) {
      case 'sunny':
        return 'assets/weather/sunny.png';
      case 'cloudy':
        return 'assets/weather/cloudy.png';
      case 'rain':
        return 'assets/weather/rain.png';
      default:
        return 'assets/weather/61.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(now);

    String weatherStatus = weatherData?['current']['condition']['text'] ?? '';
    int temperature = (weatherData?['current']?['temp_c'] ?? 0).toInt();
    int wind = (weatherData?['current']?['wind_kph'] ?? 0).toInt();
    int humidity = (weatherData?['current']?['humidity'] ?? 0).toInt();

    return Scaffold(
      backgroundColor: Color(0xFFF3F4FB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24.0, top: 25.0, right: 24.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today, $formattedDate',
                  style: TextStyle(
                    fontFamily: 'ubuntu',
                    fontSize: 14.0,
                    color: Color(0xFFA1A1A4),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/icons/location.png'),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${widget.cityName}',
                      style: TextStyle(
                        fontFamily: 'ubuntu',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Image(
                          image: AssetImage(getWeatherImage()),
                          width: 281,
                          height: 342,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -70),
                        child: Text(
                          '$weatherStatus',
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 24.0,
                            color: Color(0xFF6066A6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -35),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Wind',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 16.0,
                                color: Color(0xFFA2A2BE),
                              ),
                            ),
                            Text(
                              '$wind km/h',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/icons/line.png'),
                        ),
                        SizedBox(width: 25),
                        Column(
                          children: [
                            Text(
                              'Temp',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 16.0,
                                color: Color(0xFFA2A2BE),
                              ),
                            ),
                            Text(
                              '$temperature℃',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 25),
                        Image(
                          image: AssetImage('assets/icons/line.png'),
                        ),
                        SizedBox(width: 25),
                        Column(
                          children: [
                            Text(
                              'Humidity',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 16.0,
                                color: Color(0xFFA2A2BE),
                              ),
                            ),
                            Text(
                              '$humidity%',
                              style: TextStyle(
                                fontFamily: 'inter',
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
