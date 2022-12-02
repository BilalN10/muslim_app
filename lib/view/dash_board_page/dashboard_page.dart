import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:muslim_app/app_constants/app_constants.dart';
import 'package:muslim_app/view/add_event/add_event.dart';
import 'package:muslim_app/view/add_location/add_location.dart';
import 'package:muslim_app/widget/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Adaptive.h(8.6),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Adaptive.w(2.9)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryButton(
                  height: Adaptive.h(5.4),
                  text: 'Add Location',
                  width: Adaptive.w(45.9),
                  onPressed: () {
                    Get.to(() => const AddLocation());
                  },
                ),
                PrimaryButton(
                  height: Adaptive.h(5.4),
                  text: 'Add Event',
                  width: Adaptive.w(45.9),
                  onPressed: () {
                    Get.to(() => const AddEvent());
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: Adaptive.h(4),
          ),
          optionTile(AppConstant().masjid, 'Masjids'),
          SizedBox(
            height: Adaptive.h(3),
          ),
          optionTile(AppConstant().culture, 'Cultural Grocery Stores'),
          SizedBox(
            height: Adaptive.h(3),
          ),
          optionTile(AppConstant().resturant, 'Halal Restraunts'),
          SizedBox(
            height: Adaptive.h(3),
          ),
          optionTile(AppConstant().event, 'Muslim Events'),
          SizedBox(
            height: Adaptive.h(3),
          ),
          optionTile(AppConstant().clothes, 'Traditional Clothing Stores'),
          SizedBox(
            height: Adaptive.h(3),
          ),
          optionTile(AppConstant().services, 'Muslim Owned Services'),
        ],
      ),
    );
  }

  Widget optionTile(String imagePath, String title) {
    return Container(
      alignment: Alignment.center,
      height: Adaptive.h(8),
      width: Adaptive.w(88),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppConstant().borderColor)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Adaptive.w(2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              imagePath,
              width: Adaptive.w(7.7),
              height: Adaptive.h(5.6),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: Adaptive.px(18), fontWeight: FontWeight.w500),
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }
}
