import 'package:flutter/material.dart';
import 'package:mezgeb_bet/adminPage/AdminMainPage.dart';
import 'package:mezgeb_bet/adminPage/screens/AttachmentPage.dart';
import 'package:mezgeb_bet/adminPage/screens/OutgoingLetter.dart';
import 'package:mezgeb_bet/login_authetication_pages/AdminLogInPage.dart';
import 'package:mezgeb_bet/login_authetication_pages/accessToken.dart';
import 'package:mezgeb_bet/staffPageScreens/StaffMainPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  Widget initialPage;

  if (accessToken != null && accessToken.isNotEmpty) {
    // User is logged in
    initialPage = AdminMainPage(); // or StaffMainPage() based on your logic
  } else {
    // User is not logged in
    initialPage = AdminLogInPage();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccessTokenProvider()),
        // Add other providers if needed
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: initialPage,
      ),
    ),
  );
}
