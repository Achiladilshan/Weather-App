import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'consts.dart';
import 'weather_service.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isFavClicked = false;
  late WeatherService weatherService;
  Map<String, dynamic>? weatherData;


  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(apiKey: WEATHER_API_KEY);
    fetchWeatherData('Colombo'); // Initial city name, replace with the desired city
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
    // Map weather status to image asset
    String weatherStatus = weatherData?['current']['condition']['text'] ?? '';
    switch (weatherStatus.toLowerCase()) {
      case 'sunny':
        return 'assets/weather/sunny.png';
      case 'cloudy':
        return 'assets/weather/cloudy.png';
      case 'rain':
        return 'assets/weather/rain.png';
    // Add more cases for other weather conditions
      default:
        return 'assets/weather/61.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime now = DateTime.now();

    double deviceWidth = MediaQuery.of(context).size.width;

    // Format the date using the intl package
    String formattedDate = DateFormat('dd MMM yyyy').format(now);

    String weatherStatus = weatherData?['current']['condition']['text'] ?? '';
    int temperature = (weatherData?['current']?['temp_c'] ?? 0).toInt();
    int wind = (weatherData?['current']?['wind_kph'] ?? 0).toInt();
    int humidity = (weatherData?['current']?['humidity'] ?? 0).toInt();
    print('$temperature');
    print('$wind');
    print('$humidity');

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
                      'Colombo, Sri Lanka',
                      style: TextStyle(
                        fontFamily: 'ubuntu',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavClicked = !isFavClicked;
                        });
                      },
                      child: Image(
                        image: AssetImage(
                          isFavClicked
                              ? 'assets/icons/add-fav-red.png'
                              : 'assets/icons/add-fav.png',
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Transform.translate(
                      offset: const Offset(0, -30),
                      child: Image(
                          image: AssetImage(getWeatherImage()), // Dynamically change weather image
                          width: 281,
                          height: 342,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -70),
                        child:Text(
                          '${weatherStatus}',
                          textAlign: TextAlign.center,
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
                  child:Center(
                    child:Row(
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
                              'Humidit',
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
