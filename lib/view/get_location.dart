import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:map_picker/map_picker.dart';

import 'package:geolocator/geolocator.dart';
import 'package:muslim_app/app_constants/app_constants.dart';
import 'package:muslim_app/controllers/api_controller.dart';
import 'package:muslim_app/view/widget/serch_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get_storage/get_storage.dart';

class PickLocationScreen extends StatefulWidget {
  PickLocationScreen({
    Key? key,
    required this.pickLatlong,
    required this.dropLatlong,
    required this.isPick,
  }) : super(key: key);
  LatLng pickLatlong;
  LatLng dropLatlong;
  bool isPick;

  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  final _controller = Completer<GoogleMapController>();

  // RequestController requestController = Get.put(RequestController());
  // MapPickerController mapPickerController = MapPickerController();
  // TextEditingController pickController = TextEditingController();
  // TextEditingController dropController = TextEditingController();
  bool isPick = false;
  bool ishowPrediction = false;
  var pickLng = 0.0;
  var pickLat;

  final box = GetStorage();
  MapPickerController mapPickerController = MapPickerController();
  List<AutocompletePrediction> placePredictions = [];
  void placeAutoComplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
      "input": query,
      "key": 'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0',
    });
    String? response = await NetworkUtilitiy.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.predictions != null) {
        setState(() {
          // print(response);
          PlaceAutocompleteResponse result =
              PlaceAutocompleteResponse.parseAutocompleteResult(response);
          if (result != null) {
            setState(() {
              placePredictions = result.predictions!;
            });
          }
        });
      }
    }
  }

  // var textController = TextEditingController();
  late GoogleMapController mapController;
  assignController() async {
    mapController = await _controller.future;
  }

  @override
  void initState() {
    assignController();
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM').format(now);
    String getDay = DateFormat('dd').format(now);

    apiController.month = formattedDate.split('-').last;
    apiController.year = formattedDate.split('-').first;
    apiController.day = getDay;
    apiController.getPrayresTimming();
  }

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

  String address = '';

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print('address is $address');

    apiController.currentAddress.value = "${place.country} ${place.street}";
  }

  TextEditingController searchController = TextEditingController();
  ApiController apiController = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    CameraPosition cameraPosition = CameraPosition(
      target: box.read('latLng') == null
          ? const LatLng(-4.325, 15.322222)
          : box.read('latLng') as LatLng,
      zoom: 14.4746,
    );
    setState(() {});
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: Adaptive.w(5),
              ),
              SizedBox(
                width: Adaptive.w(90),
                child: TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: searchController,
                  onChanged: (value) async {
                    // widget.isPick = true;
                    ishowPrediction = true;
                    placeAutoComplete(value);
                    final geocoding = GoogleMapsGeocoding(
                        apiKey: 'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0');
                    final response = await geocoding
                        .searchByPlaceId(placePredictions[0].placeId!);
                    var result = response.results[0];
                    pickLat = result.geometry.location.lat;
                    pickLng = result.geometry.location.lng;
                    // widget.isPick
                    //     ? requestController.pickLatLng = LatLng(
                    //         result.geometry.location.lat,
                    //         result.geometry.location.lng)
                    //     : requestController.dropLatLng = LatLng(
                    //         result.geometry.location.lat,
                    //         result.geometry.location.lng);
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      // width: Adaptive.w(4.1),
                      // height: Adaptive.h(2.1),
                      child: Image.asset(
                        'assets/images/s_icon.png',
                      ),
                    ),
                    hintText: 'Search',
                    labelStyle: const TextStyle(color: Colors.grey),
                    hintStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppConstant().borderColor, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppConstant().borderColor, width: 1)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppConstant().borderColor, width: 1)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppConstant().borderColor, width: 1)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppConstant().borderColor, width: 1)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: AppConstant().borderColor, width: 1)),
                  ),
                ),
              ),
              SizedBox(
                height: Adaptive.w(5),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    MapPicker(
                      // pass icon widget
                      iconWidget: SvgPicture.asset(
                        "assets/icons/location_icon.svg",
                        height: 40,
                      ),
                      //add map picker controller
                      mapPickerController: mapPickerController,
                      child: GoogleMap(
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        // hide location button
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        //  camera position
                        initialCameraPosition: cameraPosition,

                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onCameraMoveStarted: () {
                          // notify map is moving
                          mapPickerController.mapMoving!();
                          // widget.isPick
                          //     ? requestController.pickLocationController.text =
                          //         "Please Wait ..."
                          //     : requestController.dropLocationController.text;
                          _controller.complete;
                        },
                        onCameraMove: (camPosition) {
                          cameraPosition = camPosition;
                        },
                        onCameraIdle: () async {
                          // notify map stopped moving
                          mapPickerController.mapFinishedMoving!();
                          //get address name from camera position
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                            widget.isPick
                                ? cameraPosition.target.latitude
                                : cameraPosition.target.latitude,
                            widget.isPick
                                ? cameraPosition.target.longitude
                                : cameraPosition.target.longitude,
                          );
                          // widget.isPick
                          //     ? requestController.pickLatLng = LatLng(
                          //         cameraPosition.target.latitude,
                          //         cameraPosition.target.longitude)
                          //     : requestController.dropLatLng = LatLng(
                          //         cameraPosition.target.latitude,
                          //         cameraPosition.target.longitude);
                          print(
                              "now lat is new: ${cameraPosition.target.latitude}");
                          print(
                              "now lng is new :${cameraPosition.target.longitude}");
                          box.write(
                              'latLng',
                              LatLng(cameraPosition.target.latitude,
                                  cameraPosition.target.longitude));
                          print('lat lng is ${box.read('latLng')}');
                          getAddressFromLatLong(cameraPosition.target.latitude,
                              cameraPosition.target.longitude);
                          apiController.latitude =
                              cameraPosition.target.latitude.toString();
                          apiController.longitude =
                              cameraPosition.target.longitude.toString();
                          apiController.getPrayresTimming();
                          // update the ui with the address
                          // widget.isPick
                          //     ? requestController.pickLocationController.text =
                          //         '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}'
                          //     : requestController.dropLocationController.text =
                          //         '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                          // requestController.pickLocationController.text =
                          //     cameraPosition.target.latitude.toString();
                        },
                      ),
                    ),

                    // =================================== TextField =================================================
                    // Positioned(
                    //   top: MediaQuery.of(context).viewPadding.top + 60,
                    //   width: MediaQuery.of(context).size.width - 50,
                    //   child: TextFormField(
                    //     onTap: () {
                    //       // Get.to(() => const PickLocationScreen())!.then((value) {
                    //       //   setState(() {});
                    //       // });
                    //     },
                    //     // controller: widget.isPick
                    //     //     ? requestController.pickLocationController
                    //     //     : requestController.dropLocationController,
                    //     // readOnly: true,
                    //     onChanged: (value) async {
                    //       // widget.isPick = true;
                    //       ishowPrediction = true;
                    //       placeAutoComplete(value);
                    //       final geocoding = GoogleMapsGeocoding(
                    //           apiKey:
                    //               'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0');
                    //       final response = await geocoding
                    //           .searchByPlaceId(placePredictions[0].placeId!);
                    //       var result = response.results[0];
                    //       pickLat = result.geometry.location.lat;
                    //       pickLng = result.geometry.location.lng;
                    //       // widget.isPick
                    //       //     ? requestController.pickLatLng = LatLng(
                    //       //         result.geometry.location.lat,
                    //       //         result.geometry.location.lng)
                    //       //     : requestController.dropLatLng = LatLng(
                    //       //         result.geometry.location.lat,
                    //       //         result.geometry.location.lng);
                    //     },
                    //     textInputAction: TextInputAction.search,
                    //     decoration: InputDecoration(
                    //         // hintText: widget.isPick
                    //         //     ? requestController.pickLocationController.text.isNotEmpty
                    //         //         ? requestController.pickLocationController.text
                    //         //         : requestController.pickLocationController.text
                    //         //     : requestController.dropLocationController.text.isNotEmpty
                    //         //         ? requestController.dropLocationController.text
                    //         //         : requestController.dropLocationController.text,
                    //         ),
                    //   ),
                    // ),

                    Positioned(
                      top: 0,
                      child: ishowPrediction
                          ? Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: placePredictions.length,
                                itemBuilder: (context, index) =>
                                    LocationListTile(
                                  press: () async {
                                    final geocoding = GoogleMapsGeocoding(
                                        apiKey:
                                            'AIzaSyAzr66eCsT-AfdfVw5zoFG0guIHFOeIDr0');
                                    final response = await geocoding
                                        .searchByPlaceId(
                                            placePredictions[index].placeId!)
                                        .then((value) {
                                      setState(() {});

                                      mapController.animateCamera(
                                          CameraUpdate.newLatLngZoom(
                                              LatLng(
                                                  value.results[0].geometry
                                                      .location.lat,
                                                  value.results[0].geometry
                                                      .location.lng),
                                              14));
                                    });
                                    //var result = response.results[index];
                                    //   pickLng = result.geometry.location.lng;
                                    if (widget.isPick == true) {
                                      // requestController.pickLocationController.text =
                                      //     placePredictions[index].description!;
                                      // widget.pickLatlong = LatLng(
                                      //   result.geometry.location.lat,
                                      //   result.geometry.location.lng,
                                      // );
                                      // requestController.pickLatLng = LatLng(
                                      //   result.geometry.location.lat,
                                      //   result.geometry.location.lng,
                                      // );
                                      setState(() {});
                                      // print(
                                      //     "pick screen pick${requestController.pickLatLng!.latitude}");
/////////////////////////////////////////////////
                                      // // mapController.animateCamera(
                                      // //     CameraUpdate.newLatLngZoom(
                                      // //         LatLng(result.geometry.location.lat,
                                      // //             result.geometry.location.lng),
                                      //         14));
                                      //////////////////////////////////////////

                                      // final  mPlace = .get(0);
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      // requestController.dropLocationController.text =
                                      //     placePredictions[index].description!;
                                      // widget.dropLatlong = LatLng(
                                      //     result.geometry.location.lat,
                                      //     result.geometry.location.lng);
                                      // requestController.dropLatLng = LatLng(
                                      //   result.geometry.location.lat,
                                      //   result.geometry.location.lng,
                                      // );
                                      // print(
                                      //     "pick screen drop${requestController.dropLatLng!.latitude}");

                                      ////////////////////////////////
                                      setState(() {});

                                      // mapController.animateCamera(
                                      //     CameraUpdate.newLatLngZoom(
                                      //         LatLng(result.geometry.location.lat,
                                      //             result.geometry.location.lng),
                                      //         14));
                                      //////////////////////////////////////////

                                      // final  mPlace = .get(0);
                                      FocusScope.of(context).unfocus();
                                    }

                                    ishowPrediction = false;
                                    setState(() {});
                                  },
                                  location:
                                      placePredictions[index].description!,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 30,
                      child: Container(
                        color: Colors.white,
                        child: IconButton(
                          onPressed: () async {
                            var position = await _determinePosition();
                            await getAddressFromLatLong(
                                position.latitude, position.longitude);

                            // final GoogleMapController controller =
                            //     await mapController.future;
                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(
                                        position.latitude, position.longitude),
                                    zoom: 14)));
                          },
                          icon: const Icon(Icons.my_location),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 24,
                    //   left: 24,
                    //   right: 24,
                    //   child: SizedBox(
                    //     height: 50,
                    //     child: TextButton(
                    //       child: const Text(
                    //         "Pick Location",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w400,
                    //           fontStyle: FontStyle.normal,
                    //           color: Color(0xFFFFFFFF),
                    //           fontSize: 19,
                    //           height: 19 / 19,
                    //         ),
                    //       ),
                    //       onPressed: () {
                    //         // requestController.lat = cameraPosition.target.latitude;
                    //         // requestController.lng = cameraPosition.target.longitude;
                    //         // print(
                    //         //     "New Location ${requestController.lat} ${requestController.lng}");

                    //         // print(
                    //         //     "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                    //         // print(
                    //         //     "Address: ${requestController.pickLocationController.text}");
                    //         Navigator.pop(context);
                    //       },
                    //       style: ButtonStyle(
                    //         backgroundColor:
                    //             MaterialStateProperty.all<Color>(const Color(0xFFA3080C)),
                    //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(15.0),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The Autocomplete response contains place predictions and status
class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      // ignore: prefer_null_aware_operators
      predictions: json['predictions'] != null
          ? json['predictions']
              .map<AutocompletePrediction>(
                  (json) => AutocompletePrediction.fromJson(json))
              .toList()
          : null,
    );
  }

  static PlaceAutocompleteResponse parseAutocompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}

class AutocompletePrediction {
  /// [description] contains the human-readable name for the returned result. For establishment results, this is usually
  /// the business name.
  final String? description;

  /// [structuredFormatting] provides pre-formatted text that can be shown in your autocomplete results
  final StructuredFormatting? structuredFormatting;

  /// [placeId] is a textual identifier that uniquely identifies a place. To retrieve information about the place,
  /// pass this identifier in the placeId field of a Places API request. For more information about place IDs.
  final String? placeId;

  /// [reference] contains reference.
  final String? reference;

  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeId,
    this.reference,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}

class StructuredFormatting {
  /// [mainText] contains the main text of a prediction, usually the name of the place.
  final String? mainText;

  /// [secondaryText] contains the secondary text of a prediction, usually the location of the place.
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}

class NetworkUtilitiy {
  static Future<String?> fetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: SvgPicture.asset("assets/icons/location_pin.svg"),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }
}
