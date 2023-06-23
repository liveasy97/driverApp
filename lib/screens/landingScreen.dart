import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:driver_app/screens/permissionScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http ;
import 'package:driver_app/constants/color.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../functions/trasnporterApis/runTransporterApiPost.dart';

class LandingScreen extends StatefulWidget{
  const LandingScreen({super.key});
  @override
  _LandingScreenState createState() => _LandingScreenState();

}

class _LandingScreenState extends State<LandingScreen>{
  @override
  void initState(){
    super.initState();

    var firebaseId = FirebaseAuth.instance.currentUser?.uid;
    // var transporterId = tidstorage.read("transporterId");
    var mobileNum = tidstorage.read("mobileNum");

    firebaseId ??= "1234567890";
    mobileNum ??= "default";

    permissionChecking(firebaseId, mobileNum);

  }

  void permissionChecking(String firebaseId, String mobileNum) async {
    var locationStatus = await Permission.locationAlways.status;
    var notificationStatus = await Permission.notification.status;
    if(locationStatus.isDenied || notificationStatus.isDenied){
      //move to permission screen
      showDialogToMovePermission();
    }
    else{
      print("$firebaseId $mobileNum");
      addDevice(firebaseId, mobileNum);
      backgroundService();

    }
  }

  void showDialogToMovePermission(){
    showDialog(context: context,
      builder: (BuildContext context) => AlertDialog(
      title: Text('Some Permission Required'),
      content: Text('Please enable location and other permissions for this app to function properly.'),
      actions: [
        TextButton(
          child: Text('Open Settings'),
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PermissionScreen()));
          },
        ),
      ],
    ),);
  }
  
  static Future<void> addDevice(String sid, String sname) async {
    String? addDeviceUrl = "${FlutterConfig.get("traccarApi")}/devices";

    final url = Uri.parse(
        addDeviceUrl);

    String? username = "${FlutterConfig.get("traccarUser")}", password = "${FlutterConfig.get("traccarPass")}";

    final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final body = {
      "name": sname,
      "uniqueId": sid
    };

    final rsp = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (rsp.statusCode == 200) {
      print('Post successful: $rsp.body');
    } else {
      print('Error: ${rsp.statusCode}');
      print(rsp.body);
    }

  }

  Future<void> backgroundService() async {
    final service = FlutterBackgroundService();
    await service.configure(iosConfiguration: IosConfiguration(), androidConfiguration: AndroidConfiguration(
        onStart: onStart, isForegroundMode: true, autoStart: true));

  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    await Firebase.initializeApp();
    print("start");
    DartPluginRegistrant.ensureInitialized();
    if(service is AndroidServiceInstance){
      service.setAsForegroundService();
      print("android");
    }

    await FlutterConfig.loadEnvVariables();


    Timer.periodic(const Duration(seconds: 10), (timer) async{
      if(service is AndroidServiceInstance){
        //set foreground notification
        service.setForegroundNotificationInfo(title: "Location Tracking is On", content: "Sending Location");
        print("timer");
        fetchLocation();
      }
    });
  }
  
  static Future<void> fetchLocation() async {
    try{

      late String? serverAddress = FlutterConfig.get("traccarLocationApi");

      var firebaseId = FirebaseAuth.instance.currentUser?.uid;
      // var transporterId = tidstorage.read("transporterId");

      firebaseId ??= "1234567890";

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );


      double lat = position.latitude;
      double lng = position.longitude;

      double altitude = position.altitude;
      double speed = position.speed;

      double horizontalAccuracy = position.accuracy * 2;
      double hdop = horizontalAccuracy / 2;

      print("ok");


      DateTime now = DateTime.now();


      print("got the location $lat, $lng, $hdop, $altitude, $speed, $firebaseId");

      final url = Uri.parse(
          "http://$serverAddress/?id=$firebaseId&lat=$lat&lon=$lng&timestamp=${now.toUtc().toString()}&hdop=$hdop&altitude=$altitude&speed=$speed");


      final response = await http.post(url);

      print("url $url");

      print("body: $response.body");

    } catch (e) {
      print("Error in location :$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text("This is Landing Page", style: TextStyle(color:Color.fromRGBO(0, 160, 227, 1),fontSize: 25),),
      ),
    );
  }

}