import 'dart:async';

import 'package:driver_app/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../screens/languageSelectionScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3),
        () => Get.off(() => const LanguageSelectionScreen()));
    super.initState();
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
