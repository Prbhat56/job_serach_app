import 'package:flutter/material.dart';
import 'package:goodspace_assignment/screens/home_page.dart';

import 'package:goodspace_assignment/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString('auth_token') ?? '';
    return authToken.isNotEmpty ? '/home' : '/splash';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomePage(),
      },
   
      home: FutureBuilder(
        future: _getInitialRoute(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data == '/home') {
            return HomePage(); 
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
