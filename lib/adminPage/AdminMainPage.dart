import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgeb_bet/adminPage/widgets/Cards.dart';
import 'package:mezgeb_bet/backEndFunctionality/CollactionFunction.dart';
import 'package:mezgeb_bet/common/AppColor.dart';
import 'package:mezgeb_bet/login_authetication_pages/AdminLogInPage.dart';
import 'package:mezgeb_bet/login_authetication_pages/accessToken.dart';
import 'package:provider/provider.dart';


class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int notificationCount = 0;
  CollectionFunction collectionFunction = CollectionFunction();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 2,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    color: AppColor.black,
                    onPressed: () {
                      // Add your API request logic here
                      collectionFunction.fetchNotificationsFromAPI().then((notifications) {
                        setState(() {
                          notificationCount = notifications.length;
                        });
                        // Display notifications or perform other actions based on the API response
                        collectionFunction.showNotificationDialog(context, notifications);
                      }).catchError((error) {
                        // Handle error, e.g., show an error message
                        collectionFunction.showErrorMessageDialog(
                            context, 'Failed to fetch notifications');
                      });
                    },
                  ),
                  Positioned(
                    top:
                    12.0, // Adjust this value to position the badge vertically
                    right:
                    12.0, // Adjust this value to position the badge horizontally
                    child: Badge(
                      label: Text(
                        notificationCount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor:  AppColor.white,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColor.yellow,
                ),
                padding: const EdgeInsets.only(bottom: 0, top: 30),
                child: Column(
                  children:  [
                    CircleAvatar(
                      foregroundImage: AssetImage("assets/logo.jpg"),
                      maxRadius: 50,
                    ),
                    Center(
                      child: Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          color: AppColor.black,
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children:  [
                  ListTile(
                    leading: Icon(Icons.file_copy_sharp),
                    title: Text(
                      "Files",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.inbox),
                    title: Text(
                      "Incoming letter",
                      style: TextStyle(fontWeight: FontWeight.w700,),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.outbox),
                    title: Text(
                      "Outgoing letter",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.chat),
                    title: Text(
                      "Chat",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(
                      "Logout",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onTap: () {
                      _handleLogout(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: AppColor.white,
        body: Column(
            children: [
              Expanded(
                child: Cards()
              ),
            ],
          ),

      ),
    );
  }
  void _handleLogout(BuildContext context) {
    // Access the provider and call the clearAccessToken method
    try {
      print('Logging out...');
      Provider.of<AccessTokenProvider>(context, listen: false).clearAccessToken();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminLogInPage()),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}

