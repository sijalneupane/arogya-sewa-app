import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

/// Global Khalti Checkout Configuration
/// 
/// Centralized configuration for Khalti payment gateway.
/// Used throughout the app for all payment operations.
/// 
/// This can be initialized with environment variables or use fallback values.
class KhaltiCheckoutConfig {
  // Replace this fallback key with your own test key, or pass via --dart-define.
  static const String publicKey = String.fromEnvironment(
    'KHALTI_PUBLIC_KEY',
    defaultValue: '23c9fbb8811d4673906062b0c71f8198',
  );

  static const Environment environment = Environment.test;
  static const bool enableDebugLogs = true;

  /// Prevents instantiation
  KhaltiCheckoutConfig._();
}
