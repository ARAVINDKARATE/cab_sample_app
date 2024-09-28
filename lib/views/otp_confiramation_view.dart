import 'package:cab_sample_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpConfirmationScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController otpController = TextEditingController();

  OtpConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the phone number passed from the signup screen
    final phoneNumber = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter the 6-digit OTP sent to your phone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
                counterText: '', // Hide the counter text
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        String otp = otpController.text.trim();
                        if (authController.isValidOtp(otp)) {
                          authController.confirmSignUp(phoneNumber, otp);
                        } else {
                          Get.snackbar(
                            "Invalid OTP",
                            "Please enter a valid 6-digit number.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red[300],
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 59, 53, 53), backgroundColor: Colors.blue[100], padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // Rounded corners
                        ),
                      ),
                      child: const Text('Confirm OTP', style: TextStyle(fontSize: 16)),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
