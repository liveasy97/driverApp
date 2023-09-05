import 'package:driver_app/constants/color.dart';
import 'package:driver_app/constants/fontWeights.dart';
import 'package:driver_app/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStartedButton extends StatefulWidget {
  Function? onTapNext;

  GetStartedButton({Key? key, required this.onTapNext}) : super(key: key);

  @override
  _GetStartedButtonState createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Positioned(
      left: space_5,
      top: height * 0.76,
      child: SizedBox(
        width: width * 0.8,
        height: space_11,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            backgroundColor: MaterialStateProperty.all<Color>(white),
          ),
          onPressed: () {
            widget.onTapNext!();
          },
          child: Text(
            'getStarted'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkBlueColor,
              fontSize: space_4,
              fontFamily: 'Montserrat',
              fontWeight: mediumBoldWeight,
            ),
          ),
        ),
      ),
    );
    // TextButton(
    //   // highlightColor: Colors.transparent,
    //   onPressed: () {
    //     widget.onTapNext!();
    //   },
    //   child: Container(
    //     height: space_8,
    //     decoration: BoxDecoration(
    //       color: darkBlueColor,
    //       borderRadius: BorderRadius.circular(radius_6),
    //     ),
    //     child: Center(
    //       child: Text(
    //         'getStarted'.tr,
    //         // "Get Started",
    //         style: TextStyle(
    //             color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
    //       ),
    //     ),
    //   ));
    //   GestureDetector(
    //   onTap: (){
    //     widget.onTapNext!();
    //   },
    //   child: Container(
    //     height: space_8,
    //     decoration: BoxDecoration(
    //         color: darkBlueColor,
    //         borderRadius: BorderRadius.circular(radius_6)),
    //     child: Center(
    //       child: Text(
    //         'getStarted'.tr,
    //         // "Get Started",
    //         style: TextStyle(
    //             color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
    //       ),
    //     ),
    //   ),
    // );
  }
}
