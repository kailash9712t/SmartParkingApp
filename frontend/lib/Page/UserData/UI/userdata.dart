import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: UploadPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upload Page',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF6C7CE7).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.cloud_upload_outlined,
                          color: Color(0xFF6C7CE7),
                          size: 28,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'go to select an image from gallery',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDetailsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C7CE7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  String selectedGender = 'Male';
  String selectedExperience = 'Beginner';
  double ageValue = 25;
  
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> experienceOptions = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Gender Dropdown
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGender,
                            hint: Text('gender', style: TextStyle(color: Colors.white70)),
                            dropdownColor: Color(0xFF1A1A1A),
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGender = newValue!;
                              });
                            },
                            items: genderOptions.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Experience Dropdown
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedExperience,
                            hint: Text('experience', style: TextStyle(color: Colors.white70)),
                            dropdownColor: Color(0xFF1A1A1A),
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedExperience = newValue!;
                              });
                            },
                            items: experienceOptions.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      
                      // Age Slider
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: Colors.white,
                              overlayColor: Colors.white.withOpacity(0.2),
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                              trackHeight: 2,
                            ),
                            child: Slider(
                              value: ageValue,
                              min: 18,
                              max: 75,
                              divisions: 57,
                              onChanged: (double value) {
                                setState(() {
                                  ageValue = value;
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '18',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                              Text(
                                '${ageValue.round()}',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '75',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              
              // Navigation Buttons
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                      onPressed: () {
                        // Handle next action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('User details saved!'),
                            backgroundColor: Color(0xFF6C7CE7),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}