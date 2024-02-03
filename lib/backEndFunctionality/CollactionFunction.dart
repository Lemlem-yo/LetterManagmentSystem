import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mezgeb_bet/backEndFunctionality/Letter.dart';

class CollectionFunction {
  List<Letter> letters = [];

  Future<void> fetchData({String? searchQuery}) async {
    String apiUrl = 'http://192.168.100.195:3000/letters';

    if (searchQuery != null) {
      apiUrl += '/search?query=$searchQuery';
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Letter> fetchedLetters = data.map((item) => Letter.fromMap(item)).toList();

      letters = fetchedLetters;
    } else {
      // Handle error
      print('Failed to load data: ${response.statusCode}');
    }
  }

  Future<List<String>> fetchNotificationsFromAPI() async {
    // Replace the URL with your API endpoint
    final response = await http
        .get(Uri.parse(''));

    if (response.statusCode == 200) {
      // Parse and return the notifications from the response
      final List<String> notifications = json.decode(response.body);
      return notifications;
    } else {
      // Handle error, e.g., by throwing an exception
      throw Exception('Failed to load notifications');
    }
  }


  void showNotificationDialog(
      BuildContext context, List<String> notifications) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications'),
          content: Column(
            children: notifications
                .map((notification) => Text(notification))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showErrorMessageDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
