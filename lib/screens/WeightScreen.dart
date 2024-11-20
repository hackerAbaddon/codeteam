import 'dart:convert';
import 'dart:math';
import 'package:codeteams/controller/profilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class WeightScreen extends StatelessWidget {
  final String height;
  final String gender;
  final RxDouble weight = 95.0.obs;
  final RxBool isKg = true.obs; // Flag to track whether Kg or Lbs is selected

  WeightScreen({super.key, required this.height, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Skip", style: TextStyle(color: Colors.purple)),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                _progressIndicator(true),
                SizedBox(width: 8),
                _progressIndicator(true),
                SizedBox(width: 8),
                _progressIndicator(true),
                SizedBox(width: 8),
                _progressIndicator(true),
              ],
            ),
            SizedBox(height: 32),
            Text(
              "What’s your Weight?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Help us to create your personalize plan",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 40),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: WeightToggle(
                      label: "Kg",
                      isSelected: isKg.value,
                      onTap: () => isKg.value = true,
                    ),
                  ),
                  WeightToggle(
                    label: "LBS",
                    isSelected: !isKg.value,
                    onTap: () => isKg.value = false,
                  ),
                ],
              );
            }),
            SizedBox(height: 40),
            Obx(() {
              double displayedWeight = isKg.value
                  ? weight.value
                  : weight.value * 2.20462;
              displayedWeight = double.parse(displayedWeight.toStringAsFixed(1));

              return Column(
                children: [
                  DraggableCircularSlider(
                    weight: weight,
                  ),
                  SizedBox(height: 20),
                  // Weight Text
                  Text(
                    "$displayedWeight ${isKg.value ? 'Kg' : 'LBS'}",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ],
              );
            }),
            Spacer(),
            // Next Button
            InkWell(
              onTap: () async {
                // Determine the weight type
                String weightType = isKg.value ? "KG" : "LBS";

                // Calculate the final weight
                double finalWeight = isKg.value ? weight.value : weight.value * 2.20462;
                finalWeight = double.parse(finalWeight.toStringAsFixed(1));

                // Call the ProfileController to submit the data
                final profileController = Get.find<ProfileController>();
                await profileController.submitProfile(
                  gender: gender,
                  height: int.parse(height),
                  weight: finalWeight,
                  weightType: weightType, // Pass the weight type
                );

                // Debugging outputs
                print('Final Weight: $finalWeight $weightType');
                print('Gender: $gender');
                print('Height: $height');
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
}

// Custom Draggable Circular Slider
class DraggableCircularSlider extends StatefulWidget {
  final RxDouble weight;

  DraggableCircularSlider({required this.weight});

  @override
  _DraggableCircularSliderState createState() =>
      _DraggableCircularSliderState();
}

class _DraggableCircularSliderState extends State<DraggableCircularSlider> {
  double angle = pi / 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          final dx = details.localPosition.dx - 100;
          final dy = details.localPosition.dy - 100;
          angle = atan2(dy, dx);
          double percentage = (angle + pi) / (2 * pi);
          double newWeight = 40 + (percentage * 110);
          widget.weight.value = newWeight.clamp(40.0, 150.0);
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 220,
            width: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          // Active Arc
          CustomPaint(
            size: Size(220, 220),
            painter: ArcPainter(angle: angle),
          ),
          Transform.rotate(
            angle: angle - (pi / 2),
            child: Container(
              height: 100,
              width: 4,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Arc Painter for Active Arc
class ArcPainter extends CustomPainter {
  final double angle;

  ArcPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    canvas.drawArc(
      rect,
      -pi / 2,
      angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Toggle for Weight Unit (Kg or Lbs)
class WeightToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  WeightToggle({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  final String weight;
  final String gender;
  final String height;

  NextScreen({super.key, required this.weight, required this.gender, required this.height});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next Screen"),
      ),
      body: Center(
        child: Text(
          'Weight: $weight\nGender: $gender\nHeight: $height',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
