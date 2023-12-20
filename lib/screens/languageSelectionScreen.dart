import 'package:driver_app/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/spaces.dart';
import '../controller/transporterIdController.dart';
import '../functions/trasnporterApis/runTransporterApiPost.dart';
import '../language/localization_service.dart';
import '../widgets/buttons/getStartedButton.dart';
import '../widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'LoginScreens/loginScreen.dart';
import 'navigationScreen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String valueChoose = "Hindi";
  String? transporterId;
  bool _nextScreen = false;
  TransporterIdController transporterIdController =
      Get.put(TransporterIdController(), permanent: true);
  @override
  void initState() {
    super.initState();
    getData();
    valueChoose = LocalizationService().getCurrentLang(); //added this
  }

  Function? onTapNext() {
    Get.to(bottomProgressBarIndicatorWidget());
    Get.off(() => NavigationScreen());
  }

  getData() async {
    bool? transporterApproved;
    bool? companyApproved;
    String? mobileNum;
    bool? accountVerificationInProgress;
    String? transporterLocation;
    String? name;
    String? companyName;

    if (transporterId != null) {
      setState(() {
        _nextScreen = true;
      });
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
        setState(() {
          _nextScreen = true;
        });
      }
    }
  }

  List<String> listItem = ["Hindi", "English"];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darkBlueColor,
      body: Stack(
        children: [
          Positioned(
            left: space_5,
            top: height * 0.5,
            child: Text(
              'selectLanguage'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: white,
                fontSize: size_12,
                fontFamily: 'Montserrat',
                fontWeight: mediumBoldWeight,
              ),
            ),
          ),
          Positioned(
              left: space_2,
              top: height * 0.57,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(space_3),
                    child: DropdownButton(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: darkBlueColor,
                      ),
                      isExpanded: true,
                      underline: SizedBox(),
                      iconSize: size_16,
                      style: const TextStyle(
                        color: darkBlueColor,
                        fontSize: 24,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                      value: valueChoose,
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue != null) {
                            valueChoose = newValue;
                            if (listItem[0] == valueChoose) {
                              var locale = const Locale('hi', 'IN');
                              Get.updateLocale(locale);
                              valueChoose = 'Hindi';
                            } else {
                              var locale = const Locale('en', 'US');
                              Get.updateLocale(locale);
                              valueChoose = 'English';
                            }
                            LocalizationService().changeLocale(valueChoose);
                          }
                        });
                      },
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )),
          Positioned(
            left: space_4,
            top: space_27,
            child: Container(
              width: width * 0.9,
              height: height * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/truckImage.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
              top: space_0,
              right: space_0,
              child: Container(
                width: width * 0.6,
                height: height * 0.16,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/circularDesignTop.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              )),
          Positioned(
              bottom: space_0,
              right: space_0,
              child: Container(
                width: width * 0.6,
                height: height * 0.14,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/circularDesignBottom.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              )),
          _nextScreen
              ? GetStartedButton(
                  onTapNext: this.onTapNext,
                )
              : GetStartedButton(
                  onTapNext: () {
                    Get.off(LoginScreen());
                  },
                ),
        ],
      ),
    );
  }
}
