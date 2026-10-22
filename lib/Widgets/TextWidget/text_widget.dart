import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FieldWidget extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType inputType;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onSuffixTap;
  final double? height;
  final int maxLines;
  final int minLines;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Color? fillColor;
  final Color? outlineColor;
  final double borderRadius;
  final Widget? suffixIcon;
  const FieldWidget({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.inputType,
    this.onChanged,
    this.controller,
    this.height,
    this.maxLines = 1,
    this.minLines = 1,
    this.hintStyle,
    this.textStyle,
    this.fillColor,
    this.outlineColor,
    this.borderRadius = 20.0,
    this.suffixIcon,
    this.onSuffixTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50.h,
      padding: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        color: fillColor ?? Colors.grey.shade800,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(color: outlineColor ?? Colors.grey.shade600),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: inputType,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          style: textStyle ?? TextStyle(fontSize: 14.sp, color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(onTap: onSuffixTap, child: suffixIcon),
            isDense: true,

            border: InputBorder.none,
            hintText: hintText,
            hintStyle:
                hintStyle ??
                TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
