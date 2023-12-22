import 'package:flutter/material.dart';
import 'package:goodspace_assignment/screens/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start the animation 1 second after the SplashScreen is displayed
    Future.delayed(Duration(seconds: 1), () {
      setState(() => _opacity = 1.0);
    });
    // Navigate to next page after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LogInPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/3.png', 
              width: 100,
              height: 100,
            ),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1), // Animation duration
              child:    Image.asset(
              'assets/4.png', 
              width: 200,
              height: 80,
            ),
            ),
          ],
        ),
      ),
    );
  }
}