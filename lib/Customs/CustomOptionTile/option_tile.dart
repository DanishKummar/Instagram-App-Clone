import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';

class CustomRadioOptionTile extends StatelessWidget {
  final String value;
  final String selectedValue;
  final VoidCallback onTap;
  final Widget? leading;
  final String title;
  final String? subtitle;

  const CustomRadioOptionTile({
    Key? key,
    required this.value,
    required this.selectedValue,
    required this.onTap,
    this.leading,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    // list tile
    ListTile(
      // leading
      leading: leading,
      // title
      title: Text(
        title,
        style: TextStyle(
          fontFamily: constants.primaryFont,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          letterSpacing: -.2.sp,
        ),
      ),
      // subtitle
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontFamily: constants.primaryFont,
                fontSize: 13.5.sp,
                letterSpacing: -.2.sp,
              ),
            )
          : null,
      // trailing
      trailing: Icon(
        selectedValue == value
            ? Icons.radio_button_checked
            : Icons.radio_button_off,
        color: selectedValue == value ? Colors.blue : Colors.grey,
        size: 25.sp,
      ),
      // ontap
      onTap: onTap,
    );
  }
}
