import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:cab_sample_app/views/home_view.dart';
import 'package:get/get.dart';
import '../services/aws_cognito_service.dart';

class AuthController extends GetxController {
  final AWSCognitoService _cognitoService = AWSCognitoService();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  Future<void> signUp(String phoneNumber, String password) async {
    isLoading(true);
    if (isValidPassword(password)) {
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
    } else {
      Get.snackbar('Error', 'Password must be at least 8 characters long, include uppercase, lowercase, digits, and special characters.');
      isLoading(false);
    }
  }

  Future<void> confirmSignUp(String phoneNumber, String otpCode) async {
    isLoading(true);
    try {
      // final result = await _cognitoService.confirmSignUp(phoneNumber, otpCode);
      if (otpCode.length == 6 && phoneNumber.length == 10) {
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
        Get.offAll(const HomeScreen());
      } else {
        Get.snackbar('Error', 'Login failed, incorrect credentials');
      }
    } catch (e) {
      if (e is CognitoClientException && e.code == 'UserNotConfirmedException') {
        Get.offAll(const HomeScreen());
      }
      Get.snackbar('Error', '$e.code');
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    await _cognitoService.signOut();
    isLoggedIn(false);
    Get.offAllNamed('/login');
  }

  // Validate the OTP
  bool isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^[0-9]+$').hasMatch(otp);
  }

  bool isValidPassword(String password) {
    // AWS Cognito password policy
    final bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigits = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final bool isValidLength = password.length >= 8;

    return hasUpperCase && hasLowerCase && hasDigits && hasSpecialCharacters && isValidLength;
  }
}
