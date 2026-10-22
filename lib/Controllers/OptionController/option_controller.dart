import 'package:get/state_manager.dart';

class OptionController extends GetxController {
  var selectedOption = ''.obs;
  // selected string method
  void select(String value) {
    selectedOption.value = value;
  }
}
