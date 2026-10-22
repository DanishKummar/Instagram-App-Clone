import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_insta/Models/Post/PostModel/post_model.dart';

class PostFetchController extends GetxController {
  // post list
  final RxList<PostModel> posts = <PostModel>[].obs;
  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // loading status
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    try {
      isLoading.value = true;
      // post snapshot
      final snapshot = await _firestore
          .collection('user_post')
          .orderBy('created_at', descending: true)
          .get();
      // loaded posts
      final List<PostModel> loadedPosts = snapshot.docs.map((doc) {
        final data = doc.data();
        return PostModel.fromMap(data);
      }).toList();
      // assigning all stories to post list
      posts.assignAll(loadedPosts);
    } catch (e) {
      print('Error fecthing posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ******** fetch Post By Id ******************
  Future<PostModel?> fetchPostById(String postId) async {
    try {
      final doc = await _firestore.collection("user_post").doc(postId).get();
      if (doc.exists) {
        return PostModel.fromMap(doc.data()!);
      }
    } catch (e) {
      Get.snackbar("Error", 'Error fetching post by ID: $e');
    }
    return null;
  }
}
