import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'speed_records_logic.dart';

class SpeedRecordsPage extends GetView<SpeedRecordsLogic> {
  Widget _buildStatCard(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                color: Color(0xffa5a5a5),
                decoration: TextDecoration.none)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Driving record',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          const Text(
            'Clean',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ).marginOnly(right: 20).gestures(onTap: () {
            controller.cleanSpeedData();
          })
        ],
      ),
      body: SafeArea(child: Obx(() {
        return controller.list.value.isEmpty
            ? const Center(
                child: Text(
                  'No data',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: controller.list.value.length,
                itemBuilder: (_, index) {
                  final entity = controller.list.value[index];
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    child: <Widget>[
                      Text(
                        entity.createdTimeStr,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Divider(
                        height: 25,
                        color: Color(0xff6e6e6e),
                      ),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 5,
                        children: [
                          _buildStatCard('Time', entity.duration),
                          _buildStatCard('Distance', '${entity.distance} km'),
                          _buildStatCard(
                              'Average velocity', '${entity.avgSpeed} km/h'),
                          _buildStatCard(
                              'Maximum speed', '${entity.maxSpeed} km/h'),
                        ],
                      )
                    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
                  ).decorated(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xff484848)).marginOnly(bottom: 10);
                });
      })),
    );
  }
}
