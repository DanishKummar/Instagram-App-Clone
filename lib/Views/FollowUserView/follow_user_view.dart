import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_insta/Controllers/FollowController/follow_controller.dart';
import 'package:new_insta/Utils/Constants/constants.dart';
// import 'package:instagram_ui/controller/Firebase_Auth/firebase_auth_controller.dart';
// import 'package:instagram_ui/controller/firestore/follow/follow_controller.dart';

// Screen that shows list of users with follow/unfollow buttons
class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the FollowController using GetX
    final FollowController followController = Get.put(FollowController());

    // Get the currently logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Notifications", // Title of the screen
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      // Listen to real-time updates from the 'users' Firestore collection
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          // Show loading spinner while waiting for data
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter out the current user from the user list
          final users = snapshot.data!.docs
              .where((doc) => doc['uid'] != currentUser?.uid)
              .toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Suggested for you" heading with padding
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    "Suggested for you",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: Constants().primaryFont,
                    ),
                  ),
                ),
                // User list builder
                ListView.builder(
                  shrinkWrap: true, // Makes it fit inside SingleChildScrollView
                  physics:
                      NeverScrollableScrollPhysics(), // Prevent nested scroll
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userId = user['uid']; // User ID
                    final username = user['username']; // Username
                    final email = user['email']; // Email (used for check)
                    final pic = user['photoUrl']; // Profile picture URL

                    // Initialize follow status if not already done
                    followController.initFollowStatus(userId);

                    return Obx(() {
                      // Reactively update UI based on follow state
                      final isFollowing = followController.isFollowing(userId);

                      return ListTile(
                        // Show user profile picture or default image
                        leading: CircleAvatar(
                          radius: 25.r,
                          backgroundImage: pic == ""
                              ? AssetImage("assets/images/my_story.png")
                                    as ImageProvider
                              : NetworkImage(pic),
                        ),

                        // Show username if it's not the current user
                        title: Text(
                          username,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: Constants().primaryFont,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Show email if it's not the current user
                        subtitle: Text(
                          email,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: Constants().primaryFont,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Follow/Unfollow button if not current user
                        trailing: SizedBox(
                          height: 35.h,
                          width: 100.w,
                          child: ElevatedButton(
                            onPressed: () {
                              // Toggle follow state
                              followController.toggleFollow(userId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing
                                  ? Colors.grey[800]
                                  : const Color.fromARGB(255, 33, 89, 243),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            // button text
                            child: Text(
                              isFollowing ? "Unfollow" : "Follow",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
