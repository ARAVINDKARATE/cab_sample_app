import 'package:cab_sample_app/views/home_view.dart';
import 'package:get/get.dart';
import '../services/aws_cognito_service.dart';

class AuthController extends GetxController {
  final AWSCognitoService _cognitoService = AWSCognitoService();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  Future<void> signUp(String phoneNumber, String password) async {
    isLoading(true);
    try {
      final result = await _cognitoService.signUp(phoneNumber, password);
      if (result != null) {
        Get.snackbar('Signup Success', 'Please confirm the OTP sent to your phone.');
        // Navigate to OTP confirmation screen
        Get.toNamed('/confirmOtp', arguments: phoneNumber);
      } else {
        Get.snackbar('Error', 'Sign up failed, please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Sign up failed: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> confirmSignUp(String phoneNumber, String otpCode) async {
    isLoading(true);
    try {
      final result = await _cognitoService.confirmSignUp(phoneNumber, otpCode);
      if (result) {
        Get.snackbar('Success', 'Your account has been confirmed. You can now log in.');
        Get.toNamed('/login');
      } else {
        Get.snackbar('Error', 'OTP confirmation failed, please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'OTP confirmation failed: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String phoneNumber, String password) async {
    isLoading(true);
    try {
      final session = await _cognitoService.login(phoneNumber, password);
      if (session != null) {
        isLoggedIn(true);
        Get.snackbar('Success', 'Login successful');
        // Navigate to Home screen after login
        Get.offAll(HomeScreen());
      } else {
        Get.snackbar('Error', 'Login failed, incorrect credentials');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    await _cognitoService.signOut();
    isLoggedIn(false);
    Get.offAllNamed('/login');
  }
}
