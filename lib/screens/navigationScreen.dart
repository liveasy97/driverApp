import 'package:driver_app/screens/landingScreen.dart';
import 'package:driver_app/screens/permissionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NavigationScreen extends StatefulWidget{
  const NavigationScreen({super.key});


  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>{

  bool navigateFlag = false;

  @override
  void initState() {
    super.initState();

    checkPermissionStatus();
  }
  void checkPermissionStatus() async {
    var notificationPermissionStatus = await Permission.notification.status;
    var locationAlwaysPermissionStatus = await Permission.locationAlways.status;

    if(notificationPermissionStatus.isGranted && locationAlwaysPermissionStatus.isGranted){
        navigateFlag = true;
    }

  }

  @override
  Widget build(BuildContext context) {
    if(navigateFlag){
      // Navigator.push(context, MaterialPageRoute(builder: (context) => const LandingScreen()));
      return const LandingScreen();
    }
    else{
      return const PermissionScreen();
    }
  }

}
