import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/FirebaseAuthController/firebase_auth_controller.dart';
import 'package:new_insta/Controllers/ValidationController/validation_controller.dart';
import 'package:new_insta/Models/User/user_model.dart';

FirebaseAuthController firebaseAuthController = Get.put(
  FirebaseAuthController(),
);
ValidationController authController = Get.put(ValidationController());

class UserController extends GetxController {
  Future<void> addUser() async {
    // creating firebase auth instance
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      final usermodel = UserModel(
        uid: user.uid,
        username: authController.userNameController.text,
        email: authController.emailController.text,
        photoUrl: "",
        createdAt: DateTime.now(),
        following: [],
      );
      // send data to firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(usermodel.toJson());
      print("===========================> user added successfully");
    }
  }
}
