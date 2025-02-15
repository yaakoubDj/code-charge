import 'package:flutter/material.dart';

class GbsSystemServerStrings {
//from app strings
  static const str_primary_color = Color(0xff1564c0);
  // static const str_logo_image_path = "assets/images/logo.png";
  static const str_logo_image_path = "assets/images/logoApp.png";

  static const str_boarding1_lottie_path = "assets/lotties/boarding1.json";
  static const str_boarding2_lottie_path = "assets/lotties/boarding2.json";
  static const str_boarding3_lottie_path = "assets/lotties/boarding3.json";
  static const str_boarding4_lottie_path = "assets/lotties/boarding4.json";
  static const String no_data_lottie_path =
      "assets/lotties/noDataLastLottie.json";
  static const String str_happy_face_path = "assets/lotties/happyFace.json";
  static const str_vetments_image_path = "assets/images/vetements.jpg";
  static const str_error_no_connection_lottie_path =
      "assets/lotties/noConnection.json";
  static const str_error_server_lottie_path = "assets/lotties/errorServer.json";
  static const String nfc_lottie_path = "assets/lotties/nfc.json";
  static const String str_sad_face_path = "assets/lotties/sadFace.json";

////
  static const String CNX_TYPE_Server = "server";
  static const String CNX_TYPE_Planner = "planner";

  static const String bmServer_PriseService = "BMSERVER-MBLN";
//  "BMServer-MBLN-PS";
  static const String bmPlanning_PriseService2 = "wbmplanning";
  static const String bmPlanning_PriseService = "BMUser-MBLN-PS";
  static const String quick_Access_PriseService = "bmplanning-qcs";

  static const str_server_url =
      "https://www.bmplanning.com/BMServerR.dll/BMRest";
  static const str_server_s19 =
      // "95795240B1DD461EAA0E0B4290BC39D86BB4D896F96645EDB4D4FAE9B638EB1A817ED710129F42CFA428062FE2688F941230B5AB2786470D8186E289DBE4EB00";
      "AF5BB23EE60F43C48DA4998C228578DF0AE9847AC8414FFDBB4B6ADBD361EEE86BCD6A91CDFC4AC2AA4BA0D767359F4D48D27623E658474B9385AF95247FC2DB";
  static const str_server_okey_login = "38DE973EC4ED455AAD1E12E8E2593481";
  static const str_server_okey = "CACB4E292F3F44319D411C16184883A3";
  static const MAPBOX_ACCESS_TOKEN =
      "pk.eyJ1IjoiZ2JzeXN0ZW02MDAiLCJhIjoiY2s5d3F2cjhtMDdiczNmcGtxbXJ3b3Z3eCJ9.AsXfGh2XQ_mxvRUdkIwQzQ";

  static const MAPBOX_URL =
      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}';
  // 'https://api.mapbox.com/styles/v1/{id}/tiles?access_token={accessToken}';

  static const MAPBOX_ID = 'mapbox/streets-v11';

// Server Keys
  static const String kSuccesStatus = "Succes";
  static const String kFailedStatus = "Failed";
  static const String kIsFirstTime = "isFirstTime";
  static const String kPINCode = "codePIN";

  static const String kToken = "token";
  static const String kCookies = "cookies";

  static const String kPort = "port";
  static const String kIP = "ip";

  static const String kSiteWeb = "siteWeb";
  static const String kS19 = "s19";
  static const String str_pointage_entrer_sens = "1";
  static const String str_pointage_sortie_sens = "2";

  static const String kJsonApiPath = "assets/api/clients_data.json";
  static const String kClientNumber =
      String.fromEnvironment('CLIENT_NUMBER', defaultValue: "0");
  static const String kMyBaseUrlStandard = String.fromEnvironment('API_URL',
      // defaultValue: "https://www.bmplanning.com/BMServerR.dll/BMRest");
      // defaultValue: "https://192.168.1.112:8010/BMServerR.dll/BMRest");
      defaultValue: "https://192.168.1.120/BMServerR.dll/BMRest");

  static const String kMyS19Standard = String.fromEnvironment('S19',
      defaultValue:
          // "95795240B1DD461EAA0E0B4290BC39D86BB4D896F96645EDB4D4FAE9B638EB1A817ED710129F42CFA428062FE2688F941230B5AB2786470D8186E289DBE4EB00");
          "AF5BB23EE60F43C48DA4998C228578DF0AE9847AC8414FFDBB4B6ADBD361EEE86BCD6A91CDFC4AC2AA4BA0D767359F4D48D27623E658474B9385AF95247FC2DB");
  static const String kMyAppName =
      String.fromEnvironment('APP_NAME', defaultValue: "BmSalarié-M");

  static const String kTopicClient =
      String.fromEnvironment('TOPIC_NAME', defaultValue: "topic_news");

  static const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

  static const String Pointage_LecteurName_BmMob_PS1 = "BmMob-PS1";
  static String Str_PriseService_enregistre(Params) {
    return 'Votre prise de service est enregistré à $Params';
  }

  ///
}
