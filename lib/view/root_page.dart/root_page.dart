import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_app/view/dash_board_page/dashboard_page.dart';
import 'package:muslim_app/view/get_location.dart';
import 'package:muslim_app/view/map_screen/map_screen.dart';
import 'package:muslim_app/view/prayer_time/prayer_time_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  LatLng? initCoordinates;
  int selectedIndex = 0;

  final List<Widget> _pages = [
    //const MapScreen(),

    PickLocationScreen(
      dropLatlong: const LatLng(-4.325, 15.322222),
      isPick: true,
      pickLatlong: const LatLng(-4.325, 15.322222),
    ),
    const DashBoardPage(),

    const PrayerTimePage()
    // HomePage(),
    // MyJobPage(),
    // CountryListPage(),
    // NotificationPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Adaptive.h(100),
        width: Adaptive.w(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: _pages[selectedIndex]),
            Container(
              height: Adaptive.h(9.8),
              color: const Color(0xffffffff),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  bottomTabs('assets/images/location.png', 0),
                  bottomTabs('assets/images/search.png', 1),
                  bottomTabs('assets/images/mosque.png', 2),
                ],
              ),
              // color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTabs(String image, int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Image.asset(
          image,
          height: Adaptive.px(43),
          width: Adaptive.px(95),
        ));
  }
}
