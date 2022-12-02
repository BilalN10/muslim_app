import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:muslim_app/app_constants/app_constants.dart';
import 'package:muslim_app/view/root_page.dart/root_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => const RootPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconsTile(AppConstant().clothes),
                  SizedBox(
                    width: Adaptive.w(0.6),
                  ),
                  iconsTile(AppConstant().culture),
                  SizedBox(
                    width: Adaptive.w(0.6),
                  ),
                  iconsTile(AppConstant().event),
                  SizedBox(
                    width: Adaptive.w(0.6),
                  ),
                  iconsTile(AppConstant().masjid),
                  SizedBox(
                    width: Adaptive.w(0.6),
                  ),
                  iconsTile(AppConstant().resturant),
                  SizedBox(
                    width: Adaptive.w(0.6),
                  ),
                  iconsTile(AppConstant().services),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconsTile(String imaPath) {
    return Image.asset(
      imaPath,
      height: Adaptive.px(75),
      width: Adaptive.px(50),
    );
  }
}
