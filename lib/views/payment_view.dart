import 'package:cab_sample_app/controller/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class PaymentScreen extends StatelessWidget {
  final String cabType;
  final LatLng currentLocation;
  final String destinationLocation;

  const PaymentScreen({
    super.key,
    required this.cabType,
    required this.currentLocation,
    required this.destinationLocation,
  });

  @override
  Widget build(BuildContext context) {
    final paymentController = PaymentController(); // Create an instance of the controller

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: paymentController.formKey, // Use the controller's form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_car, color: Colors.blueAccent),
                            const SizedBox(width: 10),
                            Text(
                              'Cab Type: $cabType',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 20, thickness: 1),
                        Row(
                          children: [
                            Icon(Icons.my_location, color: Colors.blueAccent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Current Location: (${currentLocation.latitude.toStringAsFixed(3)}, ${currentLocation.longitude.toStringAsFixed(3)})',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blueAccent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Destination: $destinationLocation',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: paymentController.cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    prefixIcon: Icon(Icons.credit_card),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: paymentController.validateCardNumber,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: paymentController.expiryDateController,
                        decoration: InputDecoration(
                          labelText: 'Expiration Date',
                          hintText: 'MM/YY',
                          prefixIcon: Icon(Icons.date_range),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: paymentController.validateExpiryDate,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: paymentController.cvvController,
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: paymentController.validateCVV,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (paymentController.formKey.currentState!.validate()) {
                        // Show snackbar only if all inputs are valid
                        Get.snackbar('Payment Successful', 'Your ride has been confirmed.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm Payment',
                      style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 35, 33, 33)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
