import 'dart:async';

import 'package:get/get.dart';
import 'package:travel_speed/db_speed/db_speed.dart';

import '../db_speed/speed_entity.dart';

class SpeedMainLogic extends GetxController {

  DBSpeed dbSpeed = Get.find();

  var currentSpeed = 0.obs;
  var avgSpeed = 0.obs;
  var maxSpeed = 0.obs;
  var totalDistance = 0.0.obs;
  Duration travelTime = Duration.zero;
  bool isStarted = false;

  var timeDown = 0;
  var timeDownStr = '00:00:00';
  Timer? _timer;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeDown++;
      final hours = timeDown ~/ 3600;
      final minutes = (timeDown % 3600) ~/ 60;
      final seconds = timeDown % 60;
      timeDownStr =
          '${hours > 9 ? '$hours' : '0$hours'}:${minutes > 9 ? '$minutes' : '0$minutes'}:${seconds > 9 ? '$seconds' : '0$seconds'}';
      update();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void insertData() async {
    await dbSpeed.insertSpeedData(SpeedEntity(
      id: 0,
      createdTime: DateTime.now(),
      duration: timeDownStr,
      distance: totalDistance.toString(),
      avgSpeed: avgSpeed.toString(),
      maxSpeed: maxSpeed.toString(),
    ));
  }
}
