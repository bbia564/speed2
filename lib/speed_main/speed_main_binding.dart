import 'package:get/get.dart';

import 'speed_main_logic.dart';

class SpeedMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpeedMainLogic());
  }
}
