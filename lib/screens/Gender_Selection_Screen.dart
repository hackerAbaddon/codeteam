import 'package:codeteams/screens/HeightScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(GenderSelectionApp());

class GenderSelectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GenderSelectionScreen(),
    );
  }
}

class GenderSelectionScreen extends StatefulWidget {
  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> with SingleTickerProviderStateMixin {
  String selectedGender = "Male";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedGender = _getGenderFromIndex(_tabController.index);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Skipped!")),
              );
            },
            child: Text(
              "Skip",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Indicator
            Row(
              children: [
                _progressIndicator(true),
                SizedBox(width: 8),
                _progressIndicator(true),
                SizedBox(width: 8),
                _progressIndicator(false),
                SizedBox(width: 8),
                _progressIndicator(false),
              ],
            ),
            SizedBox(height: 32),
            // Title and Subtitle
            Text(
              "Select your Gender",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Help us to create your personalized plan",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32),
            // Gender Options
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _genderOption("Female", "assets/image/Group 1.png"),
                  _genderOption("Male", "assets/image/Group 2.png"),
                ],
              ),
            ),
            SizedBox(height: 24),
            // "Other" Button between Gender Options and TabBar
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedGender = "Other";
                  _tabController.index = 2; // Select the "Other" tab
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected: Other")),
                );
              },
              child: Container(
                width: 159,
                height: 49,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: selectedGender == "Other" ? Colors.purple[50] : Colors.white,
                ),
                child: Center(
                  child: Text(
                    "Other",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            // TabBar for Gender Selection
            Container(
              width: 356,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.purple, // background color of selected tab
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
                labelColor: Colors.white, // color of text in selected tab
                unselectedLabelColor: Colors.black, // color of text in unselected tab
                tabs: [
                  Tab(text: "Male"),
                  Tab(text: "Female"),
                  Tab(text: "Other"),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Gender Selected Display
            Text(
              "Selected Gender: $selectedGender",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            // Circular Action Button
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected Gender: $selectedGender")),
                );
              },
              child: InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>HeightScreen(gender: '$selectedGender',)
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
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper to get gender from TabBar index
  String _getGenderFromIndex(int index) {
    switch (index) {
      case 0:
        return "Male";
      case 1:
        return "Female";
      case 2:
        return "Other";
      default:
        return "Male";
    }
  }

  // Progress Indicator Widget
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

  // Gender Option Widget
  Widget _genderOption(String gender, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
          _tabController.index = _getIndexFromGender(gender); // Sync TabBar with selection
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected: $gender")),
        );
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedGender == gender ? Colors.purple : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              if (selectedGender == gender)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            gender,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to get TabBar index from gender
  int _getIndexFromGender(String gender) {
    switch (gender) {
      case "Male":
        return 0;
      case "Female":
        return 1;
      case "Other":
        return 2;
      default:
        return 0;
    }
  }
}
