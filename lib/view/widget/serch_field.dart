import 'package:flutter/material.dart';
import 'package:muslim_app/app_constants/app_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchFiled extends StatelessWidget {
  SearchFiled({super.key, required this.textEditingController});
  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: SizedBox(
            // width: Adaptive.w(4.1),
            // height: Adaptive.h(2.1),
            child: Image.asset(
              'assets/images/s_icon.png',
            ),
          ),
          hintText: 'Search',
          labelStyle: const TextStyle(color: Colors.grey),
          hintStyle: const TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppConstant().borderColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppConstant().borderColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppConstant().borderColor, width: 1)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppConstant().borderColor, width: 1)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppConstant().borderColor, width: 1)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppConstant().borderColor, width: 1)),
        ),
      ),
    );
  }
}
