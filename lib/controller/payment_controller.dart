import 'package:flutter/material.dart';

class PaymentController {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // Regular expression to validate card number (Basic Luhn validation can be added later)
  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your card number';
    } else if (value.length < 16) {
      return 'Card number must be 16 digits';
    }
    return null;
  }

  // Regular expression to validate expiry date format MM/YY
  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiry date';
    } else if (!RegExp(r"^(0[1-9]|1[0-2])\/?([0-9]{2})$").hasMatch(value)) {
      return 'Enter a valid expiry date (MM/YY)';
    }
    return null;
  }

  // Validating CVV (Typically 3 digits)
  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV';
    } else if (value.length != 3) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  // Getter for form key
  GlobalKey<FormState> get formKey => _formKey;

  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
  }
}
