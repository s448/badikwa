import 'dart:convert';
import 'package:flutter/services.dart';

class VocabService {
  static Future<Map<String, dynamic>> loadVocab(String language) async {
    final fileName = "${language.toLowerCase()}.json"; // englisch.json etc.
    final String response = await rootBundle.loadString(
      "assets/vocabularies/$fileName",
    );
    return json.decode(response);
  }
}
