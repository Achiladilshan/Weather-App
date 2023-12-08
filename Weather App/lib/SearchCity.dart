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
  List<Map<String, dynamic>> forecastData = [];

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(apiKey: WEATHER_API_KEY);
    fetchWeatherData(widget.cityName);
    fetchForecastData(widget.cityName); // Call to fetch forecast data
    checkIfCityIsSelected();
    saveLastSelectedCity(widget.cityName);
  }

  Future<void> fetchForecastData(String cityName) async {
    try {
      final forecast = await weatherService.getForecast(cityName);
      setState(() {
        forecastData = forecast;
      });
    } catch (error) {
      print('Error fetching forecast data: $error');
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

  void checkIfCityIsSelected() {
    setState(() {
      isFavClicked = widget.selectedCities.contains(widget.cityName);
    });
  }

  String getWeatherImage() {
    if (weatherData == null) {
      return 'assets/weather/empty.png';
    }

    String weatherStatus = weatherData!['current']['condition']['text'] ?? '';
    String lowercaseCondition = weatherStatus.toLowerCase();

    if (lowercaseCondition.contains('rain') ||
        lowercaseCondition.contains('rainy') ||
        lowercaseCondition.contains('drizzle')) {
      return 'assets/weather/rainy.png';
    } else if (lowercaseCondition.contains('cloud') ||
        lowercaseCondition.contains('cloudy')) {
      return 'assets/weather/cloudy.png';
    } else if (lowercaseCondition.contains('thunder') ||
        lowercaseCondition.contains('thundering')) {
      return 'assets/weather/thunder.png';
    } else if (lowercaseCondition.contains('sun') ||
        lowercaseCondition.contains('sunny')) {
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

    return Material(
      child: Stack(
        children: [
          Container(
            color: Color(0xFFF3F4FB),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(left: 24.0, top: 0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
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
          Positioned(
            bottom: -470,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Image(
                  image: AssetImage('assets/images/scroll.png'),
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 22.0, top: 25.0, right: 22.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          '7-DAY FORECAST',
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 18.0,
                            color: Color(0xFF4E4771),
                          ),
                        ),
                        SizedBox(height: 15),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _buildForecastWidgets(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildForecastWidgets() {
    return forecastData.map((forecast) {
      String date = forecast['date'] ?? '';
      double minTemp = forecast['day']['mintemp_c']?.toDouble() ?? 0.0;
      double maxTemp = forecast['day']['maxtemp_c']?.toDouble() ?? 0.0;
      String conditions = forecast['day']['condition']['text'] ?? '';

      // Determine the image asset based on weather conditions
      String weatherAsset = _getWeatherAsset(conditions);

      // Extract day from the date
      String day = _getDayFromDateString(date);

      return Container(
        width: 120,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Color(0x73FFFFFF),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontFamily: 'inter',
                fontSize: 14.0,
                color: Color(0xFF564E7C),
              ),
            ),
            SizedBox(height: 4.0),
            Image.asset(weatherAsset, width: 50, height: 50),
            SizedBox(height: 4.0),
            Text(
              conditions,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'inter',
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF564E7C),
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              'Min: ${minTemp.toString()}°C',
              style: TextStyle(
                fontFamily: 'inter',
                fontSize: 14.0,
                color: Color(0xFF4E4771),
              ),
            ),
            Text(
              'Max: ${maxTemp.toString()}°C',
              style: TextStyle(
                fontFamily: 'inter',
                fontSize: 14.0,
                color: Color(0xFF4E4771),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }


  String _getDayFromDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Compare with the current date and return "Today" if it matches
    if (dateTime.year == currentDate.year &&
        dateTime.month == currentDate.month &&
        dateTime.day == currentDate.day) {
      return 'Today';
    }

    // For other dates, return the actual day (short form)
    return DateFormat('E').format(dateTime);
  }


  String _getWeatherAsset(String conditions) {

    conditions = conditions.toLowerCase();

    if (conditions == null) {
      return 'assets/weather/empty.png'; // Default image when data is not available
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

}
