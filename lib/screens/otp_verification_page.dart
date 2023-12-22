import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

import 'package:goodspace_assignment/constant/utilis.dart';
import 'package:goodspace_assignment/screens/home.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String deviceId;

  const OTPVerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.deviceId,
  }) : super(key: key);
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
    TextEditingController mobileController = TextEditingController(); 
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

  Future<void> _getOTP1() async {
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
    } 
  }
  void _showEditPhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double baseWidth = 400;
        double fem = MediaQuery.of(context).size.width / baseWidth;
        double ffem = fem * 0.97;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Enter Correct Phone Number',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 20 * ffem,
                  fontWeight: FontWeight.w500,
                  height: 1.2 * ffem / fem,
                  color: const Color(0xba000000),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Please be sure to select the correct area code and enter 10 digits. ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.5 * ffem / fem,
                      color: Color(0xff989ba4),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: _getOTP1,
                    child: Container(
                      // ctakQ9 (1:5683)
                      width: double.infinity,
                      height: 56 * fem,
                      decoration: BoxDecoration(
                        color: Color(0xff389fff),
                        borderRadius: BorderRadius.circular(8 * fem),
                      ),
                      child: Center(
                        child: Center(
                          child: Text(
                            'Verify Phone',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.5 * ffem / fem,
                              color: Color(0xfffafafa),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool _otpVerificationFailed = false;
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    _otpControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _verifyOTP(String otp) async {
    const String apiUrl = "https://api.ourgoodspace.com/api/d2/auth/verifyotp";
    final Map<String, dynamic> body = {
      'number': widget.phoneNumber,
      'otp': otp,
      'inviteId': null,
      'utmTracking': null,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken = prefs.getString('auth_token') ?? '';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
      'device-id': widget.deviceId,
      'device-type': "android",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        SnackBar(content: Text("User registered succesfully"));
         final responseData = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('auth_token', responseData['data']['token']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        setState(() {
          _otpVerificationFailed = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String _getConcatenatedOTP() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 300;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: _showEditPhoneDialog,
          child: Text(
            'Edit Phone number',
            textAlign: TextAlign.right,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 14 * ffem,
              fontWeight: FontWeight.w300,
              height: 1.2000000817 * ffem / fem,
              color: const Color(0xff6d6e71),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 18 * ffem,
                  fontWeight: FontWeight.w500,
                  height: 1.2000000212 * ffem / fem,
                  color: const Color(0xba000000),
                ),
                children: [
                  TextSpan(
                    text: 'OTP sent to +91 ',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 18 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.2000000212 * ffem / fem,
                      color: const Color(0xba000000),
                    ),
                  ),
                  TextSpan(
                    text: widget.phoneNumber,
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 18 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.2000000212 * ffem / fem,
                      color: const Color(0xff389fff),
                    ),
                  ),
                  TextSpan(
                    text: 'Enter OTP to confirm your phone',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 18 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.2000000212 * ffem / fem,
                      color: const Color(0xba000000),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'You’ll receive a four digit verification code. ',
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w400,
                height: 1.5 * ffem / fem,
                color: const Color(0xffc4c4c4),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => _otpDigitTextField(context, _otpControllers[index]),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 12 * ffem,
                  fontWeight: FontWeight.w400,
                  height: 1.5 * ffem / fem,
                  color: const Color(0xffc4c4c4),
                ),
                children: [
                  const TextSpan(
                    text: 'Didn\'t receive OTP?  ',
                  ),
                  TextSpan(
                    text: 'Resend',
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.5 * ffem / fem,
                      color: const Color(0xff389fff),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                String otp =
                    _getConcatenatedOTP(); // Concatenate the OTP from controllers
                _verifyOTP(
                    otp); // Pass the concatenated OTP to the verify function
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                // This will make the button full width
                minimumSize: Size(double.infinity, 36),
              ),
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpDigitTextField(
      BuildContext context, TextEditingController controller) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        // Change the border color based on whether the text field is filled
        border: Border.all(
          color: _otpVerificationFailed
              ? Colors.red
              : (controller.text.isEmpty ? Colors.blueAccent : Colors.green),
        ),
        borderRadius: BorderRadius.circular(4),
        color: controller.text.isEmpty ? Colors.white : Colors.blue,
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: "",
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
