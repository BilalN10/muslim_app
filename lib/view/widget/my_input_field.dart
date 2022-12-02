import 'package:flutter/material.dart';
import 'package:muslim_app/app_constants/app_constants.dart';

class InputField extends StatelessWidget {
  InputField({super.key, required this.textEditingController});
  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: textEditingController,
        decoration: InputDecoration(
          // contentPadding: const EdgeInsets.fromLTRB(40, 20, 12, 12),
          //  labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          //hintText: widget.hintText,
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
