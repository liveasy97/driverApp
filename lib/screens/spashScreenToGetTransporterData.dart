import 'dart:async';

import 'package:driver_app/constants/color.dart';
import 'package:driver_app/constants/spaces.dart';
import 'package:driver_app/controller/transporterIdController.dart';
import 'package:driver_app/screens/navigationScreen.dart';
import 'package:flutter/material.dart';
//import 'package:liveasy/functions/trasnporterApis/runTransporterApiPost.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';

class SplashScreenToGetTransporterData extends StatefulWidget {
  final String mobileNum;

  SplashScreenToGetTransporterData({required this.mobileNum});

  @override
  _SplashScreenToGetTransporterDataState createState() =>
      _SplashScreenToGetTransporterDataState();
}

class _SplashScreenToGetTransporterDataState
    extends State<SplashScreenToGetTransporterData> {
  GetStorage tidstorage = GetStorage('TransporterIDStorage');
  TransporterIdController transporterIdController =
      Get.put(TransporterIdController(), permanent: true);

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    bool? transporterApproved;
    bool? companyApproved;
    String? mobileNum;
    bool? accountVerificationInProgress;
    String? transporterLocation;
    String? name;
    String? companyName;

    String? transporterId;
    //= await runTransporterApiPost(mobileNum: widget.mobileNum);

    // String? transporterId = tidstorage.read("transporterId");
    // runTransporterApiPost(mobileNum: widget.mobileNum);

    if (transporterId != null) {
      Timer(Duration(milliseconds: 1200),
          () => Get.off(() => NavigationScreen()));
    } else {
      setState(() {
        transporterId = tidstorage.read("transporterId");
        transporterApproved = tidstorage.read("transporterApproved");
        companyApproved = tidstorage.read("companyApproved");
        mobileNum = tidstorage.read("mobileNum");
        accountVerificationInProgress =
            tidstorage.read("accountVerificationInProgress");
        transporterLocation = tidstorage.read("transporterLocation");
        name = tidstorage.read("name");
        companyName = tidstorage.read("companyName");
      });
      if (transporterId == null) {
        print("Transporter ID is null");
      } else {
        print("It is in else");
        transporterIdController.updateTransporterId(transporterId!);
        transporterIdController.updateTransporterApproved(transporterApproved!);
        transporterIdController.updateCompanyApproved(companyApproved!);
        transporterIdController.updateMobileNum(mobileNum!);
        transporterIdController.updateAccountVerificationInProgress(
            accountVerificationInProgress!);
        transporterIdController.updateTransporterLocation(transporterLocation!);
        transporterIdController.updateName(name!);
        transporterIdController.updateCompanyName(companyName!);
        print("transporterID is $transporterId");

        Timer(Duration(milliseconds: 1200),
            () => Get.off(() => NavigationScreen()));
      }
      //Timer(Duration(milliseconds: 1), () => Get.off(() => NavigationScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darkBlueColor,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
            left: -175,
            top: space_1,
            child: Container(
              width: width * 5,
              height: height * 2,
              color: darkBlueColor,
              child: Stack(
                children: [
                  Positioned(
                    left: width * 0.9,
                    top: height * 0.45,
                    child: Text(
                      'Liveasy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size_16,
                        fontFamily: 'Montserrat',
                        fontWeight: boldWeight,
                      ),
                    ),
                  ),
                  Positioned(
                    left: width * 0.75,
                    top: height * 0.455,
                    child: Image(
                      image: const AssetImage("assets/images/liveasyLogo.png"),
                      fit: BoxFit.cover,
                      height: space_6,
                    ),
                  ),
                  Positioned(
                    left: width * 0.95,
                    top: height * 0.55,
                    child: Container(
                      width: width * 0.55,
                      height: height * 0.4,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/images/logoRight.png"),
                        fit: BoxFit.fill,
                      )),
                    ),
                  ),
                  Positioned(
                    left: width * 0.4,
                    top: -10,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(0.02),
                      child: Container(
                        width: width * 0.55,
                        height: height * 0.4,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/images/logoLeft.png"),
                          fit: BoxFit.fill,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
