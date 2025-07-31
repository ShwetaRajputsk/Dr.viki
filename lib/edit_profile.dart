import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _healthConcernsController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedLifestyle;
  File? _selectedImageFile;
  String? _imageUrl;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _lifestyleOptions = [
    'Sedentary (Little to no exercise)',
    'Light Activity (Light exercise 1-3 days/week)',
    'Moderate Activity (Moderate exercise 3-5 days/week)',
    'Very Active (Hard exercise 6-7 days/week)',
    'Extremely Active (Physical job + exercise)'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    _occupationController.dispose();
    _medicalHistoryController.dispose();
    _healthConcernsController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = data['name'] ?? 'Aditya Kumar';
            _emailController.text = data['email'] ?? 'aditya@example.com';
            _ageController.text = data['age']?.toString() ?? '28';
            _heightController.text = data['height']?.toString() ?? '';
            _weightController.text = data['weight']?.toString() ?? '';
            _locationController.text = data['location'] ?? '';
            _occupationController.text = data['occupation'] ?? '';
            _medicalHistoryController.text = data['medicalHistory'] ?? '';
            _healthConcernsController.text = data['healthConcerns'] ?? '';
            _selectedGender = data['gender'];
            _selectedLifestyle = data['lifestyle'];
            _imageUrl = data['imageUrl'];
          });
        }
      } catch (e) {
        print('Error loading user profile: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image picking is not supported on web in this version.")),
      );
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImageFile = File(image.path);
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final age = int.tryParse(_ageController.text) ?? 28;
      final height = double.tryParse(_heightController.text) ?? 0.0;
      final weight = double.tryParse(_weightController.text) ?? 0.0;
      final location = _locationController.text.trim();
      final occupation = _occupationController.text.trim();
      final medicalHistory = _medicalHistoryController.text.trim();
      final healthConcerns = _healthConcernsController.text.trim();
      final gender = _selectedGender ?? 'Male';
      final lifestyle = _selectedLifestyle;

      if (name.isEmpty || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Name and email cannot be empty")),
        );
        return;
      }

      Map<String, dynamic> profileData = {
        'name': name,
        'email': email,
        'age': age,
        'height': height,
        'weight': weight,
        'location': location,
        'occupation': occupation,
        'medicalHistory': medicalHistory,
        'healthConcerns': healthConcerns,
        'gender': gender,
        'lifestyle': lifestyle,
        'profileCompleted': true,
        'profileCompletedAt': FieldValue.serverTimestamp(),
      };

      if (_selectedImageFile != null) {
        try {
          final storageRef = FirebaseStorage.instance.ref();
          final imageRef = storageRef.child('profile_images/${user.uid}.jpg');
          await imageRef.putFile(_selectedImageFile!);
          final imageUrl = await imageRef.getDownloadURL();
          profileData['imageUrl'] = imageUrl;
          setState(() => _imageUrl = imageUrl);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error uploading image")),
          );
          return;
        }
      }

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(profileData, SetOptions(merge: true));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC), // Warm Sand Beige
      appBar: AppBar(
        backgroundColor: const Color(0xFFA7C7A1), // Healing Sage Green
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _updateProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Image Section
            Container(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFA7C7A1), // Healing Sage Green
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _selectedImageFile != null
                            ? FileImage(_selectedImageFile!)
                            : _imageUrl != null
                                ? NetworkImage(_imageUrl!)
                                : null,
                        child: _selectedImageFile == null && _imageUrl == null
                            ? Icon(
                                Icons.person_outline,
                                size: 60,
                                color: const Color(0xFFA7C7A1),
                              )
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: MediaQuery.of(context).size.width / 2 - 30,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1), // Healing Sage Green
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Fields
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F2F), // Charcoal Grey
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name Field
                  _buildTextField(
                    'Full Name',
                    'Enter your name',
                    _nameController,
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildTextField(
                    'Email',
                    'Enter your email',
                    _emailController,
                    Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Age Field
                  _buildNumberField(
                    'Age',
                    'Enter your age',
                    _ageController,
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  // Gender Field
                  _buildDropdownField(
                    'Gender',
                    _selectedGender,
                    _genderOptions,
                    (value) => setState(() => _selectedGender = value),
                    Icons.people_outline,
                  ),
                  const SizedBox(height: 16),

                  // Height Field
                  _buildNumberField(
                    'Height (cm)',
                    'Enter your height in cm',
                    _heightController,
                    Icons.height,
                  ),
                  const SizedBox(height: 16),

                  // Weight Field
                  _buildNumberField(
                    'Weight (kg)',
                    'Enter your weight in kg',
                    _weightController,
                    Icons.monitor_weight_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Location Field
                  _buildTextField(
                    'Location',
                    'Enter your city/state',
                    _locationController,
                    Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Occupation Field
                  _buildTextField(
                    'Occupation',
                    'Enter your profession',
                    _occupationController,
                    Icons.work_outline,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Health Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F2F), // Charcoal Grey
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Lifestyle Field
                  _buildDropdownField(
                    'Lifestyle',
                    _selectedLifestyle,
                    _lifestyleOptions,
                    (value) => setState(() => _selectedLifestyle = value),
                    Icons.fitness_center,
                  ),
                  const SizedBox(height: 16),

                  // Medical History Field
                  _buildMultiLineField(
                    'Medical History (Optional)',
                    'Any previous medical conditions, surgeries, or ongoing treatments...',
                    _medicalHistoryController,
                    Icons.medical_services_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Health Concerns Field
                  _buildMultiLineField(
                    'Current Health Concerns',
                    'Describe any current symptoms or health concerns you\'d like to address...',
                    _healthConcernsController,
                    Icons.health_and_safety_outlined,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA7C7A1), // Healing Sage Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F2F2F), // Charcoal Grey
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFA7C7A1), // Healing Sage Green
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFA7C7A1), // Healing Sage Green
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField(String label, String hint, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F2F2F), // Charcoal Grey
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFA7C7A1), // Healing Sage Green
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFA7C7A1), // Healing Sage Green
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> options, Function(String?) onChanged, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F2F2F), // Charcoal Grey
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(option),
                  ),
                );
              }).toList(),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFA7C7A1)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiLineField(String label, String hint, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F2F2F), // Charcoal Grey
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFA7C7A1), // Healing Sage Green
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFA7C7A1), // Healing Sage Green
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ),
      ],
    );
  }
}