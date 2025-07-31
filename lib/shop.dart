import 'package:flutter/material.dart';
import 'bottom_navigation_bar.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _selectedCategory = 'All Doctors';
  int _currentIndex = 3;
  Map<String, dynamic>? _selectedDoctor;
  String? _selectedDate;
  String? _selectedTime;

  final List<String> _categories = [
    'All Doctors',
    'Stress',
    'Skin',
    'Digestive',
    'Sleep',
    'Women\'s Health',
    'Pediatric',
  ];

  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Neha Sharma',
      'specialty': 'Ayurvedic Consultant',
      'status': 'Online',
      'rating': 4.8,
      'experience': '12 years exp.',
      'fee': '₹500',
      'expertise': ['Stress Management', 'Digestive Health', 'Skin Care'],
      'image': 'assets/images/doctor1.png',
      'isOnline': true,
    },
    {
      'name': 'Dr. Rajesh Patel',
      'specialty': 'Panchakarma Expert',
      'status': 'Offline',
      'rating': 4.9,
      'experience': '18 years exp.',
      'fee': '₹750',
      'expertise': ['Detox Programs', 'Joint Pain', 'Chronic Conditions'],
      'image': 'assets/images/doctor2.png',
      'isOnline': false,
    },
    {
      'name': 'Dr. Priya Menon',
      'specialty': 'Women\'s Wellness',
      'status': 'Online',
      'rating': 4.7,
      'experience': '8 years exp.',
      'fee': '₹450',
      'expertise': ['Hormonal Balance', 'Fertility', 'Pregnancy Care'],
      'image': 'assets/images/doctor3.png',
      'isOnline': true,
    },
    {
      'name': 'Dr. Arjun Kumar',
      'specialty': 'Sleep & Mental Health',
      'status': 'Online',
      'rating': 4.6,
      'experience': '15 years exp.',
      'fee': '₹600',
      'expertise': ['Insomnia', 'Anxiety', 'Depression'],
      'image': 'assets/images/doctor4.png',
      'isOnline': true,
    },
    {
      'name': 'Dr. Kavita Singh',
      'specialty': 'Pediatric Ayurveda',
      'status': 'Offline',
      'rating': 4.9,
      'experience': '20 years exp.',
      'fee': '₹550',
      'expertise': ['Child Health', 'Growth Issues', 'Immunity'],
      'image': 'assets/images/doctor5.png',
      'isOnline': false,
    },
  ];

  final List<String> _availableDates = [
    'Today, Jan 15',
    'Tomorrow, Jan 16',
    'Wed, Jan 17',
    'Thu, Jan 18',
  ];

  final List<String> _availableTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  void _showBookingModal(Map<String, dynamic> doctor) {
    setState(() {
      _selectedDoctor = doctor;
      _selectedDate = null;
      _selectedTime = null;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBookingModal(),
    );
  }

  Widget _buildBookingModal() {
    if (_selectedDoctor == null) return Container();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with close button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 40), // Placeholder for centering
                Text(
                  'Book Consultation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                      decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                      ),
                    child: Icon(
                      Icons.close,
                      color: const Color(0xFF2F2F2F),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Doctor Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(_selectedDoctor!['image']),
                      ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedDoctor!['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2F2F2F),
                      ),
                    ),
                      SizedBox(height: 4),
                      Text(
                        _selectedDoctor!['specialty'],
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFAFAFAF),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _selectedDoctor!['fee'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE76F51),
                        ),
                      ),
                    ],
                      ),
                    ),
                  ],
                ),
              ),

          SizedBox(height: 24),

          // Select Date Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableDates.map((date) {
                    final isSelected = _selectedDate == date;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFFA7C7A1) 
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFFA7C7A1) 
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? Colors.white 
                                : const Color(0xFF2F2F2F),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Select Time Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableTimes.map((time) {
                    final isSelected = _selectedTime == time;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = time;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFFA7C7A1) 
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFFA7C7A1) 
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? Colors.white 
                                : const Color(0xFF2F2F2F),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          Spacer(),

          // Book Consultation Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedDate != null && _selectedTime != null) 
                    ? () {
                        // Handle booking
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Consultation booked successfully!'),
                            backgroundColor: const Color(0xFFA7C7A1),
                    ),
                  );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_selectedDate != null && _selectedTime != null)
                      ? const Color(0xFFA7C7A1)
                      : const Color(0xFFF5F5F5),
                  foregroundColor: (_selectedDate != null && _selectedTime != null)
                      ? Colors.white
                      : const Color(0xFFAFAFAF),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Book Consultation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                      color: const Color(0xFF2F2F2F), // Charcoal Grey
                      size: 24,
                    ),
                    // Title
                    Text(
                      'Talk to a Doctor',
                    style: TextStyle(
                        fontSize: 20,
                      fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                    ),
                  ),
                    // Placeholder for balance
                    SizedBox(width: 24),
                  ],
                ),
              ),

              // Need personalized help Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA7C7A1).withOpacity(0.2), // Light Healing Sage Green
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                  Container(
                        width: 40,
                        height: 40,
                    decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1), // Healing Sage Green
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.medical_services,
                      color: Colors.white,
                          size: 20,
                        ),
                              ),
                      SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                              'Need personalized help?',
                              style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                color: const Color(0xFF2F2F2F), // Charcoal Grey
                              ),
                            ),
                            SizedBox(height: 4),
                                        Text(
                              'Talk to certified Ayurvedic doctors and get personalized wellness guidance based on your unique constitution.',
                                          style: TextStyle(
                                            fontSize: 14,
                                color: const Color(0xFFAFAFAF), // Soft Ash
                                          ),
                                        ),
                                      ],
                        ),
                                    ),
                                  ],
                                ),
                              ),
              ),

              SizedBox(height: 20),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search doctors...',
                      hintStyle: TextStyle(
                        color: const Color(0xFFAFAFAF), // Soft Ash
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: const Color(0xFFAFAFAF), // Soft Ash
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Category Filter Tabs
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFA7C7A1) : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFA7C7A1) : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF2F2F2F),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Doctor Listings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    ..._doctors.map((doctor) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildDoctorCard(doctor),
                    )).toList(),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // AI Assistant Section
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
                  child: Row(
                    children: [
                  Container(
                        width: 40,
                        height: 40,
                    decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1), // Healing Sage Green
                          borderRadius: BorderRadius.circular(8),
                    ),
                        child: Icon(
                          Icons.smart_toy,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Assistant',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2F2F2F), // Charcoal Grey
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'No doctors available? Get instant answers to your wellness questions from our AI assistant.',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFFAFAFAF), // Soft Ash
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to AI chat
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27C2A4), // Futuristic Teal Glow
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Chat with AI',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    final isOnline = doctor['isOnline'] as bool;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
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
          // Header Row
          Row(
            children: [
              // Profile Picture with Online Status
              Stack(
                        children: [
                          CircleAvatar(
                    radius: 30,
                            backgroundImage: AssetImage(doctor['image']),
                          ),
                  if (isOnline)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1), // Healing Sage Green
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16),
              // Doctor Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor['name'],
                      style: TextStyle(
                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 4),
                                    Text(
                                      doctor['specialty'],
                                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFAFAFAF), // Soft Ash
                      ),
                                      ),
                  ],
                ),
              ),
              // Status Tag
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isOnline 
                      ? const Color(0xFFA7C7A1).withOpacity(0.1) 
                      : const Color(0xFFAFAFAF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  doctor['status'],
                                      style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOnline 
                        ? const Color(0xFFA7C7A1) // Healing Sage Green
                        : const Color(0xFFAFAFAF), // Soft Ash
                  ),
                                      ),
                                    ),
                                  ],
                                ),
          SizedBox(height: 12),
          
          // Rating and Experience Row
                                Row(
                                  children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '${doctor['rating']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2F2F2F), // Charcoal Grey
                ),
              ),
              SizedBox(width: 8),
              Text(
                doctor['experience'],
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFFAFAFAF), // Soft Ash
                ),
              ),
              Spacer(),
                                    Text(
                doctor['fee'],
                                      style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE76F51), // Terracotta Orange
                                      ),
                                    ),
                                  ],
                                ),
          SizedBox(height: 12),
          
          // Expertise Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (doctor['expertise'] as List<String>).take(2).map((expertise) => 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFAFAFAF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  expertise,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFAFAFAF), // Soft Ash
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ).toList()..add(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFAFAFAF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+1 more',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFAFAFAF), // Soft Ash
                    fontWeight: FontWeight.w500,
                      ),
                    ),
              ),
            ),
          ),
          SizedBox(height: 12),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isOnline ? () {
                _showBookingModal(doctor);
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isOnline 
                    ? const Color(0xFFE76F51) // Terracotta Orange
                    : const Color(0xFFAFAFAF), // Soft Ash
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isOnline ? 'Book Consultation' : 'Currently Offline',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
