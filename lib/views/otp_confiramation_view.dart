import 'package:cab_sample_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpConfirmationScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the phone number passed from the signup screen
    final phoneNumber = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Confirm OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            SizedBox(height: 20),
            Obx(() {
              return authController.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        String otp = otpController.text.trim();
                        authController.confirmSignUp(phoneNumber, otp);
                      },
                      child: Text('Confirm OTP'),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
