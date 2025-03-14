import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:styled_widget/styled_widget.dart';
import 'speed_main_logic.dart';

class SpeedMainPage extends StatefulWidget {
  const SpeedMainPage({Key? key}) : super(key: key);

  @override
  State<SpeedMainPage> createState() => _SpeedMainPageState();
}

class _SpeedMainPageState extends State<SpeedMainPage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(SpeedMainLogic());

  late AnimationController _controller;
  late Animation<double> _animation;

  DateTime? _tripStartTime;
  Position? _lastPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  Widget _buildSpeedometer() {
    return SizedBox(
      width: 311,
      height: 235,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/bg.webp'),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              controller.currentSpeed.value.toString(),
              style: const TextStyle(
                fontSize: 70,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
            const Text(
              'km/h',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                decoration: TextDecoration.none,
              ),
            )
          ]),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: controller.isStarted
                    ? _animation.value * pi / 180
                    : (-135 * pi / 180),
                child: Image.asset(
                  'assets/arrow.webp',
                  width: 6,
                  height: 57,
                  alignment: Alignment.bottomCenter,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      controller.isStarted = true;
      controller.startTimer();
      controller.update();
      _startListening();
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Location permissions required'),
        content: const Text('Please grant location permission to measure speed'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Setting'),
          ),
        ],
      ),
    );
  }

  void _startListening() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      final newSpeed = position.speed * 3.6;
      _updateTripData(position);
      if (newSpeed >= 0) {
        _updateSpeed(newSpeed);
      }
    });
  }

  void _updateTripData(Position newPosition) {
    final currentTime = DateTime.now();

    setState(() {
      if (_tripStartTime == null) {
        _tripStartTime = currentTime;
      } else {
        controller.travelTime = currentTime.difference(_tripStartTime!);
      }
      if (_lastPosition != null) {
        final distanceInMeters = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          newPosition.latitude,
          newPosition.longitude,
        );
        controller.totalDistance.value += distanceInMeters;
      }
      _lastPosition = newPosition;
    });
  }

  void _updateSpeed(double newSpeed) {
    setState(() {
      controller.currentSpeed.value = newSpeed.toInt();
      if (newSpeed > controller.maxSpeed.value) {
        controller.maxSpeed.value = newSpeed.toInt();
      }

      _animation = Tween<double>(
        begin: _animation.value,
        end: _calculateRotationAngle(newSpeed),
      ).animate(_controller);
      _controller.reset();
      _controller.forward();
    });
  }

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

  Widget _buildStatsGrid(double averageSpeed) {
    controller.avgSpeed.value = averageSpeed.toInt();
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildStatCard('Time', controller.timeDownStr),
        _buildStatCard('Distance',
            '${(controller.totalDistance.value / 1000).toStringAsFixed(1)} km'),
        _buildStatCard('Average velocity', '${controller.avgSpeed.value} km/h'),
        _buildStatCard('Maximum speed', '${controller.maxSpeed.value} km/h'),
      ],
    );
  }

  void _resetAllData() {
    setState(() {
      controller.currentSpeed.value = 0;
      controller.maxSpeed.value = 0;
      controller.totalDistance.value = 0.0;
      controller.travelTime = Duration.zero;
      controller.avgSpeed.value = 0;
      controller.timeDown = 0;
      controller.timeDownStr = '00:00:00';
      _tripStartTime = null;
      _lastPosition = null;

      _animation = Tween<double>(
        begin: 0,
        end: _calculateRotationAngle(0),
      ).animate(_controller);
      _controller.reset();
      _controller.forward();
    });
  }

  double _calculateRotationAngle(double speed) {
    const maxSpeed = 160.0;
    const startAngle = -135;
    const fullAngle = 270.0;
    return (speed / maxSpeed) * fullAngle + startAngle;
  }

  void checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Get.toNamed('/noNetworkPage');
    }
  }

  @override
  void initState() {
    super.initState();
    checkNetwork();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final averageSpeed = controller.travelTime.inSeconds > 0
        ? (controller.totalDistance.value / 1000) /
            (controller.travelTime.inHours)
        : 0.0;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: GetBuilder<SpeedMainLogic>(
                init: SpeedMainLogic(),
                builder: (_) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: <Widget>[
                      <Widget>[
                        const Text(
                          'Travel speed',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: controller.currentSpeed.value < 80
                                  ? const Color(0xff31bf9b)
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(32)),
                          width: 64,
                          height: 64,
                          alignment: Alignment.center,
                          child: Obx(() {
                            return Text(
                                controller.currentSpeed.value.toString(),
                                style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none));
                          }),
                        )
                      ].toRow(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildSpeedometer(),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: _buildStatsGrid(averageSpeed),
                      ).decorated(
                          color: const Color(0xff484848),
                          borderRadius: BorderRadius.circular(15)),
                      const SizedBox(
                        height: 35,
                      ),
                      <Widget>[
                        Container(
                          width: 52,
                          height: 52,
                          child: Image.asset('assets/icon0.webp'),
                        )
                            .decorated(
                                borderRadius: BorderRadius.circular(26),
                                color: const Color(0xff484848))
                            .gestures(onTap: () {
                          _resetAllData();
                        }),
                        Container(
                          width: 168,
                          height: 52,
                          alignment: Alignment.center,
                          child: Text(
                            controller.isStarted ? 'Long press stop' : 'Start',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.none),
                          ),
                        )
                            .decorated(
                                borderRadius: BorderRadius.circular(26),
                                color: controller.isStarted
                                    ? const Color(0xff2981f8)
                                    : const Color(0xff31bf9b))
                            .gestures(onLongPress: () {
                          if (controller.isStarted) {
                            controller.isStarted = false;
                            controller.stopTimer();
                            controller.insertData();
                            _resetAllData();
                          }
                        }, onTap: () {
                          if (!controller.isStarted) {
                            _checkLocationPermission();
                          }
                        }),
                        Container(
                          width: 52,
                          height: 52,
                          child: Image.asset('assets/icon1.webp'),
                        )
                            .decorated(
                                borderRadius: BorderRadius.circular(26),
                                color: const Color(0xff484848))
                            .gestures(onTap: () {
                          Get.toNamed('/speedSettingPage');
                        })
                      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                    ].toColumn(),
                  );
                }).marginSymmetric(horizontal: 10)),
      ),
    );
  }
}
