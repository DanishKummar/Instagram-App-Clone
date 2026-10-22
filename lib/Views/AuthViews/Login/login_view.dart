import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:new_insta/Components/have_account_component.dart';
import 'package:new_insta/Components/or_component.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/FirestoreController/UserController/user_controller.dart';
import 'package:new_insta/Controllers/ThemeController/theme_controller.dart';
import 'package:new_insta/Controllers/ValidationController/validation_controller.dart';
import 'package:new_insta/Utils/Constants/constants.dart';
import 'package:new_insta/Views/AuthViews/ForgotPassword/forgotpassword_view.dart';
import 'package:new_insta/Views/AuthViews/SignUp/signup_view.dart';
import 'package:new_insta/Widgets/ElevatedButton/elevatedbutton_widget.dart';
import 'package:new_insta/Widgets/TextButton/textbutton_widget.dart';
import 'package:new_insta/Widgets/TextField/textfield_widget.dart';

void main() {
  runApp(const LogInView());
}

class LogInView extends StatelessWidget {
  const LogInView({super.key});

  @override
  Widget build(BuildContext context) {
    // ----------> constants controller
    Constants constants = Get.put(Constants());
    // ----------> authcontroller class
    ValidationController authController = Get.put(ValidationController());
    // ----------> theme controller
    ThemeController themeController = Get.find();
    //  ---------> firebase auth controller
    FirebaseAuthController firebaseAuthController = Get.put(
      FirebaseAuthController(),
    );
    // ----------> facebook login controller
    // FacebookLoginController facebookLoginController = Get.put(
    //   FacebookLoginController(),
    // );
    UserController userController = Get.put(UserController());
    return GestureDetector(
      // closes the keyboard when tapping outside
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, // Prevent UI from shifting when the keyboard appears
        body: SafeArea(
          child: Center(
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
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        // Center the items (top to bottom)
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // theme base Instagram logo with responsive width & height
                          Obx(
                            () => Center(
                              child: themeController.isDarkMode.value
                                  ? Image.asset(
                                      "assets/images/insta-black-mode-logo.png",
                                      // Controlling the image height and width dynamically
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6, // 60% of screen width
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.12, // 20% of screen height
                                    )
                                  : Image.asset(
                                      "assets/images/insta-logo.png",
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.12,
                                    ),
                            ),
                          ),

                          // LogIn (Email, phone number, username) --> TextField
                          TextfieldWidget(
                            hintText: "Email Address",
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
                          // LogIn Password --> TextField (Obscured)
                          TextfieldWidget(
                            hintText: "Password",
                            obscureText: true,
                            inputType: TextInputType.visiblePassword,
                            controller: authController.passwordController,
                          ),
                          // password validator  text
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Obx(
                              () => Text(
                                authController.passwordlError.value,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          // Forgot password text button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextbuttonWidget(
                              buttonText: "Forgot password?",
                              // forgot password functionality
                              voidCallback: () {
                                // navigate to forgot password screen
                                Get.to(() => ForgotPasswordView());
                              },
                            ),
                          ),
                          // Spacing
                          SizedBox(height: 10.h),

                          // Login button
                          SizedBox(
                            height: 40.h,
                            child: ElevatedbuttonWidget(
                              buttonText: "Log in",
                              callback: () {
                                if (authController.loginValidateField()) {
                                  // <<<<<<< login functionality <<<<<<<<<
                                  firebaseAuthController.signIn(
                                    authController.emailController.text,
                                    authController.passwordController.text,
                                  );
                                  userController.addUser();
                                }
                              },
                            ),
                          ),

                          // Spacing
                          SizedBox(height: 30.h),

                          // Log in with Facebook (icon and text button)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Facebook icon container
                              Container(
                                width: 23.w, // Responsive width
                                height: 23.h, // Responsive height
                                decoration: BoxDecoration(
                                  color: constants.facebookColor,
                                ),
                                child: Center(
                                  // Facebook icon
                                  child: FaIcon(
                                    FontAwesomeIcons.facebookF,
                                    color: Colors.white,
                                    size: 14.sp, // Scalable icon size
                                  ),
                                ),
                              ),

                              // Log-in with Facebook text button
                              TextButton(
                                // Login with Facebook functionality
                                onPressed: () {
                                  // ***********
                                  // facebookLoginController.signInWithFacebook();
                                },
                                child: Text(
                                  "Log in with Facebook",
                                  // Text button styling
                                  style: TextStyle(
                                    color: constants.textButtonColor,
                                    fontFamily: constants.primaryFont,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Spacing
                          SizedBox(height: 20.h),

                          // "Or" separator
                          OrComponent(),
                          // Spacing
                          SizedBox(height: 20.h),

                          // Sign-up option
                          HaveaccountComponent(
                            text: "Don't have an account?",
                            buttonText: "Signup",
                            onPress: () {
                              // clearing the log in controllers
                              authController.loginClearController();
                              // removing the login errors
                              authController.logInRemoveErrors();
                              // navigate to sign up page
                              Get.to(() => SignUpView());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
