import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/OptionController/option_controller.dart';
import 'package:new_insta/Customs/CustomOptionTile/option_tile.dart';

class OptionWidget extends StatelessWidget {
  final OptionController optionController = Get.put(OptionController());

  OptionWidget({super.key});
  // List of options
  final List<Map<String, dynamic>> options = [
    {
      'value': 'opt1',
      'title': 'Your story',
      'subtitle': 'Sharing Options',
      'icon': Image.asset(
        "assets/images/my_story.png",
        width: 50.w,
        height: 100.h,
      ),
    },
    {
      'value': 'opt2',
      'title': 'Close Friends',
      'subtitle': 'Add People',
      'icon': Image.asset("assets/icons/star.png", width: 50.w, height: 100.h),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          // current option
          final opt = options[index];
          // obx
          return Obx(
            // custom radio tile
            () => CustomRadioOptionTile(
              // value
              value: opt['value'],
              selectedValue: optionController.selectedOption.value,

              // leading
              leading: opt['icon'],
              // title
              title: opt['title'],
              // subtitle
              subtitle: opt['subtitle'],
              // ontap
              onTap: () => optionController.select(opt['value']),
            ),
          );
        },
      ),
    );
  }
}
