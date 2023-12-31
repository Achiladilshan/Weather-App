import 'package:flutter/material.dart';
import 'SearchCity.dart';
import 'consts.dart';
import 'weather_service.dart';

class SearchContent extends StatefulWidget {
  final Function(String, bool) onFavoriteChanged;//store favicon clicked or not
  final List<String> selectedCities;//store favorite cities list

  SearchContent({required this.onFavoriteChanged, required this.selectedCities});

  @override
  _SearchContentState createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  final TextEditingController _searchController = TextEditingController();
  WeatherService _weatherService = WeatherService(apiKey: WEATHER_API_KEY);
  List<String> _suggestedCities = [];//store sugessted cities
  String _selectedCity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4FB),
      appBar: AppBar(
        title: Text(
          'Search for city',
          style: TextStyle(fontFamily: 'Ubuntu', fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFFF3F4FB),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 40.0, top: 20.0, right: 40.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchTextChanged,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15.0),
                  prefixIcon: Image.asset(
                    'assets/icons/search.png',
                    width: 30.0,
                    height: 30.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _buildSuggestedCities(),
          ],
        ),
      ),
    );
  }

  //when typing search cities form the phrase
  void _onSearchTextChanged(String input) {
    if (input.length >= 1) {
      _weatherService.getSuggestedCities(input).then((suggestions) {
        suggestions.sort();

        setState(() {
          _suggestedCities = suggestions.take(5).toList();
        });
      });
    } else {
      setState(() {
        _suggestedCities.clear();
      });
    }
  }

  Widget _buildSuggestedCities() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _suggestedCities.map((cityAndCountry) {
          List<String> parts = cityAndCountry.split(', ');

          return Column(
            children: [
              ListTile(
                title: Text(
                  parts[0],
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                subtitle: Text(
                  parts.length > 1 ? parts[1] : '',
                  style: TextStyle(color: Color(0xFF878787)),
                ),
                onTap: () {
                  _onCitySelected(cityAndCountry);
                },
              ),
              Divider(
                color: Color(0xFFe0e0eb),
                height: 1,
                indent: 10,
                endIndent: 10,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _onCitySelected(String cityAndCountry) {
    if (cityAndCountry.isNotEmpty) {
      setState(() {
        _selectedCity = cityAndCountry;
        _suggestedCities.clear();
        _searchController.clear();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchCity(
              cityName: cityAndCountry,
              onFavoriteChanged: widget.onFavoriteChanged,
              selectedCities: widget.selectedCities,
            ),
          ),
        );
      });
    }
  }
}
