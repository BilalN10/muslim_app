import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:muslim_app/app_constants/app_constants.dart';
import 'package:muslim_app/controllers/api_controller.dart';
import 'package:muslim_app/view/qibla_compass_page/qibla_compass.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PrayerTimePage extends StatefulWidget {
  const PrayerTimePage({super.key});

  @override
  State<PrayerTimePage> createState() => _PrayerTimePageState();
}

class _PrayerTimePageState extends State<PrayerTimePage> {
  ApiController apiController = Get.put(ApiController());
  var today = HijriCalendar.now();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

  @override
  void initState() {
    super.initState();

    // apiController.getPrayresTimming();
    // apiController.checkAllTime();
//     DateTime now = DateTime.now();
//     // String formattedDate = DateFormat('yyyy-MM-dd hh-mm-ss').format(now);

//     String getTodaYdate = DateFormat('yyyy-MM-dd').format(now);

//     print('get today $getTodaYdate');

//     DateTime dt1 = DateTime.now(); //DateTime.parse(formattedDate);
//     DateTime dt2 = DateTime.parse(
//         "$getTodaYdate ${apiController.prayerTime!.midnight!.split(' ').first}:00");

//     print('midnight time ${apiController.prayerTime!.midnight!}');

//     Duration diff = dt2.difference(dt1);

//     print('in days ${diff.inDays}');
// //output (in days): 1198d

//     print('in hours ${diff.inHours}');
// //output (in hours): 28752

//     print('in minutes ${diff.inMinutes}');
// //output (in minutes): 1725170

//     print(diff.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    if (apiController.isfajar.value) {
      setState(() {
        //endTime = 0;
        DateTime.now().millisecondsSinceEpoch +
            1000 * apiController.getSunriseTimeDifference!.inSeconds;
      });
    } else if (apiController.isSunrise.value) {
      setState(() {
        endTime = DateTime.now().millisecondsSinceEpoch +
            1000 * apiController.getDhuhrTimeDifference!.inSeconds;
      });
    } else if (apiController.isDhuhr.value) {
      setState(() {
        endTime = DateTime.now().millisecondsSinceEpoch +
            1000 * apiController.getAsrTimeDifference!.inSeconds;
      });
    } else if (apiController.isAsr.value) {
      setState(() {
        endTime = DateTime.now().millisecondsSinceEpoch +
            1000 * apiController.getMagribTimeDifference!.inSeconds;
      });
    } else if (apiController.isMagrib.value) {
      setState(() {
        endTime = DateTime.now().millisecondsSinceEpoch +
            1000 * apiController.getIshaTimeDifference!.inSeconds;
      });
    } else if (apiController.isIsha.value) {
      setState(() {
        endTime = DateTime.now().millisecondsSinceEpoch +
            1000 * apiController.getMidNightTimeDifference!.inSeconds;
        ;
      });
    } else if (apiController.isMidNight.value) {
      setState(() {
        endTime = DateTime.now().millisecondsSinceEpoch +
            1000 * apiController.getFajarTimeDifference!.inSeconds;
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: Adaptive.h(3),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/loc_icon.png',
                    ),
                    SizedBox(
                      width: Adaptive.h(1),
                    ),
                    Obx(
                      () => Text('${apiController.currentAddress}',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w400,
                              fontSize: Adaptive.px(14))),
                    ),
                  ],
                ),

                SizedBox(
                  height: Adaptive.h(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5.4)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(today.toFormat("dd MMMM yyyy"),
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w400,
                            fontSize: Adaptive.px(14))),
                  ),
                ),
                SizedBox(
                  height: Adaptive.h(4.1),
                ),

                // counter(),

                // CountdownTimer(
                //   endTime: endTime,
                //   endWidget: const Text('end'),
                //   widgetBuilder: (_, CurrentRemainingTime? time) {
                //     if (time == null) {
                //       return const Text('null');
                //     }
                //     return Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Icon(FontAwesomeIcons.volumeHigh),
                //         SizedBox(
                //           height: Adaptive.h(3),
                //         ),
                //         // Text(
                //         //   'Time to ${con.prayer}',
                //         //   style: Theme.of(context).textTheme.headline5,
                //         // ),
                //         SizedBox(
                //           height: Adaptive.h(3),
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               time.hours.toString().length == 1
                //                   ? "0${time.hours.toString()}"
                //                   : time.hours.toString(),
                //               style: Theme.of(context).textTheme.headline5,
                //             ),
                //             Text(':'),
                //             Text(
                //                 time.min.toString().length == 1
                //                     ? "0${time.min.toString()}"
                //                     : time.min.toString(),
                //                 style: Theme.of(context).textTheme.headline5),
                //             Text(':'),
                //             Text(
                //                 time.sec.toString().length == 1
                //                     ? "0${time.sec.toString()}"
                //                     : time.sec.toString(),
                //                 style: Theme.of(context).textTheme.headline5),
                //           ],
                //         ),
                //       ],
                //     );
                //     // Text(
                //     //     'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                //   },
                // ),

                GetBuilder<ApiController>(
                    init: apiController,
                    builder: (con) {
                      return Container(
                        alignment: Alignment.center,
                        width: Adaptive.w(46.7),
                        height: Adaptive.h(21.6),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(blurRadius: 20, color: Colors.black12)
                            ]),
                        child: CountdownTimer(
                          endTime: endTime,
                          widgetBuilder: (_, CurrentRemainingTime? time) {
                            if (time == null) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FontAwesomeIcons.volumeHigh),
                                  SizedBox(
                                    height: Adaptive.h(3),
                                  ),
                                  Text(
                                    'Time to ${con.prayer}',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ],
                              );
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FontAwesomeIcons.volumeHigh),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                Text(
                                  'Time to ${con.prayer}',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                SizedBox(
                                  height: Adaptive.h(3),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      time.hours == null
                                          ? '00'
                                          : time.hours.toString().length == 1
                                              ? "0${time.hours.toString()}"
                                              : time.hours.toString(),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Text(':'),
                                    Text(
                                        time.min == null
                                            ? '00'
                                            : time.min.toString().length == 1
                                                ? "0${time.min.toString()}"
                                                : time.min.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                    Text(':'),
                                    Text(
                                        time.sec == null
                                            ? '00'
                                            : time.sec.toString().length == 1
                                                ? "0${time.sec.toString()}"
                                                : time.sec.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ],
                                ),
                              ],
                            );
                            // Text(
                            //     'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                          },
                        ),
                      );
                    }),
                SizedBox(
                  height: Adaptive.h(0.8),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5.4)),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => QiblaCompass());
                        },
                        child: Image.asset(
                          'assets/images/qibla-compass.png',
                          height: Adaptive.h(4.6),
                          width: Adaptive.w(9.8),
                        ),
                      )),
                ),
                SizedBox(
                  height: Adaptive.h(0.8),
                ),
                // GetBuilder<ApiController>(
                //     init: apiController,
                //     builder: (con) {
                //       return ListView.builder(
                //           shrinkWrap: true,
                //           physics: const NeverScrollableScrollPhysics(),
                //           itemCount: con.prayerTimeList.length,
                //           itemBuilder: (context, index) {
                //             return prayertimeTile('Fajar', '4:28 AM', false);
                //           });
                //     })

                GetBuilder<ApiController>(
                    init: apiController,
                    builder: (con) {
                      return con.prayerTime == null
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                Obx((() => prayertimeTile(
                                    'Fajar',
                                    con.prayerTime!.fajr!,
                                    apiController.isfajar.value))),
                                Obx(
                                  () => prayertimeTile(
                                      'Sunrise',
                                      con.prayerTime!.sunrise!,
                                      apiController.isSunrise.value),
                                ),
                                Obx(
                                  () => prayertimeTile(
                                      'Dhuhr',
                                      con.prayerTime!.dhuhr!,
                                      apiController.isDhuhr.value),
                                ),
                                Obx((() => prayertimeTile(
                                    'Asr',
                                    con.prayerTime!.asr!,
                                    apiController.isAsr.value))),
                                Obx(
                                  () => prayertimeTile(
                                      'Magrib',
                                      con.prayerTime!.maghrib!,
                                      apiController.isMagrib.value),
                                ),
                                Obx(
                                  () => prayertimeTile(
                                      'Isha',
                                      con.prayerTime!.isha!,
                                      apiController.isIsha.value),
                                ),
                              ],
                            );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget prayertimeTile(String name, String time, bool isTime) {
    return Container(
      height: Adaptive.h(5.7),
      width: Adaptive.w(95),
      // padding: EdgeInsets.symmetric(vertical: Adaptive.h(1)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isTime ? AppConstant().primaryColor : Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: GoogleFonts.nunito(
                    color: isTime ? Colors.white : const Color(0xffC4C4C4),
                    fontWeight: FontWeight.w400,
                    fontSize: Adaptive.px(22))),
            Text(time,
                style: GoogleFonts.nunito(
                    color: isTime ? Colors.white : const Color(0xffC4C4C4),
                    fontWeight: FontWeight.w400,
                    fontSize: Adaptive.px(22))),
          ],
        ),
      ),
    );
  }

  Widget counter() {
    bool isTime = false;
    if (isTime = false) {
      Future.delayed(
        Duration(
          seconds: 2,
        ),
        () {
          setState(() {
            isTime = true;
            print('is time is $isTime');
          });
        },
      );
    }

    return isTime
        ? CountdownTimer(
            endTime: endTime,
            endWidget: const Text('end'),
            widgetBuilder: (_, CurrentRemainingTime? time) {
              if (time == null) {
                return const Text('null');
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.volumeHigh),
                  SizedBox(
                    height: Adaptive.h(3),
                  ),
                  // Text(
                  //   'Time to ${con.prayer}',
                  //   style: Theme.of(context).textTheme.headline5,
                  // ),
                  SizedBox(
                    height: Adaptive.h(3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time.hours.toString().length == 1
                            ? "0${time.hours.toString()}"
                            : time.hours.toString(),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(':'),
                      Text(
                          time.min.toString().length == 1
                              ? "0${time.min.toString()}"
                              : time.min.toString(),
                          style: Theme.of(context).textTheme.headline5),
                      Text(':'),
                      Text(
                          time.sec.toString().length == 1
                              ? "0${time.sec.toString()}"
                              : time.sec.toString(),
                          style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                ],
              );
              // Text(
              //     'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
            },
          )
        : Text('not time');
  }
}
