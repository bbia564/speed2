import 'package:get/get.dart';

import 'speed_setting_logic.dart';

class SpeedSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpeedSettingLogic());
  }
}
