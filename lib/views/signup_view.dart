import 'package:cab_sample_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              maxLength: 10,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        String phone = phoneNumberController.text.trim();
                        String password = passwordController.text.trim();

                        // Validate input
                        if (phone.isEmpty || password.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please enter both phone number and password.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red[300],
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // Validate phone number length
                        if (phone.length != 10) {
                          Get.snackbar(
                            'Error',
                            'Phone number must be 10 digits.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red[300],
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // Proceed with sign up
                        authController.signUp(phone, password);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue[700], // Button text color
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // Rounded corners
                        ),
                      ),
                      child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
