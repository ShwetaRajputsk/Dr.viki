import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'account.dart';
import 'community.dart';
import 'chat.dart';
import 'reports_page.dart';
import 'dosha_guide_page.dart';
import 'daily_tips_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom_app_bar.dart';
import 'bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> _healthConcerns = [];
  int _currentIndex = 0;
  String? _userName;
  String? _userImageUrl;
  bool _showSampleReport = false;

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHealthConcerns();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && mounted) {
          Map<String, dynamic>? data = doc.data();
          if (data != null) {
            setState(() {
              _userName = data['name'];
              _userImageUrl = data['imageUrl'];
            });
          }
        }
      } catch (e) {
        print('Error loading user profile: $e');
      }
    }
  }

  Future<void> _loadHealthConcerns() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && mounted) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          dynamic concerns = data['healthConcerns'];
          
          if (concerns is List) {
            setState(() {
              _healthConcerns = List<Map<String, String>>.from(
                concerns.map((concern) => Map<String, String>.from(concern))
              );
            });
          } else if (concerns is String) {
            // If healthConcerns is a string, convert it to a list format
        setState(() {
              _healthConcerns = [{'concern': concerns}];
        });
      } else {
        setState(() {
          _healthConcerns = [];
        });
          }
        } else if (mounted) {
          setState(() {
            _healthConcerns = [];
          });
        }
      } catch (e) {
        print('Error loading health concerns: $e');
        if (mounted) {
          setState(() {
            _healthConcerns = [];
          });
        }
      }
    }
  }

  Future<void> _saveHealthConcernsToFirestore() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
        await userDocRef.update({
          'healthConcerns': _healthConcerns,
        });
      } catch (e) {
        print('Error saving health concerns to Firestore: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 2) {
      // Navigate to health assessment or symptom checker
      // You can add your health assessment screen here
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC), // Warm Sand Beige
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo and App Name
                    Row(
                          children: [
                            Text(
                          'Dr. ',
                              style: TextStyle(
                            fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2F2F2F), // Charcoal Grey
                              ),
                            ),
                            Text(
                          'ViKi',
                              style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF27C2A4), // Futuristic Teal Glow
                            ),
                        ),
                      ],
                    ),
                    Text(
                      'AI Ayurvedic Assistant',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFFAFAFAF), // Soft Ash
                      ),
                    ),
                    // Profile Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Welcome Message Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA7C7A1).withOpacity(0.2), // Light Healing Sage Green
                    borderRadius: BorderRadius.circular(16),
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            '${_getGreeting()}, ${_userName ?? 'Aditya'}!',
                          style: TextStyle(
                              fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2F2F2F), // Charcoal Grey
                          ),
                        ),
                          SizedBox(width: 8),
                          Text('🌿', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ready to check your wellness today? Let\'s discover your dosha balance and create a personalized wellness journey.',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFAFAFAF), // Soft Ash
                        ),
                        ),
                      ],
                    ),
                ),
              ),

              SizedBox(height: 24),

              // Dosha Health Scan Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dosha Health Scan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2F2F2F), // Charcoal Grey
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                        'Our AI analyzes your eye and tongue photos to detect dosha imbalances and suggest personalized Ayurvedic wellness plans.',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFAFAFAF), // Soft Ash
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Scan Options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildScanOption('👁️', 'Eye Scan'),
                          _buildScanOption('🩺', 'Tongue Analysis'),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Start Health Scan Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to health scan
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE76F51), // Terracotta Orange
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                                ),
                          child: Text(
                            'Start Health Scan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ),
                    ),
                  ],
                ),
              ),
              ),

              SizedBox(height: 24),

              // Your Wellness Snapshot Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Wellness Snapshot',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2F2F2F), // Charcoal Grey
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA7C7A1).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_outline,
                              color: const Color(0xFFA7C7A1), // Healing Sage Green
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Show either empty state or sample report
                      if (!_showSampleReport) ...[
                        // No Scan Results Yet
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFAFAFAF).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.health_and_safety_outlined,
                                  color: const Color(0xFFAFAFAF),
                                  size: 40,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No scan results yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFAFAFAF), // Soft Ash
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Take your first health scan to see your personalized dosha analysis and wellness recommendations',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFFAFAFAF), // Soft Ash
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showSampleReport = true;
                                  });
                                },
                                child: Text(
                                  'View Sample Report',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF27C2A4), // Futuristic Teal Glow
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Sample Report Data
                        Row(
                          children: [
                            // Left side - Dominant Dosha
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                    'Dominant Dosha',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFFAFAFAF), // Soft Ash
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Vata',
                                    style: TextStyle(
                                      fontSize: 18,
                                fontWeight: FontWeight.bold,
                                      color: const Color(0xFF27C2A4), // Futuristic Teal Glow
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Right side - Balance Score
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Balance Score',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFFAFAFAF), // Soft Ash
                                    ),
                                  ),
                                  SizedBox(height: 4),
                            Text(
                                    '75%',
                              style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFE76F51), // Terracotta Orange
                                    ),
                              ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        // Progress Bar
                        Container(
                          width: double.infinity,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFAFAFAF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.75,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFA7C7A1), // Healing Sage Green
                                    const Color(0xFF27C2A4), // Futuristic Teal Glow
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Last scan information
                        Text(
                          'Last scan: 2 days ago',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFFAFAFAF), // Soft Ash
                        ),
                      ),
                        
                        SizedBox(height: 16),
                        
                        // Back to empty state button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showSampleReport = false;
                            });
                          },
                          child: Text(
                            'Back to empty state',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF27C2A4), // Futuristic Teal Glow
                              decoration: TextDecoration.underline,
                        ),
                      ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Wellness Tools Section (Second Screenshot)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wellness Tools',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 16),
                                         GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => DailyTipsPage()),
                         );
                       },
                       child: _buildWellnessToolCard(
                         Icons.lightbulb_outline,
                         'Daily Tips',
                         'Personalized wellness advice',
                         const Color(0xFFA7C7A1), // Healing Sage Green
                       ),
                          ),
                    SizedBox(height: 12),
                                         GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => DoshaGuidePage()),
                         );
                       },
                       child: _buildWellnessToolCard(
                         Icons.book_outlined,
                         'Dosha Guide',
                         'Learn about your constitution',
                         const Color(0xFFA7C7A1), // Healing Sage Green
                       ),
                     ),
                    SizedBox(height: 12),
                                         GestureDetector(
                       onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => ReportsPage()),
                         );
                       },
                       child: _buildWellnessToolCard(
                         Icons.bar_chart_outlined,
                         'My Reports',
                         'Track your wellness journey',
                         const Color(0xFFE76F51), // Terracotta Orange
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Your Progress Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                            'Your Progress',
                      style: TextStyle(
                              fontSize: 18,
                        fontWeight: FontWeight.bold,
                              color: const Color(0xFF2F2F2F), // Charcoal Grey
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE76F51).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.emoji_events_outlined,
                              color: const Color(0xFFE76F51), // Terracotta Orange
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Progress Metrics
                      Row(
                        children: [
                          Expanded(
                            child: _buildProgressMetric(
                              Icons.calendar_today_outlined,
                              '12',
                              'Days Tracked',
                              const Color(0xFFA7C7A1), // Healing Sage Green
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildProgressMetric(
                              Icons.local_fire_department_outlined,
                              '5',
                              'Day Streak',
                              const Color(0xFFA7C7A1), // Healing Sage Green
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Weekly Goal Progress
                      Text(
                        'Weekly Goal Progress',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFAFAFAF), // Soft Ash
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 5/7,
                              backgroundColor: const Color(0xFFAFAFAF).withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF27C2A4), // Futuristic Teal Glow
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '5/7',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE76F51), // Terracotta Orange
                            ),
                          ),
                        ],
                    ),
                    SizedBox(height: 16),
                      
                      // Motivational Message
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_outline,
                              color: const Color(0xFFE76F51), // Terracotta Orange
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Great progress! Keep up your wellness journey.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFFAFAFAF), // Soft Ash
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildScanOption(String emoji, String title) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 32),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2F2F2F), // Charcoal Grey
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessToolCard(IconData icon, String title, String subtitle, Color iconColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2F2F2F), // Charcoal Grey
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 14,
                  color: const Color(0xFFAFAFAF), // Soft Ash
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: const Color(0xFFA7C7A1), // Healing Sage Green
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressMetric(IconData icon, String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
                ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFFAFAFAF), // Soft Ash
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class WeatherService {
  final String apiKey = '3425e18a2e2aa355b35af5bd268e3dfe';

  Future<Map<String, dynamic>> fetchWeather(String location) async {
    final response = await http.get(
      Uri.parse(
          'http://api.weatherstack.com/current?access_key=$apiKey&query=$location'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}