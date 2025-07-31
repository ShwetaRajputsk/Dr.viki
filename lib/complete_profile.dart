import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class CompleteProfileScreen extends StatefulWidget {
  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _healthConcernsController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedLifestyle;
  
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _lifestyleOptions = [
    'Sedentary (Little to no exercise)',
    'Light Activity (Light exercise 1-3 days/week)',
    'Moderate Activity (Moderate exercise 3-5 days/week)',
    'Very Active (Hard exercise 6-7 days/week)',
    'Extremely Active (Physical job + exercise)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA7C7A1),
        elevation: 0,
        title: Text(
          'Complete Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Image.asset(
                    'assets/Logo.png',
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Help Dr. ViKi understand your health profile for personalized recommendations',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF2F2F2F),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Age Field
                Text(
                  'Age',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter your age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person_outline, color: const Color(0xFFA7C7A1)),
                  ),
                ),
                const SizedBox(height: 16),

                // Gender Field
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    items: _genderOptions.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.people_outline, color: const Color(0xFFA7C7A1)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Height Field
                Text(
                  'Height (cm)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter your height in cm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.height, color: const Color(0xFFA7C7A1)),
                  ),
                ),
                const SizedBox(height: 16),

                // Weight Field
                Text(
                  'Weight (kg)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter your weight in kg',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.monitor_weight_outlined, color: const Color(0xFFA7C7A1)),
                  ),
                ),
                const SizedBox(height: 16),

                // Location Field
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'Enter your city/state',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.location_on_outlined, color: const Color(0xFFA7C7A1)),
                  ),
                ),
                const SizedBox(height: 16),

                // Occupation Field
                Text(
                  'Occupation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _occupationController,
                  decoration: InputDecoration(
                    hintText: 'Enter your profession',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.work_outline, color: const Color(0xFFA7C7A1)),
                  ),
                ),
                const SizedBox(height: 16),

                // Lifestyle Field
                Text(
                  'Lifestyle',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLifestyle,
                    items: _lifestyleOptions.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLifestyle = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.fitness_center, color: const Color(0xFFA7C7A1)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Medical History Field
                Text(
                  'Medical History (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _medicalHistoryController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Any previous medical conditions, surgeries, or ongoing treatments...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.medical_services_outlined, color: const Color(0xFFA7C7A1)),
                  ),
                ),
                const SizedBox(height: 16),

                // Health Concerns Field
                Text(
                  'Current Health Concerns',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _healthConcernsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe any current symptoms or health concerns you\'d like to address...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.health_and_safety_outlined, color: const Color(0xFFA7C7A1)),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA7C7A1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Complete Profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    try {
      print('Saving profile...');
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('User found: ${user.uid}');
        
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': _selectedGender,
          'height': double.tryParse(_heightController.text) ?? 0.0,
          'weight': double.tryParse(_weightController.text) ?? 0.0,
          'location': _locationController.text,
          'occupation': _occupationController.text,
          'lifestyle': _selectedLifestyle,
          'medicalHistory': _medicalHistoryController.text,
          'healthConcerns': _healthConcernsController.text,
          'profileCompleted': true,
          'profileCompletedAt': FieldValue.serverTimestamp(),
        });

        print('Profile saved successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile completed successfully!'),
            backgroundColor: const Color(0xFFA7C7A1),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print('No user found');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: No user found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 