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
  List<Map<String, dynamic>> forecastData = [];

  String lastSelectedCity = 'colombo'; //when open first time colombo weather shown

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService(apiKey: WEATHER_API_KEY);
    fetchSelectedCities();
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
      fetchForecastData(lastSelectedCity);
    }
  }

  Future<void> fetchSelectedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedSelectedCities = prefs.getStringList('selectedCities') ?? [];
    widget.selectedCities.clear(); // Clear the existing list
    widget.selectedCities.addAll(storedSelectedCities); // add cities to the list from the history
  }

  Future<void> saveSelectedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedCities', widget.selectedCities);
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

  //load weather image
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

    return Stack(
      children: [
        Scaffold(
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
          ),
        ),
        Positioned(
          bottom: -420,
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
              'Min: $minTemp°C',
              style: TextStyle(
                fontFamily: 'inter',
                fontSize: 14.0,
                color: Color(0xFF4E4771),
              ),
            ),
            Text(
              'Max: $maxTemp°C',
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