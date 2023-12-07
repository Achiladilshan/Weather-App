import 'package:flutter/material.dart';
import 'consts.dart';
import 'weather_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContent extends StatefulWidget {
  final Function(String, bool) onFavoriteChanged;
  final List<String> selectedCities;

  HomeContent({Key? key, required this.onFavoriteChanged, required this.selectedCities})
      : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isFavClicked = false;
  late WeatherService weatherService;
  Map<String, dynamic>? weatherData;
  String lastSelectedCity = 'colombo';

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(apiKey: WEATHER_API_KEY);
    fetchLastSelectedCity();
  }

  Future<void> fetchLastSelectedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastSelectedCity = prefs.getString('lastSelectedCity') ?? '';
      isFavClicked = widget.selectedCities.contains(lastSelectedCity);
    });

    if (lastSelectedCity.isNotEmpty) {
      fetchWeatherData(lastSelectedCity);
    }
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
    if (weatherData == null) {
      return 'assets/weather/empty.png'; // Default image when data is not available
    }

    String weatherStatus = weatherData!['current']['condition']['text'] ?? '';
    String lowercaseCondition = weatherStatus.toLowerCase();

    if (lowercaseCondition.contains('thunder') || lowercaseCondition.contains('thundering')) {
      return 'assets/weather/thunder.png';
    } else if (lowercaseCondition.contains('rain') ||
        lowercaseCondition.contains('rainy') ||
        lowercaseCondition.contains('drizzle')) {
      return 'assets/weather/rainy.png';
    } else if (lowercaseCondition.contains('cloud') || lowercaseCondition.contains('cloudy')) {
      return 'assets/weather/cloudy.png';
    } else if (lowercaseCondition.contains('sun') || lowercaseCondition.contains('sunny')) {
      return 'assets/weather/sunny.png';
    } else if (lowercaseCondition.contains('')) {
      return 'assets/weather/empty.png'; // Please clarify what this condition is supposed to represent
    } else {
      return 'assets/weather/def1.png';
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
                    Text(
                      lastSelectedCity,
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
                          widget.onFavoriteChanged(lastSelectedCity, isFavClicked);
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
                          image: AssetImage(getWeatherImage()),
                          width: 281,
                          height: 342,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -70),
                        child: Text(
                          '$weatherStatus',
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
