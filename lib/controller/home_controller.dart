// import 'package:flutter_map/flutter_map.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class HomeController extends GetxController {
//   var currentPosition = LatLng(0, 0).obs;
//   var destinationPosition = Rxn<LatLng>();
//   var showConfirmBookingButton = false.obs;
//   late MapController mapController;

//   @override
//   void onInit() {
//     super.onInit();
//     mapController = MapController();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.snackbar("Permission Denied", "Location access is denied.");
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       Get.snackbar("Permission Denied Forever", "Please enable location permissions in the app settings.");
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     currentPosition.value = LatLng(position.latitude, position.longitude);
//     mapController.move(currentPosition.value, 14);
//   }

//   Future<void> locateDestination(String destination) async {
//     try {
//       List<Location> locations = await locationFromAddress(destination);
//       if (locations.isNotEmpty) {
//         destinationPosition.value = LatLng(locations.first.latitude, locations.first.longitude);
//         mapController.move(destinationPosition.value!, 14);
//         showConfirmBookingButton.value = true;
//       } else {
//         Get.snackbar("Location Not Found", "Unable to locate the destination.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Could not find any result for the supplied address.");
//     }
//   }
// }
