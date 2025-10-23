import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../endpoints/base_url.dart';

class GenAiService {

  // Ask TajuDN
  static Future<String?> getTajuDNChatModelAnswer(String question) async {

    // clear the previous chat before continuing
    clearSharedPreferencesStorage();

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
  }

  // get the the chat response
  static Future<String?> getAskTajuDNResponse() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("answer");
  }

  // clear shared preferences
  static Future<void> clearSharedPreferencesStorage() async{

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("answer");
  }
}
