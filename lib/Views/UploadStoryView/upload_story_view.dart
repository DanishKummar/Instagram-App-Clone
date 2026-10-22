import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_insta/Components/ImageTextButtom/image_text_button.dart';
import 'package:new_insta/Controllers/FirestoreController/UploadStoryController/upload_story_controller.dart';
import 'package:new_insta/Customs/Appbar/custom_appbar.dart';
import 'package:new_insta/Sections/ShowBottomSheet/bottom_sheet.dart';

class UploadStoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StoryUploadController controller = Get.put(StoryUploadController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppbar(
          showLeading: true,
          leadingIcon: "assets/icons/close-icon-dark-mode.png",
          leadingWidth: 20.w,
          leadingHeight: 20.h,
          onLeadingPressed: () => Get.back(),
          showTitle: true,
          title: Center(child: Text("Add to Story")),
        ),
      ),
      body: Obx(
        () => controller.isUploading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(10.sp),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Music + AI Buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showMusicBottomSheet(context);
                              },
                              child: ImageTextbuttonWidget(
                                imageUrl: "assets/icons/music-icon.png",
                                text: "Music",
                                height: 33.h,
                                width: 33.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                print('AI image picker tapped');
                              },
                              child: ImageTextbuttonWidget(
                                imageUrl: "assets/icons/meta-ai.png",
                                text: "AI images",
                                height: 30.h,
                                width: 30.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),

                      /// Photo Title
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          'Photos',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, top: 3.h),
                        child: Text(
                          "You've given access to a selected number of photos.",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.4.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),

                      /// Camera/Gallery Picker Button
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFF222328),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text("Take Photo"),
                                    onTap: () {
                                      Get.back();
                                      controller.pickImageAndEdit(
                                        context,
                                        ImageSource.camera,
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text("Select from Gallery"),
                                    onTap: () {
                                      Get.back();
                                      controller.pickImageAndEdit(
                                        context,
                                        ImageSource.gallery,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Obx(
                          () => Container(
                            margin: EdgeInsets.only(top: 10.h),
                            height: 250.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(211, 37, 41, 45),
                              borderRadius: BorderRadius.circular(10),
                              image: controller.imageFile.value != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        controller.imageFile.value!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: controller.imageFile.value == null
                                ? Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 27.sp,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),

                      /// Upload Story Button
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // controller.uploadStoryToFirestore();
                            if (controller.imageFile.value == null) {
                              Get.snackbar(
                                "Missing",
                                "please select the image first",
                              );
                            }
                            final imageUrl = await controller
                                .uploadToCloudinary(
                                  controller.imageFile.value!,
                                );
                            if (imageUrl != null) {
                              Get.snackbar(
                                "Success",
                                "Image uploaded to Cloudinary",
                              );
                              print("Cloudinary URL: $imageUrl");
                            } else {
                              Get.snackbar("Error", "Image upload failed");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "Upload To Cloudinary",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
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
