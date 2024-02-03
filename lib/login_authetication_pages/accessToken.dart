import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessTokenProvider extends ChangeNotifier {
  String? _myAccessToken;

  String? get accessToken => _myAccessToken;

  AccessTokenProvider(){
    _loadToken();
  }

  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _myAccessToken = prefs.getString('accessToken');
    notifyListeners();
  }

  Future<void> setAccessToken(String? token) async {
    _myAccessToken = token;
    // Save the token to local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token ?? '');
    notifyListeners();
  }

  void clearAccessToken() async {
    _myAccessToken = 'LogedOut';
    // Clear the token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', 'LoggedOut');
    notifyListeners();
  }
}