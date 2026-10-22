import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidationController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  var emailError = "".obs;
  var passwordlError = "".obs;
  var phoneNumberError = "".obs;
  var userNameError = "".obs;
  // funtion to validate the text fields
  bool signUpValidateFields() {
    bool isValid = true;
    // email error validator
    if (emailController.text.isEmpty) {
      emailError.value = "Email cannot be empty!";
      isValid = false;
    } else {
      emailError.value = "";
    }
    // password error validator
    if (passwordController.text.isEmpty) {
      passwordlError.value = "Password cannot be empty!";
      isValid = false;
    } else {
      passwordlError.value = "";
    }
    // mobile phone error validator
    if (phoneNumberController.text.isEmpty) {
      phoneNumberError.value = "Mobile number cannot be empty!";
      isValid = false;
    } else {
      phoneNumberError.value = "";
    }
    // username error validator
    if (userNameController.text.isEmpty) {
      userNameError.value = "Username cannot be empty!";
      isValid = false;
    } else {
      userNameError.value = "";
    }
    return isValid;
  }

  // login validate the text fields
  bool loginValidateField() {
    bool isValid = true;
    // email error validator
    if (emailController.text.isEmpty) {
      emailError.value = "Email cannot be empty!";
      isValid = false;
    } else {
      emailError.value = "";
    }
    // password error validator
    if (passwordController.text.isEmpty) {
      passwordlError.value = "Password cannot be empty!";
      isValid = false;
    } else {
      passwordlError.value = "";
    }
    return isValid;
  }

  // removing login error
  void logInRemoveErrors() {
    emailError.value = "";
    passwordlError.value = "";
  }

  // removing sign up error
  void signUpRemoveErrors() {
    emailError.value = "";
    passwordlError.value = "";
    phoneNumberError.value = "";
    userNameError.value = "";
  }

  // clearing the login controllers
  void loginClearController() {
    emailController.clear();
    passwordController.clear();
  }

  // clearing the sign up controllers
  void signUpClearController() {
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
    userNameController.clear();
  }

  // forgot password clear the controller
  forgotPasswordControllerClear() {
    passwordController.clear();
    phoneNumberController.clear();
    userNameController.clear();
  }
}
