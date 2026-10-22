import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/FirestoreController/UserController/user_controller.dart';
import 'package:new_insta/Controllers/FollowController/follow_controller.dart';
import 'package:new_insta/Controllers/ValidationController/validation_controller.dart';
import 'package:new_insta/Utils/Constants/constants.dart';
import 'package:new_insta/Views/AuthViews/Login/login_view.dart';
import 'package:new_insta/Views/AuthViews/SignUp/signup_view.dart';
import 'package:new_insta/Views/FollowUserView/follow_user_view.dart';
import 'package:new_insta/Views/MainBottomNavigationViews/Home/home_view.dart';

// initialize the constant controller
Constants constants = Get.put(Constants());
// initialize the auth controller
ValidationController authController = Get.put(ValidationController());
UserController userController = Get.put(UserController());
FollowController followController = Get.put(FollowController());

class FirebaseAuthController extends GetxController {
  // firebase auth instance
  FirebaseAuth auth = FirebaseAuth.instance;
  // is loading
  var isLoading = false.obs;

  User? get currentUser => auth.currentUser;
  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< SIGN IN FUNCTIONALITY >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  // sign up fuctionality
  Future<void> signUp(String email, String password, String fullName) async {
    try {
      // Show loading indicator
      isLoading.value = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      // user sign up account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // set display user name
      await userCredential.user?.updateDisplayName(fullName);
      // send user data to firebase firestore
      // if
      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      // <<<<<< after sign up process navigate to sign in screen >>>>>>>
      Get.to(() => LogInView());
    } on FirebaseException catch (e) {
      // error message
      String errorMessage = getErrorMessage(e.code, e.message);
      showErrorDialog(errorMessage, "Sign Up Error");
    } finally {
      isLoading.value = false;
    }
  }

  //  show firendly message error to user
  String getErrorMessage(String errorCode, String? errorMessage) {
    if (errorMessage == null) {
      return "An unexpected error occurred. Please try again.";
    }
    if (errorMessage.contains("Password must")) {
      return formatPasswordErrorMessage(errorMessage);
    }
    switch (errorCode) {
      case "email-already-in-use":
        return "This email is already registered. Try signing in instead.";
      case "invalid-email":
        return "Please enter a valid email address.";
      case 'operation-not-allowed':
        return "Signing up is currently disabled. Please try again later.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }

  // Function to format password error messages
  String formatPasswordErrorMessage(String errorMessage) {
    List<String> errorParts = [];

    if (errorMessage.contains("at least 6 characters")) {
      errorParts.add("at least 6 characters");
    }
    if (errorMessage.contains("lower case character")) {
      errorParts.add("one lowercase letter");
    }
    if (errorMessage.contains("upper case character")) {
      errorParts.add("one uppercase letter");
    }
    if (errorMessage.contains("non-alphanumeric character")) {
      errorParts.add("one special character (e.g., !@#\$%^&*)");
    }

    if (errorParts.isNotEmpty) {
      return "Your password must include: ${errorParts.join(", ")}.";
    }

    return "Your password is too weak. Please try again.";
  }

  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< SIGN IN FUNCTIONALITY >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  // firebase sign in functionality
  Future<void> signIn(String email, String password) async {
    try {
      // Show loading indicator
      isLoading.value = true;
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      // sign in user functionality
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      followController.canAccessFeed()
          // *****
          ? Get.to(() => HomeView())
          : Get.to(() => UsersListView());
      //
      // atfer sign in navigate to home screen
      // *****
      // Get.offAll(() => HomeView());
      Get.to(() => HomeView());
    } on FirebaseException catch (e) {
      // sign in error messages
      getSignInErrorMessage(e.code);
      // Get user-friendly error message
      String errorMessage = e.code.isNotEmpty
          ? getSignInErrorMessage(e.code)
          : e.message ?? "An unexpected error occurred. Please try again.";
      showErrorDialog(errorMessage, "Sign In Error");
    }
  }

  // <<<< sign in error mesage <<<<<
  String getSignInErrorMessage(String errorcode) {
    switch (errorcode) {
      case "user-not-found":
        return "No account found with this email. Please sign up first.";
      case "wrong-password":
      case "invalid-credential":
        return "Incorrect email or password. Please try again.";
      case "invalid-email":
        return "Invalid email format. Please enter a valid email.";
      case "user-disabled":
        return "This account has been disabled. Contact support.";
      case "too-many-requests":
        return "Too many failed attempts. Try again later.";
      case "network-request-failed":
        return "Network error. Please check your connection and try again.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }

  // <<<<<<<<<<<<<<<<<<<<<<<< RESET PASSWORD <<<<<<<<<<<<<<<<<<<<<<<<<<
  Future<void> resetPassword(String email) async {
    try {
      email = email.trim().toLowerCase(); // Normalize email
      // await Future.delayed(Duration(seconds: 3));
      var methods = await auth.fetchSignInMethodsForEmail(email);

      if (methods.isEmpty) {
        // No registered user found with this email
        Get.defaultDialog(
          contentPadding: EdgeInsets.all(10),
          title: "Error",
          middleText: "This email is not registered. Please sign up first.",
          middleTextStyle: TextStyle(fontSize: 18.sp),
          confirm: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40),
              backgroundColor: themeController.isDarkMode.value
                  ? Colors.blue
                  : Colors.black, // 🔥 Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // navigate to sign up screen
            onPressed: () {
              Get.to(() => SignUpView());
              authController.forgotPasswordControllerClear();
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ), // 🔥 Text color
            ),
          ),
        );

        return; // Stop further execution
      }
      // send emial to reset password
      await auth.sendPasswordResetEmail(email: email);
      showErrorDialog(
        "Password reset link sent!. Check your email.",
        "Successfully",
      );
    } on FirebaseException catch (e) {
      Get.defaultDialog(title: "Error", middleText: e.message.toString());
    }
  }

  //  // show error dialog for sign up
  void showErrorDialog(String message, String title) {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        fontSize: 30.sp,
        fontFamily: constants.primaryFont,
        color: Colors.red,
      ),
      middleText: message,
      middleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontFamily: constants.primaryFont,
      ),
      // error  ok button
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      },
      barrierDismissible: false,
      confirm: ElevatedButton(
        onPressed: () {
          // close error dialog
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40),
          backgroundColor: themeController.isDarkMode.value
              ? Colors.blue
              : Colors.black, // 🔥 Background color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          "OK",
          style: TextStyle(
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black,
            fontSize: 20.sp,
          ), // 🔥 Text color
        ),
      ),
    );
  }
}
