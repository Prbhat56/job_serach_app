import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goodspace_assignment/constant/utilis.dart';
import 'package:goodspace_assignment/screens/otp_verification_page.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController mobileController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadOrGenerateAuthToken();
  }

  Future<void> _loadOrGenerateAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');

    if (authToken == null) {
      var uuid = Uuid();
      authToken = uuid.v4(); // Generate a new UUID
      await prefs.setString('auth_token', authToken);
    }

    print('Auth Token: $authToken');
  }

  Future<void> _getOTP() async {
    const String apiUrl = "https://api.ourgoodspace.com/api/d2/auth/v2/login";
    final Map<String, dynamic> body = {
      'number': mobileController.text,
      'countryCode': '+91',
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString('auth_token') ?? '';
    var uuid = Uuid();
    String deviceId = uuid.v4();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
      'device-id': deviceId,
      'device-type':"android",
    };

    try {
      setState(() => _isLoading = true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              phoneNumber: mobileController.text,
              deviceId:deviceId,
            ),
          ),
        );
      } else {
        // Handle error response
        final data = json.decode(response.body);
        print('Error: ${data['message']}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 400;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2 * ffem / fem,
                        color: Color(0xff989ba4),
                      ),
                      children: [
                        TextSpan(
                          text: 'FIND ',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 20 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2 * ffem / fem,
                            color: Color(0xff989ba4),
                          ),
                        ),
                        TextSpan(
                          text: 'WORK',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 36 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 0.6666666667 * ffem / fem,
                            color: Color(0xff389fff),
                          ),
                        ),
                        TextSpan(
                          text: ' OPPORTUNITIES',
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 20 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2 * ffem / fem,
                            color: Color(0xff989ba4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Image.asset(
                'assets/1.png',
                height: 200,
              ),
              SizedBox(height: 200),
              RichText(
                text: TextSpan(
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 14 * ffem,
                    fontWeight: FontWeight.w300,
                    height: 1.2000000817 * ffem / fem,
                    color: Color(0xff989ba4),
                  ),
                  children: [
                    TextSpan(
                      text: 'Please enter your phone number to sign in ',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2000000817 * ffem / fem,
                        color: Color(0xff989ba4),
                      ),
                    ),
                    TextSpan(
                      text: 'GoodSpace',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2000000817 * ffem / fem,
                        color: Color(0xff389fff),
                      ),
                    ),
                    TextSpan(
                      text: ' account.',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2000000817 * ffem / fem,
                        color: Color(0xff989ba4),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Please enter mobile no.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: Image.asset('assets/2.png'),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
              SizedBox(height: 4),
              RichText(
                // youwillreceivea4digitotpvJV (1:5136)
                text: TextSpan(
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.5 * ffem / fem,
                    color: Color(0xffc4c4c4),
                  ),
                  children: [
                    TextSpan(
                      text: 'You will receive a ',
                    ),
                    TextSpan(
                      text: '4 digit OTP ',
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 12 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: Color(0xff389fff),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),
              ElevatedButton(
                onPressed:   
                _getOTP,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Get OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
