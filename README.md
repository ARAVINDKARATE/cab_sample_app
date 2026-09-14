# Cab Booking — Flutter

A ride-booking demo covering the parts that are usually hand-waved: real identity
provider auth, secure token storage, and live location on a map.

## Features

- **Signup → OTP confirmation → login** against **AWS Cognito**
  (`amazon_cognito_identity_dart_2`) — not a mocked auth screen
- Tokens held in `flutter_secure_storage` (Keychain / EncryptedSharedPreferences),
  not `SharedPreferences`
- Live user location (`geolocator`) plotted on an OpenStreetMap-backed
  `flutter_map`, with reverse geocoding to addresses (`geocoding`)
- Payment screen flow

## Structure

```
lib/
├── controller/    auth_controller · home_controller · payment_controller
├── services/aws_cognito_service.dart
├── models/user_model.dart
└── views/         login · signup · otp_confiramation · home · payment
```

## State management

**GetX** (`get`) — controllers own state and are bound to views reactively.

## Setup

Point the app at your own Cognito user pool in `lib/services/aws_cognito_service.dart`
(user pool ID + client ID), then:

```bash
flutter pub get
flutter run
```

Location features need runtime permission on device; the map will stay centred on
a default until permission is granted.

## Stack

Flutter · Dart · get · amazon_cognito_identity_dart_2 · flutter_secure_storage · flutter_map · geolocator · geocoding · latlong2
