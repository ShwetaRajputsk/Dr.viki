import 'package:flutter/material.dart';

class DoshaGuidePage extends StatefulWidget {
  @override
  _DoshaGuidePageState createState() => _DoshaGuidePageState();
}

class _DoshaGuidePageState extends State<DoshaGuidePage> {
  int _selectedDoshaIndex = 0; // 0: Vata, 1: Pitta, 2: Kapha
  int _selectedTabIndex = 0; // 0: Overview, 1: Traits, 2: Balance, 3: Nutrition

  final List<Map<String, dynamic>> _doshas = [
    {
      'name': 'Vata',
      'elements': 'Air + Space',
      'icon': Icons.air,
      'color': const Color(0xFFA7C7A1), // Healing Sage Green
      'description': 'The energy of movement and change',
      'characteristics': [
        'Light, dry, cold, rough, subtle, mobile',
        'Controls breathing, circulation, and nervous system',
        'Governs creativity and flexibility',
        'Responsible for all movement in the body',
      ],
    },
    {
      'name': 'Pitta',
      'elements': 'Fire + Water',
      'icon': Icons.local_fire_department,
      'color': const Color(0xFFE76F51), // Terracotta Orange
      'description': 'The energy of transformation and metabolism',
      'characteristics': [
        'Hot, sharp, light, oily, liquid, spreading',
        'Controls digestion, metabolism, and body temperature',
        'Governs intelligence and understanding',
        'Responsible for all chemical processes in the body',
      ],
    },
    {
      'name': 'Kapha',
      'elements': 'Earth + Water',
      'icon': Icons.landscape,
      'color': const Color(0xFF27C2A4), // Futuristic Teal Glow
      'description': 'The energy of structure and stability',
      'characteristics': [
        'Heavy, slow, cool, oily, smooth, dense',
        'Controls growth, structure, and lubrication',
        'Governs strength and endurance',
        'Responsible for all building processes in the body',
      ],
    },
  ];

  final List<Map<String, dynamic>> _tabs = [
    {'name': 'Overview', 'icon': Icons.visibility},
    {'name': 'Traits', 'icon': Icons.person},
    {'name': 'Balance', 'icon': Icons.balance},
    {'name': 'Nutrition', 'icon': Icons.restaurant},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC), // Warm Sand Beige
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1), // Healing Sage Green
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      // Book Icon Button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1), // Healing Sage Green
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.book,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Dosha Guide',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2F2F2F), // Charcoal Grey
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Learn about your constitution',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFFA7C7A1), // Healing Sage Green
                    ),
                  ),
                ],
              ),
            ),

            // Dosha Selection Cards
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _doshas.length,
                itemBuilder: (context, index) {
                  final dosha = _doshas[index];
                  final isSelected = index == _selectedDoshaIndex;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDoshaIndex = index;
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? dosha['color'].withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? dosha['color'] : Colors.grey.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            dosha['icon'],
                            color: isSelected ? dosha['color'] : const Color(0xFF2F2F2F),
                            size: 24,
                          ),
                          SizedBox(height: 8),
                          Text(
                            dosha['name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? dosha['color'] : const Color(0xFF2F2F2F),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            dosha['elements'],
                            style: TextStyle(
                              fontSize: 10,
                              color: const Color(0xFF2F2F2F),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Sub-Navigation Tabs
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final tab = _tabs[index];
                  final isSelected = index == _selectedTabIndex;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFA7C7A1) : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFA7C7A1) : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tab['icon'],
                            color: isSelected ? Colors.white : const Color(0xFF2F2F2F),
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            tab['name'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF2F2F2F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Main Content Area
            Expanded(
              child: Padding(
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
                      // Dosha Header
                      Row(
                        children: [
                          Icon(
                            _doshas[_selectedDoshaIndex]['icon'],
                            color: _doshas[_selectedDoshaIndex]['color'],
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_doshas[_selectedDoshaIndex]['name']} Dosha',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _doshas[_selectedDoshaIndex]['color'],
                                ),
                              ),
                              Text(
                                _doshas[_selectedDoshaIndex]['elements'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF2F2F2F),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Description
                      Text(
                        _doshas[_selectedDoshaIndex]['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF2F2F2F),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Characteristics
                      Text(
                        'Key Characteristics:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2F2F2F),
                        ),
                      ),
                      SizedBox(height: 8),
                      ...(_doshas[_selectedDoshaIndex]['characteristics'] as List<String>).map((characteristic) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin: EdgeInsets.only(top: 6, right: 12),
                                decoration: BoxDecoration(
                                  color: _doshas[_selectedDoshaIndex]['color'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  characteristic,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF2F2F2F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom CTA Section
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                        color: const Color(0xFFA7C7A1).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.help_outline,
                        color: const Color(0xFFA7C7A1),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Your Dosha',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2F2F2F),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Take a quick assessment',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFFAFAFAF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to dosha assessment
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27C2A4), // Futuristic Teal Glow
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Start Quiz',
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
          ],
        ),
      ),
    );
  }
} 