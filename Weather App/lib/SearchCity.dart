import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'consts.dart';
import 'weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchCity extends StatefulWidget {
  final Function(String, bool) onFavoriteChanged;
  final List<String> selectedCities;
  final String cityName;

  SearchCity({
    required this.cityName,
    required this.onFavoriteChanged,
    required this.selectedCities,
  });

  @override
  _SearchCityState createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  bool isFavClicked = false;
  late WeatherService weatherService;
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(apiKey: WEATHER_API_KEY);
    fetchWeatherData(widget.cityName);
    checkIfCityIsSelected();
    saveLastSelectedCity(widget.cityName); // Save the selected city
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

  void checkIfCityIsSelected() {
    setState(() {
      isFavClicked = widget.selectedCities.contains(widget.cityName);
    });
  }

  String getWeatherImage() {
    if (weatherData == null) {
      return 'assets/weather/empty.png'; // Default image when data is not available
    }

    String weatherStatus = weatherData!['current']['condition']['text'] ?? '';
    String lowercaseCondition = weatherStatus.toLowerCase();

    if (lowercaseCondition.contains('rain') ||
        lowercaseCondition.contains('rainy') ||
        lowercaseCondition.contains('drizzle')) {
      return 'assets/weather/rainy.png';
    } else if (lowercaseCondition.contains('cloud') || lowercaseCondition.contains('cloudy')) {
      return 'assets/weather/cloudy.png';
    } else if (lowercaseCondition.contains('thunder') || lowercaseCondition.contains('thundering')) {
      return 'assets/weather/thunder.png';
    } else if (lowercaseCondition.contains('sun') || lowercaseCondition.contains('sunny')) {
      return 'assets/weather/sunny.png';
    } else {
      return 'assets/weather/def1.png';
    }
  }


  Future<void> saveLastSelectedCity(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSelectedCity', cityName);
  }

  Future<void> saveSelectedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedCities', widget.selectedCities);
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
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the previous screen
                    },
                  ),
                ),
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
                      widget.cityName,
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
                          widget.onFavoriteChanged(widget.cityName, isFavClicked);
                          saveSelectedCities();
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
                        child: Text(
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
