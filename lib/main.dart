import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:travel_speed/db_speed/db_speed.dart';
import 'package:travel_speed/speed_main/speed_main_binding.dart';
import 'package:travel_speed/speed_main/speed_main_view.dart';
import 'package:travel_speed/speed_records/speed_records_binding.dart';
import 'package:travel_speed/speed_records/speed_records_view.dart';
import 'package:travel_speed/speed_setting/speed_setting_binding.dart';
import 'package:travel_speed/speed_setting/speed_setting_view.dart';
import 'package:travel_speed/speed_start/speed_start_binding.dart';
import 'package:travel_speed/speed_start/speed_start_view.dart';

import 'db_speed/speed_config.dart';
import 'no_network/no_network_binding.dart';
import 'no_network/no_network_view.dart';

Color primaryColor = const Color(0xff2981f8);
Color bgColor = const Color(0xff272727);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.putAsync(() => DBSpeed().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Speeds,
      initialRoute: '/',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        dialogTheme: const DialogTheme(
          actionsPadding: EdgeInsets.only(right: 10, bottom: 5),
        ),
        dividerTheme: DividerThemeData(
          thickness: 1,
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
List<GetPage<dynamic>> Speeds = [
  GetPage(name: '/', page: () => const SpeedStartView(), binding: SpeedStartBinding()),
  GetPage(name: '/noNetworkPage', page: () => NoNetworkPage(), binding: NoNetworkBinding()),
  GetPage(name: '/speedMainPage', page: () => const SpeedMainPage(), binding: SpeedMainBinding()),
  GetPage(name: '/configInit', page: () => const SpeedConfig()),
  GetPage(name: '/speedRecordsPage', page: () => SpeedRecordsPage(), binding: SpeedRecordsBinding()),
  GetPage(name: '/speedSettingPage', page: () => SpeedSettingPage(), binding: SpeedSettingBinding()),
];