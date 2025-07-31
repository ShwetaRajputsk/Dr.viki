import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile.dart';
import 'login.dart';
import 'bottom_navigation_bar.dart';
import 'complete_profile.dart';
import 'plans_page.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? _imageUrl;
  String? _name;
  String? _email;
  int? _age;
  String? _gender;
  double? _height;
  double? _weight;
  String? _location;
  String? _occupation;
  String? _lifestyle;
  String? _medicalHistory;
  String? _healthConcerns;
  bool _profileCompleted = false;
  int _currentIndex = 4;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists && mounted) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          setState(() {
            _imageUrl = data['imageUrl'];
            _name = data['name'] ?? 'Aditya Kumar';
            _email = data['email'] ?? 'aditya@example.com';
            _age = data['age'] ?? 28;
            _gender = data['gender'];
            _height = data['height']?.toDouble();
            _weight = data['weight']?.toDouble();
            _location = data['location'];
            _occupation = data['occupation'];
            _lifestyle = data['lifestyle'];
            _medicalHistory = data['medicalHistory'];
            _healthConcerns = data['healthConcerns'];
            _profileCompleted = data['profileCompleted'] ?? false;
          });
        }
      } catch (e) {
        print("Error loading user profile: $e");
      }
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
                    // Back Button
                    Icon(
                      Icons.arrow_back,
                      color: const Color(0xFFAFAFAF), // Soft Ash
                      size: 24,
                    ),
                    // Title
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    // Edit Button
                    Icon(
                      Icons.edit,
                      color: const Color(0xFFA7C7A1), // Healing Sage Green
                      size: 24,
                    ),
                  ],
                ),
              ),

              // User Profile Summary Card
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
                    children: [
                      // User Avatar and Info
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFA7C7A1), // Healing Sage Green
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(_name ?? 'Aditya Kumar'),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _name ?? 'Aditya Kumar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2F2F2F), // Charcoal Grey
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _email ?? 'aditya@example.com',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFFAFAFAF), // Soft Ash
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Vata Dominant',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Statistics Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              '12',
                              'Total Scans',
                              const Color(0xFFA7C7A1), // Healing Sage Green
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildStatItem(
                              '5',
                              'Day Streak',
                              const Color(0xFFE76F51), // Terracotta Orange
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildStatItem(
                              '${_age ?? 28}',
                              'Years Old',
                              const Color(0xFFA7C7A1), // Healing Sage Green
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Achievements Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAchievementCard(
                            Icons.emoji_events,
                            'First Scan',
                            const Color(0xFFA7C7A1), // Healing Sage Green
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildAchievementCard(
                            Icons.local_fire_department,
                            '7-Day Streak',
                            const Color(0xFFE76F51), // Terracotta Orange
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildAchievementCard(
                            Icons.shield,
                            'Balance Master',
                            const Color(0xFFA7C7A1), // Healing Sage Green
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Settings List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildSettingItem(
                      Icons.edit,
                      'Edit Profile',
                      const Color(0xFFA7C7A1), // Healing Sage Green
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    _buildSettingItem(
                      Icons.settings,
                      'Settings',
                      const Color(0xFFA7C7A1), // Healing Sage Green
                    ),
                    SizedBox(height: 12),
                    _buildSettingItem(
                      Icons.help_outline,
                      'Help & Support',
                      const Color(0xFFE76F51), // Terracotta Orange
                    ),
                    SizedBox(height: 12),
                    _buildSettingItem(
                      Icons.shield,
                      'Privacy Policy',
                      const Color(0xFFA7C7A1), // Healing Sage Green
                    ),
                    SizedBox(height: 12),
                    _buildSettingItem(
                      Icons.card_membership,
                      'Plans',
                      const Color(0xFF27C2A4), // Futuristic Teal Glow
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlansPage()),
                        );
                      },
                    ),
                  ],
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

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }
    return 'AK';
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
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
    );
  }

  Widget _buildAchievementCard(IconData icon, String title, Color color) {
    return Container(
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
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2F2F2F), // Charcoal Grey
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              color: color,
              size: 20,
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2F2F2F), // Charcoal Grey
              ),
            ),
            Spacer(),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFFAFAFAF), // Soft Ash
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
