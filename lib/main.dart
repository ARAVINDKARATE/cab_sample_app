import 'package:cab_sample_app/views/home_view.dart';
import 'package:cab_sample_app/views/login_view.dart';
import 'package:cab_sample_app/views/otp_confiramation_view.dart';
import 'package:cab_sample_app/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uber Clone',
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/todo', page: () => LoginScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignupScreen()),
        GetPage(name: '/confirmOtp', page: () => OtpConfirmationScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
      ],
    );
  }
}
