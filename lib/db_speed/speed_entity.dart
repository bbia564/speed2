import 'package:intl/intl.dart';

class SpeedEntity {

  int id;
  DateTime createdTime;
  String duration;
  String distance;
  String avgSpeed;
  String maxSpeed;

  SpeedEntity({
    required this.id,
    required this.createdTime,
    required this.duration,
    required this.distance,
    required this.avgSpeed,
    required this.maxSpeed,
  });

  factory SpeedEntity.fromJson(Map<String, dynamic> json) {
    return SpeedEntity(
      id: json['id'],
      createdTime: DateTime.parse(json['createdTime']),
      duration: json['duration'],
      distance: json['distance'],
      avgSpeed: json['avgSpeed'],
      maxSpeed: json['maxSpeed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
     'createdTime': createdTime.toIso8601String(),
      'duration': duration,
      'distance': distance,
      'avgSpeed': avgSpeed,
      'maxSpeed': maxSpeed,
    };
  }

  String get createdTimeStr {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(createdTime);
  }
}