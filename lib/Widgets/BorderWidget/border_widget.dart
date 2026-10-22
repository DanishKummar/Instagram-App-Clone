import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BorderWidget extends StatelessWidget {
  const BorderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // bottom border
    Container(
      width: double.infinity,
      height: .1.h,
      color: const Color.fromARGB(255, 110, 110, 110),
    );
  }
}
