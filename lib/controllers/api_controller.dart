import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:muslim_app/model/prayer_timming.dart';
import 'package:muslim_app/services/api_services.dart';

class ApiController extends GetxController {
  String latitude = '-4.325';
  String longitude = '15.322222';
  String month = '1';
  String year = '2022';
  String day = '1';
  RxString currentAddress = ''.obs;

  int endTime =
      1669630380136; // DateTime.now().millisecondsSinceEpoch + 1000 * 9328;
  String prayer = '';

  RxBool isfajar = false.obs;
  RxBool isSunrise = false.obs;
  RxBool isDhuhr = false.obs;
  RxBool isAsr = false.obs;
  RxBool isMagrib = false.obs;
  RxBool isIsha = false.obs;
  RxBool isMidNight = false.obs;

  PrayerTimeModel? prayerTime;

  List<PrayerTimeModel> prayerTimeList = <PrayerTimeModel>[];
  List<PrayerTimeModel> get getPrayerTimeList => prayerTimeList;
  void getPrayresTimming() async {
    List<PrayerTimeModel> _prayerTimeList = [];
    var response =
        await APIServices().getPyartime(latitude, longitude, month, year);
    print("company jobs is:${jsonDecode(response!.body)}");
    print('response is ${response.body} ');
    print('status is ${jsonDecode(response.body)['status']}');
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == 'OK') {
        for (int i = 0; i < jsonDecode(response.body)['data'].length; i++) {
          if (i == 1 //
              ) {
            prayerTime = PrayerTimeModel.fromJson(
                jsonDecode(response.body)['data'][i]['timings']);
          }
        }
      }
    }
    // prayerTimeList = _prayerTimeList;
    // print("job list length is:${prayerTime!.fajr}");
    checkAllTime();

    update();
  }

  Duration? getMagribTimeDifference;
  Duration? getFajarTimeDifference;
  Duration? getSunriseTimeDifference;
  Duration? getDhuhrTimeDifference;
  Duration? getAsrTimeDifference;
  Duration? getIshaTimeDifference;
  Duration? getMidNightTimeDifference;

  checkAllTime() {
    DateTime now = DateTime.now();
    print('now time is $now');
    DateTime currentTime = DateTime.now(); //.add(const Duration(days: -1));
    print('current time is $currentTime');
    // .add(Duration(
    //     days: now.day + 1,
    //     minutes: now.minute,
    //     hours: now.hour,
    //     seconds: now.second)); //DateTime.parse(formattedDate);
    String getTodaYdate = DateFormat('yyyy-MM-dd').format(now);

    print("current time is $currentTime");

    // Fajar time
    DateTime timeForFajar = DateTime.parse(
        "$getTodaYdate ${prayerTime!.fajr!.split(' ').first}:00");
    getFajarTimeDifference = timeForFajar.difference(currentTime);
    // Sunrise time
    DateTime timeForSunrise = DateTime.parse(
        "$getTodaYdate ${prayerTime!.sunrise!.split(' ').first}:00");
    getSunriseTimeDifference = timeForSunrise.difference(currentTime);
    // Dhuhr time
    DateTime timeForDhuhr = DateTime.parse(
        "$getTodaYdate ${prayerTime!.dhuhr!.split(' ').first}:00");
    getDhuhrTimeDifference = timeForDhuhr.difference(currentTime);
    // Asr time
    DateTime timeForAsr =
        DateTime.parse("$getTodaYdate ${prayerTime!.asr!.split(' ').first}:00");
    getAsrTimeDifference = timeForAsr.difference(currentTime);

    // Magrib time
    DateTime timeForMagrib = DateTime.parse(
        "$getTodaYdate ${prayerTime!.maghrib!.split(' ').first}:00");
    getMagribTimeDifference = timeForMagrib.difference(currentTime);
    // Isha time
    DateTime timeForIsha = DateTime.parse(
        "$getTodaYdate ${prayerTime!.isha!.split(' ').first}:00");
    getIshaTimeDifference = timeForIsha.difference(currentTime);
//${prayerTime!.midnight!.split(' ').first}
    // Isha time
    DateTime midNight = DateTime.parse("$getTodaYdate 23:00");
    getMidNightTimeDifference = midNight.difference(currentTime);
    log('fajar time difference is ${getFajarTimeDifference!.inHours}');
    log('sunrise time difference is ${getSunriseTimeDifference!.inHours} seconds  ${getSunriseTimeDifference!.inSeconds} ');
    log('zohar time difference is ${getDhuhrTimeDifference!.inHours}   seconds  ${getDhuhrTimeDifference!.inSeconds}');
    log('Asr time difference is ${getAsrTimeDifference!.inHours}');
    log('Magrib time difference is ${getMagribTimeDifference!.inHours}');
    log('Isha time difference is ${getIshaTimeDifference!.inHours}');
    log('Midnight time difference is ${getMidNightTimeDifference!.inHours}');

    log('Asr time difference in secconds ${getAsrTimeDifference!.inSeconds}');

    // print('isha time diff is ${getIshaTimeDifference.inMinutes}');
    // print('midnifht diff is ${getMidNightTimeDifference.inSeconds}');
    // print('midnifht diff is ${getMidNightTimeDifference.inHours}');

    if (getFajarTimeDifference!.inSeconds < 0 &&
        getSunriseTimeDifference!.inSeconds > 0) {
      endTime = DateTime.now().millisecondsSinceEpoch +
          1000 * getFajarTimeDifference!.inSeconds;
      prayer = 'Sunrise';
      isfajar.value = true;
      isSunrise.value = false;
      isDhuhr.value = false;
      isAsr.value = false;
      isMagrib.value = false;
      isIsha.value = false;
      isMidNight.value = false;

      update();
    } else if (getSunriseTimeDifference!.inSeconds < 0 &&
        getDhuhrTimeDifference!.inSeconds > 0) {
      endTime = 0;
      prayer = 'Dhuhr';

      isSunrise.value = true;
      isfajar.value = false;
      isDhuhr.value = false;
      isAsr.value = false;
      isMagrib.value = false;
      isIsha.value = false;
      isMidNight.value = false;
      update();
    } else if (getDhuhrTimeDifference!.inSeconds < 0 &&
        getAsrTimeDifference!.inSeconds > 0) {
      endTime = DateTime.now().millisecondsSinceEpoch +
          1000 * getDhuhrTimeDifference!.inSeconds;
      prayer = 'Asr';

      isDhuhr.value = true;
      isfajar.value = false;
      isSunrise.value = false;
      isAsr.value = false;
      isMagrib.value = false;
      isIsha.value = false;
      isMidNight.value = false;
      update();
    } else if (getAsrTimeDifference!.inSeconds < 0 &&
        getMagribTimeDifference!.inSeconds > 0) {
      endTime = DateTime.now().millisecondsSinceEpoch +
          1000 * getAsrTimeDifference!.inSeconds;
      prayer = 'Magrib';
      isAsr.value = true;
      isDhuhr.value = false;
      isfajar.value = false;
      isSunrise.value = false;
      isMagrib.value = false;
      isIsha.value = false;
      isMidNight.value = false;

      print('prayer time is $prayer ');
      print('time is $endTime');
      update();
    } else if (getMagribTimeDifference!.inSeconds < 0 &&
        getIshaTimeDifference!.inSeconds > 0) {
      endTime = DateTime.now().millisecondsSinceEpoch +
          1000 * getMagribTimeDifference!.inSeconds;
      prayer = 'Isha';
      isMagrib.value = true;
      isAsr.value = false;
      isDhuhr.value = false;
      isfajar.value = false;
      isSunrise.value = false;
      isIsha.value = false;
      isMidNight.value = false;
      update();
    } else if (getIshaTimeDifference!.inSeconds < 0 &&
        getMidNightTimeDifference!.inSeconds > 0) {
      endTime = DateTime.now().millisecondsSinceEpoch +
          1000 * getIshaTimeDifference!.inSeconds;
      prayer = 'Midnight';

      isIsha.value = true;
      isMagrib.value = false;
      isAsr.value = false;
      isDhuhr.value = false;
      isfajar.value = false;
      isSunrise.value = false;
      isMidNight.value = false;
      update();
    } else if (getMidNightTimeDifference!.inSeconds < 0 &&
        getFajarTimeDifference!.inSeconds > 0) {
      endTime =
          0; //DateTime.now().millisecondsSinceEpoch + 1000 * getIshaTimeDifference.inSeconds;
      prayer = 'Fajar';

      isMidNight.value = true;
      isIsha.value = false;
      isMagrib.value = false;
      isAsr.value = false;
      isDhuhr.value = false;
      isfajar.value = false;
      isSunrise.value = false;
      update();
    }
  }
}
