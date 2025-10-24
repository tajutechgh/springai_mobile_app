import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../endpoints/base_url.dart';

class GenAiService {

  // Ask TajuDN
  static Future<String?> getTajuDNChatModelAnswer(String question) async {

    // clear the previous data before continuing
    clearChatSharedPreferencesStorage();

    final response = await http.get(

      Uri.parse(BaseUrl.getAskTajuDNChatModel(question)),

      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
      },

    );

    if (response.statusCode == 200) {
      
      final outputData = response.body;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("answer",  outputData);

    } else {

      if (kDebugMode) {
        print('Error: Status Code ${response.statusCode} - ${response.body}');
      }

      throw Exception('API error ${response.statusCode}: ${response.body}');
    }

    return null;
  }

  // get the the chat response
  static Future<String?> getAskTajuDNResponse() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("answer");
  }

  // clear chat shared preferences
  static Future<void> clearChatSharedPreferencesStorage() async{

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("answer");
  }

  // Generate images from description and store as Base64 list in SharedPreferences
  static Future<void> getGenerateImageModelResponse(String description, int numberOfImages) async {

    // Clear previous images
    await clearImagesSharedPreferencesStorage();

    List<String> base64Images = [];

    for (int i = 0; i < numberOfImages; i++) {

      final response = await http.get(

        Uri.parse(BaseUrl.getGenerateImageModel(description, i + 1)),

        headers: {

          'Accept': 'image/png',
        },
      );

      if (response.statusCode == 200) {

        final base64String = base64Encode(response.bodyBytes);

        base64Images.add(base64String);

      } else {

        if (kDebugMode) {

          print('Error: ${response.statusCode} - ${response.body}');

        }

        throw Exception('API error ${response.statusCode}');
      }
    }

    // Store all images as JSON array
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("images", jsonEncode(base64Images));

    if (kDebugMode) print('Images saved successfully.');
  }

  // Retrieve images from SharedPreferences as list of Uint8List
  static Future<List<Uint8List>> getGeneratedImagesResponse() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString("images");

    if (data == null) return [];

    final List<dynamic> list = jsonDecode(data);

    return list.map((exception) => base64Decode(exception as String)).toList();
  }

  // Clear stored images
  static Future<void> clearImagesSharedPreferencesStorage() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("images");

    if (kDebugMode) print('Images cleared.');
  }
}
