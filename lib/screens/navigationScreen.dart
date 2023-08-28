import 'package:driver_app/screens/landingScreen.dart';
import 'package:driver_app/screens/permissionScreen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  var prefs;
  bool firstTime = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    checkFirstTimeInstalled();
  }

  void checkFirstTimeInstalled() async {
    prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool('first_time_running') ?? true;

    if (firstTime) {
      checkPermissionStatus();
    } else {
      prefs.setBool('first_time_running', false);
      setState(() {
        loading = false;
      });
    }
  }

  void checkPermissionStatus() async {
    var notificationPermissionStatus = await Permission.notification.status;
    var locationAlwaysPermissionStatus = await Permission.locationAlways.status;

    if (notificationPermissionStatus.isGranted &&
        locationAlwaysPermissionStatus.isGranted) {
      prefs.setBool('first_time_running', false);
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const LandingScreen();
          },
        ));
      });
    } else {
      prefs.setBool('first_time_running', false);
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const PermissionScreen();
          },
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            child: Center(
            child: CircularProgressIndicator(),
          ))
        : const LandingScreen();
  }
}
