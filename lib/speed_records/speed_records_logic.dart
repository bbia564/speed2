import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_speed/db_speed/db_speed.dart';
import 'package:travel_speed/db_speed/speed_entity.dart';

class SpeedRecordsLogic extends GetxController {

  DBSpeed dbSpeed = Get.find();

  var list = <SpeedEntity>[].obs;

  void getData() async {
    list.value = await dbSpeed.getSpeedAllData();
  }

  cleanSpeedData() async {
    Get.dialog(AlertDialog(
      title: const Text('Warm reminder'),
      content: const Text('Do you want to clean all records?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel',style: TextStyle(color: Colors.black),),
        ),
        TextButton(
          onPressed: () async {
            await dbSpeed.cleanSpeedData();
            getData();
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

}
