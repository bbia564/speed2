import 'package:get/get.dart';

import 'speed_records_logic.dart';

class SpeedRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpeedRecordsLogic());
  }
}
