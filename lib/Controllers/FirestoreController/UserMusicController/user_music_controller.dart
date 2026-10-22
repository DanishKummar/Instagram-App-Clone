import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_insta/Models/Music/music_model.dart';

class MusicUserController extends GetxController {
  // ********** music list ************
  RxList<MusicModel> musicList = <MusicModel>[].obs;
  RxBool isLoading = false.obs;
  // search querry
  var searchQuery = ''.obs;
  @override
  void onInit() {
    super.onInit();
    print("🎵 MusicUserController initialized");
    fetchMusicList();
  }

  // ********** music list ************
  Future<void> fetchMusicList() async {
    // try to fetching thr music list
    try {
      isLoading.value = true;
      // *** snapshot of the music_library from the firebase
      final snapshot = await FirebaseFirestore.instance
          .collection("music_library")
          .get();
      print(snapshot);

      final fetched = snapshot.docs
          .map((doc) => MusicModel.fromMap(doc.data()))
          .toList();
      print(">>>>>>>>>>>>>>>>>>>>>>>>  $fetched");
      musicList.assignAll(fetched);
      print(">>>>>>>>>>>>>>>>>>>>>>>>>  $musicList");
    } catch (e) {
      print("*************** error $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<MusicModel> get filteredMusicList {
    // if search query is empty
    if (searchQuery.isEmpty) return musicList;
    return musicList
        .where(
          (music) =>
              // music list which music title contain with search querry
              music.title.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              // music list which music artist contain with search querry
              music.artist.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ),
        )
        .toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
