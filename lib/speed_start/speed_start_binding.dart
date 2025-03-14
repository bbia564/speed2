import 'package:get/get.dart';

import 'speed_start_logic.dart';

class SpeedStartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PageLogic(),
      permanent: true,
    );
  }
}
