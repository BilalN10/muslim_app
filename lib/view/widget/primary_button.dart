import 'package:flutter/material.dart';
import 'package:muslim_app/app_constants/app_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {super.key,
      required this.height,
      required this.text,
      required this.width});
  double height;
  double width;
  String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          // padding: EdgeInsets.symmetric(vertical: Adaptive.h(5.4)),

          primary: AppConstant().primaryColor,
          // background
          onPrimary: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ), // foreground
        ),
        onPressed: () {},
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Colors.white, fontSize: Adaptive.px(16)),
        ),
      ),
    );
  }
}
