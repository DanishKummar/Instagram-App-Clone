import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/ThemeController/theme_controller.dart';
import 'package:new_insta/Controllers/ValidationController/validation_controller.dart';
import 'package:new_insta/Utils/Constants/constants.dart';
import 'package:new_insta/Widgets/ElevatedButton/elevatedbutton_widget.dart';
import 'package:new_insta/Widgets/TextField/textfield_widget.dart';

void main() {
  runApp(const ForgotPasswordView());
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize the theme controller
    ThemeController themeController = Get.put(ThemeController());
    // initialize the constant controller
    Constants constants = Get.put(Constants());
    // initialize the auth controller
    ValidationController authController = Get.put(ValidationController());
    // initialize the firebase auth controller
    FirebaseAuthController firebaseAuthController = Get.put(
      FirebaseAuthController(),
    );
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeController.isDarkMode.value
              ? Colors.black
              : Colors.white,
        ),
        body: SafeArea(
          // add resonsive padding to left and right
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // text
                Text(
                  "Find your account",
                  //text styling
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontFamily: constants.primaryFont,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                // spacing
                SizedBox(height: 20.h),
                // text
                Text(
                  "Enter your email address to reset the password",
                  style: TextStyle(
                    fontFamily: constants.primaryFont,
                    fontSize: 20.sp,
                  ),
                ),
                // spacing
                SizedBox(height: 25.h),
                // text field for email
                TextfieldWidget(
                  hintText: "Email address",
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  controller: authController.emailController,
                ),
                // email validator text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => Text(
                      authController.emailError.value,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),

                // spacing
                SizedBox(height: 10.h),
                Text(
                  "You will receive a link in your email. Please check your inbox and follow the instructions to reset your password.",
                  style: TextStyle(
                    fontFamily: constants.primaryFont,
                    fontSize: 15.sp,
                  ),
                ),
                // spacing
                SizedBox(height: 40.h),
                // elevated button (continue)
                SizedBox(
                  height: 40.h,
                  child: ElevatedbuttonWidget(
                    buttonText: "Continue",
                    // send link to email functionality
                    callback: () {
                      authController.emailController.text.isEmpty
                          ? firebaseAuthController.showErrorDialog(
                              "Email address is required",
                              "Exception Accur",
                            )
                          : null;
                      if (authController.emailController.text.isNotEmpty) {
                        firebaseAuthController.resetPassword(
                          authController.emailController.text.trim(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
