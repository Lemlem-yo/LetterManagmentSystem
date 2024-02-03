import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mezgeb_bet/adminPage/AdminMainPage.dart';
import 'package:mezgeb_bet/adminPage/screens/LetterManagementPage.dart';
import 'package:mezgeb_bet/common/AppColor.dart';
import 'package:http/http.dart' as http;
import 'package:mezgeb_bet/login_authetication_pages/accessToken.dart';
import 'package:provider/provider.dart';
class AdminLogInPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.yellow,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("LogIn", style: TextStyle(color: Colors.black, fontSize: 40)),
                    Text("Welcome to this page", style: TextStyle(color: Colors.black, fontSize: 18)),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Validate and handle login logic
                            login(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColor.yellow,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text('Login', style: TextStyle(color: AppColor.black, fontSize: 18)),
                        ),
                        SizedBox(height: 20),
                        Spacer(),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              'Copyright © 2016 E.C',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    // Add your login logic here
    String username = usernameController.text;
    String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.195:3000/users/login'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        //
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final accessToken = responseData['accessToken'];
        print('Access Token: $accessToken');
        //
        Provider.of<AccessTokenProvider>(context, listen: false).setAccessToken(accessToken);
        // Authentication successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminMainPage()),
        );
      } else {
        // Authentication failed
        _showErrorDialog(context, 'Invalid username or password. Please try again.');
      }
    } catch (e) {
      // Handle network or server errors
      print(e);
      _showErrorDialog(context, 'An error occurred. Please try again later.');
      print(e);
    }
  }

  void _showErrorDialog(BuildContext context, String s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),

          content: Text(s),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
