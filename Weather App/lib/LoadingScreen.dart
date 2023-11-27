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
      backgroundColor: Color(0xFFB8ADF0),
      body: SafeArea(
        child: FractionalTranslation(
          translation: Offset(0, -0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Image(
                  image: AssetImage('assets/images/loading.png'),
                  width: 390,
                  height: 390,
                ),
              SizedBox(height: 10),
              Container(
                width: 280, // Adjust the width of the LinearProgressIndicator
                child: LinearProgressIndicator(),
              ),
              FutureBuilder(
                future: Future.delayed(Duration(seconds: 3)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Navigation after 3 seconds
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
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
    );

  }
}
