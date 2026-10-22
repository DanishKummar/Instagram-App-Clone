// // Importing required packages
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:new_insta/Models/StoryModel/story_model.dart';
// import 'package:new_insta/Views/MainBottomNavigationViews/Home/home_view.dart';
// import 'package:path/path.dart'; // for basename()
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class StoryUploadController extends GetxController {
//   // Supabase, Firestore, and Firebase Auth instances
//   final SupabaseClient supabase = Supabase.instance.client;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   // Reactive variables to hold selected image and music files
//   Rx<File?> imageFile = Rx<File?>(null);
//   Rx<File?> musicFile = Rx<File?>(null);

//   // Indicates upload process state
//   RxBool isUploading = false.obs;

//   // ========================== PICK IMAGE FROM GALLERY ==========================
//   void pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       imageFile.value = File(picked.path); // Save selected image
//     } else {
//       Get.snackbar("Image", "No image selected");
//     }
//   }

//   // ========================== PICK MUSIC FROM FILE PICKER ==========================
//   void pickMusic() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['mp3', 'wav', 'aac'], // allowed music formats
//     );
//     if (result != null && result.files.single.path != null) {
//       musicFile.value = File(result.files.single.path!); // Save selected music
//     } else {
//       Get.snackbar("Music", "No music selected");
//     }
//   }

//   // ========================== UPLOAD FILE TO SUPABASE STORAGE ==========================
//   Future<String?> uploadToSupabaseStorage(File file, String folder) async {
//     final fileName =
//         "${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}"; // unique name
//     final path = "$folder/$fileName";

//     try {
//       // Upload the file to Supabase Storage under the 'stories' bucket
//       final response = await supabase.storage
//           .from('stories')
//           .upload(path, file);

//       // Check if upload failed
//       if (response.isEmpty) return null;

//       // Create a signed URL valid for 1 year
//       final signedUrl = await supabase.storage
//           .from('stories')
//           .createSignedUrl(path, 60 * 60 * 24 * 365);

//       return signedUrl;
//     } catch (e) {
//       print("Upload error: $e");
//       return null;
//     }
//   }

//   // ========================== UPLOAD STORY TO FIRESTORE (FROM PICKED FILES) ==========================
//   Future<void> uploadStoryToFirestore() async {
//     final currentUser = auth.currentUser;

//     // Ensure user is logged in
//     if (currentUser == null) {
//       Get.snackbar("Error", "User not logged in");
//       return;
//     }

//     // Ensure image is selected
//     if (imageFile.value == null) {
//       Get.snackbar("Missing", "Please select an image");
//       return;
//     }

//     isUploading.value = true;

//     try {
//       // Get user data from Firestore
//       final userDoc = await firestore
//           .collection('users')
//           .doc(currentUser.uid)
//           .get();
//       if (!userDoc.exists) {
//         Get.snackbar("Error", "User data not found in Firestore");
//         isUploading.value = false;
//         return;
//       }

//       final username = userDoc.data()?['username'] ?? 'Unknown';

//       // Upload image to Supabase
//       final imageUrl = await uploadToSupabaseStorage(
//         imageFile.value!,
//         "story_images",
//       );

//       // Upload music if selected
//       String? musicUrl;
//       if (musicFile.value != null) {
//         musicUrl = await uploadToSupabaseStorage(
//           musicFile.value!,
//           "story_music",
//         );
//       }

//       // Validate image upload
//       if (imageUrl == null) {
//         Get.snackbar("Error", "Image upload failed");
//         return;
//       }

//       // Create story model
//       final story = StoryModel(
//         imageUrl: imageUrl,
//         musicUrl: musicUrl,
//         userId: currentUser.uid,
//         username: username,
//         createdAt: DateTime.now(),
//         storyType: imageFile.toString(),
//       );

//       // Save story to Firestore
//       await firestore.collection('user_stories').add(story.toJson());

//       Get.snackbar("Success", "Story posted successfully");

//       // Clear selected files
//       imageFile.value = null;
//       musicFile.value = null;

//       // Debug logs
//       print("User data: ${userDoc.data()}");
//       print("Image URL: $imageUrl");
//       print("Username: $username");
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isUploading.value = false;
//     }
//   }

//   // ========================== POST ADMIN-PROVIDED MUSIC + IMAGE (ALREADY HOSTED URLs) ==========================
//   Future<void> uploadSelectedAdminMusicFromUrl({
//     required String imageUrl,
//     required String musicUrl,
//   }) async {
//     final currentUser = auth.currentUser;

//     // Ensure user is logged in
//     if (currentUser == null) {
//       Get.snackbar("Error", "User not logged in");
//       return;
//     }

//     isUploading.value = true;

//     try {
//       // Get user info from Firestore
//       final userDoc = await firestore
//           .collection('users')
//           .doc(currentUser.uid)
//           .get();
//       final username = userDoc.data()?['username'] ?? 'Unknown';

//       // Create story model using already-hosted image/music URLs
//       final story = StoryModel(
//         imageUrl: imageUrl,
//         musicUrl: musicUrl,
//         userId: currentUser.uid,
//         username: username,
//         createdAt: DateTime.now(),
//         storyType: imageFile.value.toString(),
//       );

//       // Save story to Firestore
//       await firestore.collection('user_stories').add(story.toJson());

//       Get.snackbar("Success", "Story posted successfully");
//       // Go to Home view
//       Get.to(() => HomeView());
//     } catch (e) {
//       Get.snackbar("Upload Failed", e.toString());
//     } finally {
//       isUploading.value = false;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_insta/Models/StoryModel/story_model.dart';
import 'package:new_insta/Sections/ShowBottomSheet/bottom_sheet.dart';
import 'package:new_insta/Views/MainBottomNavigationViews/Home/home_view.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../Models/StoryModel/story_model.dart';
// import '../../Views/MainBottomNavigationViews/Home/home_view.dart';

class StoryUploadController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Rx<File?> imageFile = Rx<File?>(null);
  Rx<File?> musicFile = Rx<File?>(null);
  RxBool isUploading = false.obs;
  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  // Fetch user profile from firestore
  // Fetch user profile from Firestore
  Future<void> fetchUserData() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    try {
      final doc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (doc.exists) {
        userData.value = doc.data()!;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Choose image source (gallery/camera) and edit
  Future<void> pickImageAndEdit(
    BuildContext context,
    ImageSource source,
  ) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) {
      Get.snackbar("Image", "No image selected");
      return;
    }

    final imageBytes = await picked.readAsBytes();

    // Save to a safe file path
    final tempDir = await getTemporaryDirectory();
    final safePath =
        "${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}.jpg";
    final savedFile = File(safePath)..writeAsBytesSync(imageBytes);

    final edited = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ImageEditor(image: imageBytes)),
    );

    if (edited != null && edited is Uint8List) {
      final filteredFile = File(safePath)..writeAsBytesSync(edited);
      imageFile.value = filteredFile;
      Get.snackbar("Success", "Image filtered");
      showMusicBottomSheet(context);
    } else {
      Get.snackbar("Cancelled", "Editing cancelled");
    }
  }

  void pickMusic() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac'],
    );

    if (result != null && result.files.single.path != null) {
      musicFile.value = File(result.files.single.path!);
    } else {
      Get.snackbar("Music", "No music selected");
    }
  }

  Future<String?> uploadToSupabaseStorage(File file, String folder) async {
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}";
    final path = "$folder/$fileName";

    try {
      final response = await supabase.storage
          .from('stories')
          .upload(path, file);
      if (response.isEmpty) return null;

      final signedUrl = await supabase.storage
          .from('stories')
          .createSignedUrl(path, 60 * 60 * 24 * 365);
      return signedUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  // *********************** upload story_type Images to cloudinary *******************
  Future<String?> uploadToCloudinary(File file) async {
    final cloudName = 'djbnyzoop';
    final uploadPreset = 'story_images';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        return data['secure_url']; // ✅ Cloudinary image URL
      } else {
        print("Cloudinary upload failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Cloudinary error: $e");
      return null;
    }
  }

  Future<void> uploadStoryToFirestore() async {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    if (imageFile.value == null) {
      Get.snackbar("Missing", "Please select an image");
      return;
    }

    isUploading.value = true;

    try {
      final userDoc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (!userDoc.exists) {
        Get.snackbar("Error", "User data not found");
        return;
      }

      final username = userDoc.data()?['username'] ?? 'Unknown';

      final imageUrl = await uploadToSupabaseStorage(
        imageFile.value!,
        "story_images",
      );
      if (imageUrl == null) {
        Get.snackbar("Error", "Image upload failed");
        return;
      }

      String? musicUrl;
      if (musicFile.value != null) {
        musicUrl = await uploadToSupabaseStorage(
          musicFile.value!,
          "story_music",
        );
      }

      final story = StoryModel(
        imageUrl: imageUrl,
        musicUrl: musicUrl,
        userId: currentUser.uid,
        username: username,
        createdAt: DateTime.now(),
        storyType: 'image_with_optional_music',
      );

      await firestore.collection('user_stories').add(story.toJson());

      Get.snackbar("Success", "Story posted successfully");
      imageFile.value = null;
      musicFile.value = null;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> uploadSelectedAdminMusicFromUrl({
    required String imageUrl,
    required String musicUrl,
  }) async {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    isUploading.value = true;

    try {
      final userDoc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final username = userDoc.data()?['username'] ?? 'Unknown';

      final story = StoryModel(
        imageUrl: imageUrl,
        musicUrl: musicUrl,
        userId: currentUser.uid,
        username: username,
        createdAt: DateTime.now(),
        storyType: imageFile.value != null
            ? await uploadToCloudinary(imageFile.value!)
            : null,
      );

      await firestore.collection('user_stories').add(story.toJson());

      Get.snackbar("Success", "Story posted successfully");
      Get.to(() => HomeView());
    } catch (e) {
      Get.snackbar("Upload Failed", e.toString());
    } finally {
      isUploading.value = false;
    }
  }
}
