import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  // Default values
  RxString gender = 'Male'.obs;
  RxInt height = 165.obs;
  RxDouble weight = 95.0.obs;

  final String baseUrl = "http://157.15.202.189:7002";
  final String token =
      "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJVbWVzaCIsInJvbGVJZCI6MiwiZXhwIjoxNzU0NDU1MDY5LCJpYXQiOjE3MjI5MTkwNjl9.WwBZtiNMQAeerkqkQL2MQjNVyfAEn7gE8CzzU0XpCIE";

  // Modified submitProfile method to accept dynamic parameters
  Future<void> submitProfile({required String gender, required int height, required double weight}) async {
    final url = Uri.parse("$baseUrl/patient/patient_info?patientId=73");

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "gender": gender,
      "height": height,
      "heightType": "CM",
      "weight": weight,
      "weightType": "KG",
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully',
            snackPosition: SnackPosition.BOTTOM);

      } else {
        Get.snackbar('Error', 'Failed to update profile',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
