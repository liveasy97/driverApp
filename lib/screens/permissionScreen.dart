import 'dart:async';
import 'package:driver_app/constants/color.dart';
import 'package:driver_app/screens/landingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

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

    if(notificationStatus.isDenied){
     await Permission.notification.request();
    }
    else if (notificationStatus.isPermanentlyDenied){
      //if notification is permanently disable then user need to move to setting and enable it from there
      openAppSettings();
    }

    if(locationStatus.isPermanentlyDenied || locationStatus.isDenied){
      await Permission.location.request();
    }

    setState(() async {
      if(locationStatus.isGranted && notificationStatus.isGranted){
        flag=true;
      }
      else{
        flag = false;
      }
    });


  }

  //First user have to allow location permission then only we can request for location always permission for android level 10 or higher application.
  void allowLocationAlways() async{
    //open dialog window

    var locationAlwaysStatus = await Permission.locationAlways.status;
    if(locationAlwaysStatus.isDenied){
      // showLocationPermissionDialog();
      await Permission.locationAlways.request();
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LandingScreen()),
      );
    }
  }

  void showLocationPermissionDialog() {
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      title: Text('Location Permission Required'),
      content: Text('Please enable location access all the time for this app to function properly.'),
      actions: [
        TextButton(
          child: Text('Open Settings'),
          onPressed: () async {
            // // Geolocator.openLocationSettings();
            // // AppSettings.openLocationSettings();
            // openAppSettings();
            // // Geolocator.openAppSettings();

            if (await Permission.location.isPermanentlyDenied || await Permission.location.isDenied) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Permission Screen", style: TextStyle(color: Colors.black),),
      ),
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Driver App collects location data to enable tracking system even when the app is closed or not in use',style: TextStyle(fontSize: 20),),
            SizedBox(height: 10,),
            Text('Please allow location all the time and other permissions for this app to function properly.',style: TextStyle(fontSize: 20),),
            SizedBox(height: 30,),
            FilledButton(
              onPressed: () {if(flag){allowLocationAlways();}
              else{checkPermissionStatus();}},
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                  padding: MaterialStateProperty.all(EdgeInsets.only(left: 80,right: 80,bottom: 20,top: 20))
              ),
              child: Text("Continue", style: TextStyle(color:Colors.black,fontSize: 20, fontWeight: FontWeight.bold, fontFamily:'montserrat' ),),
            ),
          ],
        ),
      )

    );
  }
}

