import 'dart:convert';

import 'package:crypto/crypto.dart';

class Hashing {
  final Hash hash;
  Hashing({required this.hash});

  /// Returns a hex-encoded hash string.
  String hashString({
    required String input, // e.g. sha256, md5, etc.
  }) {
    final bytes = utf8.encode(input); // convert to bytes
    final digest = hash.convert(bytes); // compute hash
    return digest.toString(); // hex string
  }
}
