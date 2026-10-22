import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Components/have_account_component.dart';
import 'package:new_insta/Components/or_component.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/ThemeController/theme_controller.dart';
import 'package:new_insta/Controllers/ValidationController/validation_controller.dart';
import 'package:new_insta/Utils/Constants/constants.dart';
import 'package:new_insta/Views/AuthViews/Login/login_view.dart';
import 'package:new_insta/Widgets/ElevatedButton/elevatedbutton_widget.dart';
import 'package:new_insta/Widgets/TextField/textfield_widget.dart';

void main() {
  runApp(const SignUpView());
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    // data from constants class
    Constants constants = Get.find();
    // theme controller
    ThemeController themeController = Get.put(ThemeController());
    // auth controller
    ValidationController authController = Get.put(ValidationController());
    // firebase authentication controller
    FirebaseAuthController firebaseAuthController = Get.put(
      FirebaseAuthController(),
    );
    return GestureDetector(
      // closes the keyboard when tapping outside
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        // resizeToAvoidBottomInset:
        //     false, // Prevent UI from shifting when the keyboard appears
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ), // Responsive padding
            child: Column(
              // Center the items (top to bottom)
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Using Expanded to make sure the UI doesn't break on smaller screens
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Center the items (top to bottom)
                          children: [
                            // theme base Instagram logo with responsive width & height
                            Obx(
                              () => themeController.isDarkMode.value
                                  ? Image.asset(
                                      "assets/images/insta-black-mode-logo.png",
                                      // fit: BoxFit.cover,
                                      // Controlling the image height and width dynamically
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.1,
                                    )
                                  : Image.asset(
                                      "assets/images/insta-logo.png",
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.1,
                                    ),
                            ),
                            // sign up intro text
                            Obx(
                              () => Text(
                                "Sign up to see photos and videos from your friends.",
                                // sign up text styling
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22.sp,
                                  fontFamily: constants.primaryFont,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Space
                            SizedBox(height: 30.h),

                            // sign up (Email) --> TextField
                            TextfieldWidget(
                              hintText: "Email",
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
                            // sign up (phone) --> TextField
                            TextfieldWidget(
                              hintText: "Mobile Number",
                              obscureText: false,
                              inputType: TextInputType.phone,
                              // controller: authController.phoneNumberController,
                              controller: authController.phoneNumberController,
                            ),
                            // mobile number validator text
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(
                                () => Text(
                                  authController.phoneNumberError.value,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            // sign up (username) --> TextField
                            TextfieldWidget(
                              hintText: "Username",
                              obscureText: false,
                              inputType: TextInputType.name,
                              controller: authController.userNameController,
                            ),
                            // username validator text
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(
                                () => Text(
                                  authController.userNameError.value,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            // sign up (password) --> TextField
                            TextfieldWidget(
                              hintText: "Password",
                              obscureText: true,
                              inputType: TextInputType.visiblePassword,
                              controller: authController.passwordController,
                            ),
                            // password validator text
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(
                                () => Text(
                                  authController.passwordlError.value,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            // spacing
                            SizedBox(height: 20.h),
                            // sign up button
                            SizedBox(
                              height: 40.h,
                              child: ElevatedbuttonWidget(
                                buttonText: "Sign up",
                                callback: () {
                                  if (authController.signUpValidateFields()) {
                                    // sign up functionality
                                    firebaseAuthController.signUp(
                                      authController.emailController.text,
                                      authController.passwordController.text,
                                      authController.userNameController.text,
                                    );
                                  }
                                },
                              ),
                            ),

                            // Spacing
                            SizedBox(height: 20.h),

                            // "Or" separator
                            OrComponent(),
                            // Spacing
                            SizedBox(height: 10.h),

                            // Login option
                            HaveaccountComponent(
                              text: "Have an account?",
                              buttonText: "Login",
                              onPress: () {
                                // removing the error when tap on login button
                                authController.signUpRemoveErrors();

                                // navigate to sign up page
                                Get.to(() => LogInView());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
