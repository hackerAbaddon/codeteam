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
  Future<Map<String, dynamic>?> submitProfile({
    required String gender,
    required int height,
    required double weight,
    required String weightType,
  }) async {
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
      "weightType": weightType, // Adding weightType dynamically
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response Data: $data');

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        return data; // Return the parsed response.
      } else {
        print('Error: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to update profile: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null; // Return null if there’s an error.
  }


}
