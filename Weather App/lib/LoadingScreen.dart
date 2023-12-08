import 'package:flutter/material.dart';
import 'MainScreen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: FractionalTranslation(
              translation: Offset(0, -0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/loading.png'),
                    width: 300,
                    height: 300,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 280, // Adjust the width of the LinearProgressIndicator
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.grey, // background color
                    ),
                  ),
                  FutureBuilder(
                    future: Future.delayed(Duration(seconds: 3)),//the loading duration
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // Navigation after 3 seconds
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                          );
                        });
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
