import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class APIServices {
  Future<http.Response?> getPyartime(
      String latitude, String longitude, String month, String year) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(
            //'http://api.aladhan.com/v1/calendar?latitude=51.508515&longitude=-0.1254872&method=2&month=4&year=2017'),
            'http://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&method=2&month=$month&year=$year'),
      );
      return response;
    } on SocketException {
      Get.snackbar("Connection Error", "No internet connection");
    }
  }
}
