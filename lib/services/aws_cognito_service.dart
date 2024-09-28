import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // For secure token storage

class AWSCognitoService {
  final String userPoolId = 'ap-south-1_UNbYGfFWE';
  final String clientId = '50a628bpfbtvjjm9pe5k86livg';

  final userPool = CognitoUserPool(
    'ap-south-1_UNbYGfFWE',
    '50a628bpfbtvjjm9pe5k86livg',
  );

  // FlutterSecureStorage for securely storing tokens
  final storage = const FlutterSecureStorage();

  // Helper method to format the phone number in E.164 format
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('+')) {
      return phoneNumber; // Already in E.164 format
    }
    // Add country code manually (for example, for India)
    return '+91$phoneNumber'; // Ensure the phone number has the country code
  }

  // Sign-up method using phone number and password
  Future<CognitoUser?> signUp(String phoneNumber, String password) async {
    try {
      // Format phone number to E.164 format
      String formattedPhoneNumber = formatPhoneNumber(phoneNumber);

      // Sign up using formatted phone number and password
      final signUpResult = await userPool.signUp(
        formattedPhoneNumber, // Ensure E.164 format is used
        password,
      );
      return signUpResult.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Confirm sign-up with code received via SMS
  Future<bool> confirmSignUp(String phoneNumber, String confirmationCode) async {
    String formattedPhoneNumber = formatPhoneNumber(phoneNumber);
    final cognitoUser = CognitoUser(formattedPhoneNumber, userPool);

    try {
      final result = await cognitoUser.confirmRegistration(confirmationCode);
      return result;
    } catch (e) {
      print('Error confirming sign-up: $e');
      return false;
    }
  }

  // Login method to authenticate users using phone number and password
  Future<CognitoUserSession?> login(String phoneNumber, String password) async {
    String formattedPhoneNumber = formatPhoneNumber(phoneNumber);
    final cognitoUser = CognitoUser(formattedPhoneNumber, userPool);
    final authDetails = AuthenticationDetails(
      username: formattedPhoneNumber,
      password: password,
    );

    try {
      final session = await cognitoUser.authenticateUser(authDetails);
      await storage.write(key: 'accessToken', value: session?.accessToken.jwtToken); // Store token securely
      return session;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Sign-out and clear stored tokens
  Future<void> signOut() async {
    await storage.delete(key: 'accessToken');
  }

  // Check if user is logged in by verifying stored token
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'accessToken');
    return token != null;
  }
}
