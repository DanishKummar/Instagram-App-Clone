import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_insta/Models/Reels/reel_model.dart';

class ReelController extends GetxController {
  final RxList<ReelModel> reels = <ReelModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  void fetchReels() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('user_reels')
          .orderBy('createdAt', descending: true)
          .get();

      reels.value = snapshot.docs
          .map((doc) => ReelModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      Get.snackbar("Error", 'Error fetching reels');
    }
  }

  final _firestore = FirebaseFirestore.instance;
  // ******** fetch reel By Id ******************
  Future<ReelModel?> fetchReelById(String reelId) async {
    try {
      final doc = await _firestore.collection("user_reels").doc(reelId).get();
      if (doc.exists) {
        return ReelModel.fromMap(doc.data()!);
      }
    } catch (e) {
      Get.snackbar("Error", 'Error fetching reel by ID: $e');
    }
    return null;
  }
}
