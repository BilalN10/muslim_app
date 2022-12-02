import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_app/controllers/api_controller.dart';
import 'package:muslim_app/utils/size_config.dart';
import 'package:muslim_app/view/get_location.dart';
import 'package:muslim_app/view/widget/serch_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const DEFAULT_ZOOM = 14.4746;
  ApiController apiController = Get.put(ApiController());

  static const KINSHASA_LOCATION = LatLng(-4.325, 15.322222);
  Completer<GoogleMapController> mapController = Completer();

  LatLng? initCoordinates;
  double? initZoom;
  LatLng? value;
  String address = '';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('service is $serviceEnabled');
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings().then((value) {
        print('setting open value is $value');
      });
      return Future.error('Location services are disabled.');
    }

    print('service is $serviceEnabled');

    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print('address is $address');
  }

  @override
  void initState() {
    initCoordinates = KINSHASA_LOCATION;
    initZoom = DEFAULT_ZOOM;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM').format(now);
    String getDay = DateFormat('dd').format(now);

    apiController.month = formattedDate.split('-').last;
    apiController.year = formattedDate.split('-').first;
    apiController.day = getDay;

    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: Adaptive.h(2),
            ),
            SizedBox(
                width: Adaptive.w(90),
                child: SearchFiled(textEditingController: searchController)),
            SizedBox(
              height: Adaptive.h(5),
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => PickLocationScreen(
                        dropLatlong: initCoordinates!,
                        isPick: true,
                        pickLatlong: initCoordinates!,
                      ));
                },
                child: Text('hi')),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var maxWidth = constraints.biggest.width;
                  var maxHeight = constraints.biggest.height;

                  return Stack(
                    children: <Widget>[
                      SizedBox(
                        height: maxHeight,
                        width: maxWidth,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: initCoordinates!,
                            zoom: initZoom!,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            mapController.complete(controller);
                          },
                          onCameraMove: (CameraPosition newPosition) {
                            print(
                                'new position is ${newPosition.target.latitude}');
                            print(
                                'new position is ${newPosition.target.latitude}');

                            print('longitude  ${newPosition.target.latitude}');

                            newPosition.target.latitude;
                            apiController.latitude =
                                newPosition.target.latitude.toString();
                            apiController.longitude =
                                newPosition.target.longitude.toString();

                            value = newPosition.target;
                          },
                          mapType: MapType.normal,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomGesturesEnabled: true,
                          padding: const EdgeInsets.all(0),
                          buildingsEnabled: true,
                          cameraTargetBounds: CameraTargetBounds.unbounded,
                          compassEnabled: true,
                          indoorViewEnabled: false,
                          mapToolbarEnabled: true,
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          trafficEnabled: false,
                        ),
                      ),
                      Positioned(
                        bottom: maxHeight / 2,
                        right: (maxWidth - 30) / 2,
                        child: const Icon(
                          Icons.person_pin_circle,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 30,
                        child: Container(
                          color: Colors.white,
                          child: IconButton(
                            onPressed: () async {
                              var position = await _determinePosition();
                              await getAddressFromLatLong(position);

                              final GoogleMapController controller =
                                  await mapController.future;
                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(position.latitude,
                                          position.longitude),
                                      zoom: initZoom!)));
                            },
                            icon: const Icon(Icons.my_location),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Expanded(
            //   child: GoogleMap(
            //     initialCameraPosition: CameraPosition(
            //       target: initCoordinates!,
            //       zoom: initZoom!,
            //     ),
            //     onMapCreated: (GoogleMapController controller) {
            //       mapController.complete(controller);
            //     },
            //     onCameraMove: (CameraPosition newPosition) {
            //       print('new position is ${newPosition.target.latitude}');

            //       print('longitude  ${newPosition.target.latitude}');

            //       newPosition.target.latitude;
            //       apiController.latitude =
            //           newPosition.target.latitude.toString();
            //       apiController.longitude =
            //           newPosition.target.longitude.toString();
            //     },
            //     mapType: MapType.normal,
            //     myLocationButtonEnabled: true,
            //     myLocationEnabled: true,
            //     zoomGesturesEnabled: true,
            //     padding: const EdgeInsets.all(0),
            //     buildingsEnabled: true,
            //     cameraTargetBounds: CameraTargetBounds.unbounded,
            //     compassEnabled: true,
            //     indoorViewEnabled: false,
            //     mapToolbarEnabled: true,
            //     minMaxZoomPreference: MinMaxZoomPreference.unbounded,
            //     rotateGesturesEnabled: true,
            //     scrollGesturesEnabled: true,
            //     tiltGesturesEnabled: true,
            //     trafficEnabled: false,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
