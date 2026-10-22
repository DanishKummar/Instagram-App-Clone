import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_insta/Controllers/FirestoreController/UploadStoryController/upload_story_controller.dart';
import 'package:new_insta/Controllers/ThemeController/theme_controller.dart';
import 'package:new_insta/Views/SharePostView/share_post_view.dart';
import 'package:new_insta/Views/SplashView/splash_view.dart';
import 'package:new_insta/firebase_options.dart';
import 'package:new_insta/services/DynamicLink/dynamic_link_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:instagram_ui/controller/Auth_Controller/auth_controller.dart';
// import 'package:instagram_ui/controller/Firebase_Auth/firebase_auth_controller.dart';
// import 'package:instagram_ui/controller/MusicUserController/music_user_controller.dart';
// import 'package:instagram_ui/controller/audio/audio_controller.dart';
// import 'package:instagram_ui/controller/firestore/follow/follow_controller.dart';
// import 'package:instagram_ui/controller/theme.controller.dart';
// import 'package:instagram_ui/firebase_options.dart';
// import 'package:instagram_ui/utils/constants/constants.dart';
// import 'package:instagram_ui/view/log_In_view.dart';
// import 'package:instagram_ui/view/splash_view.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Supabase.initialize(
      url: "https://dgwcocepvvsmdpsepotm.supabase.co",
      anonKey: "your-key",
    );
  } catch (e, st) {
    print("Initialization error: $e\n$st");
  }

  // initialize controllers
  // Get.put(FollowController());
  // Get.put(Constants());
  // Get.put(AuthController());
  // Get.put(FirebaseAuthController());
  // Get.put(ThemeController());
  // Get.put(MusicUserController());
  // Get.put(AudioController());

  // FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
  //   final deepLink = dynamicLinkData.link;
  //   final postId = deepLink.queryParameters['id'];
  //   if (postId != null) {
  //     Get.to(() => SharePostView(postId: postId));
  //   }
  // });
  // Call dynamic link service
  await DynamicLinkService.initDynamicLinks();
  Get.put(StoryUploadController());
  await Get.find<StoryUploadController>().fetchUserData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // theme controller
    ThemeController themeController = Get.put(ThemeController());
    return ScreenUtilInit(
      // // Standard mobile reference
      designSize: Size(375, 812),
      minTextAdapt: true,
      // Adjusts UI for tablets too
      splitScreenMode: true,
      builder: (context, child) => Obx(
        () => GetMaterialApp(
          title: "Theme Switcher",
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,

          home: SplashView(),
        ),
      ),
    );
  }
}
