import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'WeightScreen.dart';

class HeightScreen extends StatelessWidget {
  final String gender;
  final RxInt height = 165.obs;

  HeightScreen({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: SizedBox(),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(WeightScreen(height: height.string, gender: gender,));

            },
            child: Text("Skip", style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                _progressIndicator(true),
                SizedBox(width: 8),
                _progressIndicator(true),
                SizedBox(width: 8),
                _progressIndicator(true),
                SizedBox(width: 8),
                _progressIndicator(false),
              ],
            ),
            SizedBox(height: 32),
            Text(
              "What’s your height?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Help us to create your personalized plan",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 275,
                  width: 115,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset('assets/image/Group.png'),
                ),
                SizedBox(width: 20),
                Obx(
                      () => Column(
                    children: [
                      RotatedBox(
                        quarterTurns: 3,
                        child: Slider(
                          value: height.value.toDouble(),
                          min: 145,
                          max: 190,
                          divisions: 45,
                          activeColor: Colors.purple,
                          onChanged: (value) {
                            height.value = value.toInt();
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${height.value} CM",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                // Pass height in CM and gender, along with a calculated weight (if applicable)
                Get.to(() => WeightScreen(
                  height: height.value.toString(),
                  gender: gender, // Gender value

                ));
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

Widget _progressIndicator(bool isActive) {
  return Expanded(
    child: Container(
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? Colors.purple : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}
