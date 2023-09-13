import 'dart:async';

import 'package:driver_app/constants/color.dart';
import 'package:driver_app/screens/landingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/spaces.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  var flag = false;

  Future<void> checkPermissionStatus() async {
    var notificationStatus = await Permission.notification.status;
    var locationStatus = await Permission.location.status;

    if (notificationStatus.isDenied) {
      await Permission.notification.request();
    } else if (notificationStatus.isPermanentlyDenied) {
      //if notification is permanently disable then user need to move to setting and enable it from there
      openAppSettings();
    }

    if (locationStatus.isPermanentlyDenied || locationStatus.isDenied) {
      await Permission.location.request();
    }

    setState(() async {
      if (locationStatus.isGranted && notificationStatus.isGranted) {
        flag = true;
      } else {
        flag = false;
      }
    });
  }

  //First user have to allow location permission then only we can request for location always permission for android level 10 or higher application.
  void allowLocationAlways() async {
    //open dialog window

    var locationAlwaysStatus = await Permission.locationAlways.status;
    if (locationAlwaysStatus.isDenied) {
      // showLocationPermissionDialog();
      await Permission.locationAlways.request();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
      );
    }
  }

  void showLocationPermissionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Location Permission Required'),
              content: Text(
                  'Please enable location access all the time for this app to function properly.'),
              actions: [
                TextButton(
                  child: Text('Open Settings'),
                  onPressed: () async {
                    // // Geolocator.openLocationSettings();
                    // // AppSettings.openLocationSettings();
                    // openAppSettings();
                    // // Geolocator.openAppSettings();

                    if (await Permission.location.isPermanentlyDenied ||
                        await Permission.location.isDenied) {
                      openAppSettings();
                      return;
                    }

                    try {
                      await MethodChannel('android_method_channel')
                          .invokeMethod('openLocationSettings');
                    } on PlatformException catch (e) {
                      print('Error opening location settings: ${e.message}');
                    }
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Positioned(
              left: space_7,
              top: space_36,
              child: Container(
                width: width * 0.8,
                height: space_37,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/permissionPageImage.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              left: space_9,
              top: height * 0.48,
              child: Text(
                'Location service is turned of.',
                style: TextStyle(
                  color: shareButtonColor,
                  fontSize: size_10,
                  fontFamily: 'Montserrat',
                  fontWeight: mediumBoldWeight,
                ),
              ),
            ),
            Positioned(
              left: space_10,
              top: height * 0.53,
              child: SizedBox(
                width: width * 0.7,
                child: Text(
                  'Turn on Location ,Driver App collects location data\nto enable tracking system.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkBlueColor,
                    fontSize: size_9,
                    fontFamily: 'Montserrat',
                    fontWeight: normalWeight,
                  ),
                ),
              ),
            ),
            Positioned(
              left: space_9,
              top: height * 0.7,
              child: SizedBox(
                width: width * 0.8,
                height: space_11,
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(darkBlueColor),
                  ),
                  onPressed: () {
                    if (flag) {
                      allowLocationAlways();
                    } else {
                      checkPermissionStatus();
                    }
                  },
                  child: Text(
                    'Enable Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: white,
                      fontSize: space_4,
                      fontFamily: 'Montserrat',
                      fontWeight: mediumBoldWeight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
