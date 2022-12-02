import 'package:flutter/material.dart';
import 'package:muslim_app/app_constants/app_constants.dart';
import 'package:muslim_app/view/widget/my_input_field.dart';
import 'package:muslim_app/view/widget/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController typeCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController zipCodeCont = TextEditingController();
  TextEditingController statCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Adaptive.h(5),
                  ),
                  Text(
                    'Suggest a Location',
                    style: TextStyle(
                        fontSize: Adaptive.px(18), fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Requests will be reviewed in less than 24 hours',
                    style: TextStyle(
                        fontSize: Adaptive.px(14), fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: Adaptive.h(3),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontSize: Adaptive.px(14),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(1),
                  ),
                  InputField(textEditingController: nameCont),
                  SizedBox(
                    height: Adaptive.h(2),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Type',
                      style: TextStyle(
                          fontSize: Adaptive.px(14),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(1),
                  ),
                  InputField(textEditingController: typeCont),
                  SizedBox(
                    height: Adaptive.h(2),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Address',
                      style: TextStyle(
                          fontSize: Adaptive.px(14),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(1),
                  ),
                  InputField(textEditingController: addressCont),
                  SizedBox(
                    height: Adaptive.h(2),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'City',
                      style: TextStyle(
                          fontSize: Adaptive.px(14),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(1),
                  ),
                  InputField(textEditingController: cityCont),
                  SizedBox(
                    height: Adaptive.h(2),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Zip code',
                      style: TextStyle(
                          fontSize: Adaptive.px(14),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(1),
                  ),
                  InputField(textEditingController: zipCodeCont),
                  SizedBox(
                    height: Adaptive.h(2),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'State',
                      style: TextStyle(
                          fontSize: Adaptive.px(14),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: Adaptive.h(1),
                  ),
                  InputField(textEditingController: statCont),
                  SizedBox(
                    height: Adaptive.h(5),
                  ),
                  PrimaryButton(
                      height: Adaptive.h(5.4),
                      text: "Submit Request",
                      width: Adaptive.w(86))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
