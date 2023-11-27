import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'consts.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isFavClicked = false;
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName("Madrid").then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime now = DateTime.now();

    // Format the date using the intl package
    String formattedDate = DateFormat('dd MMM yyyy').format(now);

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
                  // Adjust the spacing between text and images
                  children: [
                    Image(
                      image: AssetImage('assets/icons/location.png'),
                    ),
                    SizedBox(width: 8), // Adjust the spacing as needed
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
                              ? 'assets/icons/add-fav-red.png' // Red color image
                              : 'assets/icons/add-fav.png', // Default image
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center( // Center widget to center the sunny image
                  child: Image(
                    image: AssetImage('assets/weather/sunny.png'),
                    width: 281,
                    height: 342,
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
