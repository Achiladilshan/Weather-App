import 'package:flutter/material.dart';

import 'FavoriteContent.dart';
import 'HomeContent.dart';
import 'SearchContent.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          _getBody(),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Container(
                width: deviceWidth,
                height: 70 + MediaQuery.of(context).padding.bottom, // Adjusted height
                color: Colors.white,
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: _buildIcon('assets/icons/home.png', 0),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildIcon('assets/icons/search.png', 1),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: _buildIcon('assets/icons/fav.png', 2),
                      label: '',
                    ),
                  ],
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white, // Add this line
                  selectedLabelStyle: TextStyle(height: 0), // Adjust the line height
                  unselectedLabelStyle: TextStyle(height: 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return HomeContent();
      case 1:
        return SearchContent();
      case 2:
        return FavoriteContent();
      default:
        return Container();
    }
  }

  Widget _buildIcon(String imagePath, int index) {
    return Center(
        child: Image.asset(
          imagePath,
          color: _currentIndex == index ? Colors.black : Color(0xFF979797),
        ),
    );
  }
}
