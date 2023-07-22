import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricRegistration {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if biometric authentication is available on the device.
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      print('Error checking biometrics availability: $e');
      return false;
    }
  }

  // Prompt the user to set up biometric authentication on their device.
  Future<bool> registerBiometrics(BuildContext context) async {
    try {
      if (await isBiometricAvailable()) {
        final didFingerprintChange = await _localAuth.authenticate(
          localizedReason: 'AOVIPOS will check your register.',
          // useErrorDialogs: true,
          // stickyAuth: true,
        );
        print(didFingerprintChange);
        return didFingerprintChange;
      } else {
        return false;
      }
    } catch (e) {
      print('Error registering biometrics: $e');
      return false;
    }
  }


  
}
