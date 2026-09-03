import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/theme/app_colors.dart';

class OtpField extends StatelessWidget {
  final TextEditingController controller;

  const OtpField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,

      controller: controller,

      // `controller` is owned and disposed by the GetX controller that
      // created it (see OtpController.onClose). PinCodeTextField defaults
      // to disposing externally-supplied controllers itself, which would
      // double-dispose it and crash with "used after being disposed" once
      // OtpController's own dispose runs during navigation.
      autoDisposeControllers: false,

      length: 5,

      keyboardType: TextInputType.phone,

      animationType: AnimationType.fade,

      cursorColor: Colors.white,

      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,

        borderRadius: BorderRadius.circular(15),

        fieldHeight: 60,

        fieldWidth: 50,

        activeColor: AppColors.green,

        selectedColor: Colors.white,

        inactiveColor: Colors.white30,

        activeFillColor: Colors.white10,

        selectedFillColor: Colors.white10,

        inactiveFillColor: Colors.white10,
      ),

      enableActiveFill: true,

      onChanged: (value) {},
    );
  }
}
