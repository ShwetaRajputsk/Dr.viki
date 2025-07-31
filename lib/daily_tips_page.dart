import 'package:flutter/material.dart';

class DailyTipsPage extends StatefulWidget {
  @override
  _DailyTipsPageState createState() => _DailyTipsPageState();
}

class _DailyTipsPageState extends State<DailyTipsPage> {
  int _selectedCategoryIndex = 0; // 0: All Tips, 1: Morning, 2: Nutrition, etc.

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All Tips', 'icon': Icons.favorite_outline, 'count': '24'},
    {'name': 'Morning', 'icon': Icons.wb_sunny_outlined, 'count': '8'},
    {'name': 'Nutrition', 'icon': Icons.apple, 'count': '6'},
    {'name': 'Evening', 'icon': Icons.nightlight_outlined, 'count': '5'},
    {'name': 'Exercise', 'icon': Icons.fitness_center, 'count': '5'},
  ];

  final List<Map<String, dynamic>> _tips = [
    {
      'title': 'Start with Warm Water',
      'dosha': 'Vata',
      'doshaColor': const Color(0xFFA7C7A1), // Healing Sage Green
      'description': 'Begin your day with a glass of warm water with lemon to stimulate digestion and balance Vata energy.',
      'duration': '5 min',
      'difficulty': 'Easy',
      'difficultyColor': const Color(0xFFA7C7A1),
      'timeOfDay': 'Morning',
      'benefits': ['Improves digestion', 'Balances Vata', 'Hydrates body'],
      'isFeatured': false,
    },
    {
      'title': 'Cooling Breath Practice',
      'dosha': 'Pitta',
      'doshaColor': const Color(0xFFE76F51), // Terracotta Orange
      'description': 'Practice Sheetali pranayama (cooling breath) to reduce excess heat and calm Pitta dosha.',
      'duration': '10 min',
      'difficulty': 'Medium',
      'difficultyColor': const Color(0xFFE76F51),
      'timeOfDay': 'Anytime',
      'benefits': ['Reduces heat', 'Calms mind', 'Balances Pitta'],
      'isFeatured': false,
    },
    {
      'title': 'Spice Up Your Meals',
      'dosha': 'Kapha',
      'doshaColor': const Color(0xFF27C2A4), // Futuristic Teal Glow
      'description': 'Add warming spices like ginger, turmeric, and black pepper to boost metabolism and balance Kapha.',
      'duration': '2 min',
      'difficulty': 'Easy',
      'difficultyColor': const Color(0xFFA7C7A1),
      'timeOfDay': 'Meals',
      'benefits': ['Boosts metabolism', 'Improves digestion', 'Reduces Kapha'],
      'isFeatured': false,
    },
    {
      'title': 'Oil Pulling Ritual',
      'dosha': 'Vata',
      'doshaColor': const Color(0xFFA7C7A1),
      'description': 'Swish coconut or sesame oil in your mouth for 10-15 minutes to detoxify and strengthen teeth.',
      'duration': '15 min',
      'difficulty': 'Easy',
      'difficultyColor': const Color(0xFFA7C7A1),
      'timeOfDay': 'Morning',
      'benefits': ['Detoxifies mouth', 'Strengthens teeth', 'Improves oral health'],
      'isFeatured': false,
    },
    {
      'title': 'Evening Wind Down',
      'dosha': 'Pitta',
      'doshaColor': const Color(0xFFE76F51),
      'description': 'Create a cooling bedtime routine with gentle stretches and lavender essential oil.',
      'duration': '20 min',
      'difficulty': 'Easy',
      'difficultyColor': const Color(0xFFA7C7A1),
      'timeOfDay': 'Evening',
      'benefits': ['Improves sleep', 'Cools body', 'Reduces stress'],
      'isFeatured': false,
    },
    {
      'title': 'Light Evening Meals',
      'dosha': 'Kapha',
      'doshaColor': const Color(0xFF27C2A4),
      'description': 'Eat your largest meal at lunch and keep dinner light to support healthy metabolism.',
      'duration': '30 min',
      'difficulty': 'Medium',
      'difficultyColor': const Color(0xFFE76F51),
      'timeOfDay': 'Evening',
      'benefits': ['Better digestion', 'Weight management', 'Better sleep'],
      'isFeatured': false,
    },
    {
      'title': 'Grounding Meditation',
      'dosha': 'Vata',
      'doshaColor': const Color(0xFFA7C7A1),
      'description': 'Practice 10 minutes of seated meditation focusing on your connection to the earth.',
      'duration': '10 min',
      'difficulty': 'Medium',
      'difficultyColor': const Color(0xFFE76F51),
      'timeOfDay': 'Morning',
      'benefits': ['Reduces anxiety', 'Grounds energy', 'Calms mind'],
      'isFeatured': false,
    },
    {
      'title': 'Energizing Movement',
      'dosha': 'Kapha',
      'doshaColor': const Color(0xFF27C2A4),
      'description': 'Start your day with 10 minutes of dynamic yoga or light cardio to activate circulation.',
      'duration': '10 min',
      'difficulty': 'Medium',
      'difficultyColor': const Color(0xFFE76F51),
      'timeOfDay': 'Morning',
      'benefits': ['Boosts energy', 'Improves circulation', 'Reduces sluggishness'],
      'isFeatured': false,
    },
  ];

  final Map<String, dynamic> _featuredTip = {
    'title': 'Morning Routine for Balance',
    'dosha': 'Vata',
    'doshaColor': const Color(0xFFA7C7A1),
    'description': 'Create a consistent morning routine with warm water, gentle movement, and mindful breathing to set a positive tone for your day.',
    'duration': '15 min',
    'difficulty': 'Easy',
    'difficultyColor': const Color(0xFFA7C7A1),
  };

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
                        // Lightbulb Icon Button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA7C7A1), // Healing Sage Green
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Daily Tips',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Personalized wellness advice',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                      ),
                    ),
                  ],
                ),
              ),

              // Today's Featured Tip Section
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
                        children: [
                          // Featured Label
                          Row(
                            children: [
                              Icon(
                                Icons.star_outline,
                                color: const Color(0xFFE76F51), // Terracotta Orange
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Today\'s Featured Tip',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE76F51), // Terracotta Orange
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          // Dosha Tag
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFAFAFAF).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _featuredTip['dosha'],
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color(0xFFAFAFAF), // Soft Ash
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        _featuredTip['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2F2F2F), // Charcoal Grey
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _featuredTip['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFAFAFAF), // Soft Ash
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          // Duration
                          Row(
                            children: [
                              Icon(Icons.access_time, color: const Color(0xFFAFAFAF), size: 16),
                              SizedBox(width: 4),
                              Text(
                                _featuredTip['duration'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFFAFAFAF), // Soft Ash
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          // Difficulty
                          Row(
                            children: [
                              Icon(Icons.check_circle_outline, color: _featuredTip['difficultyColor'], size: 16),
                              SizedBox(width: 4),
                              Text(
                                _featuredTip['difficulty'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _featuredTip['difficultyColor'],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          // Bookmark Icon
                          Icon(
                            Icons.bookmark_border,
                            color: const Color(0xFFA7C7A1), // Healing Sage Green
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = index == _selectedCategoryIndex;
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    category['icon'],
                                    color: isSelected ? Colors.white : const Color(0xFF2F2F2F),
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    category['name'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : const Color(0xFF2F2F2F),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    category['count'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected ? Colors.white.withOpacity(0.8) : const Color(0xFFAFAFAF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // All Tips Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Tips',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2F2F2F), // Charcoal Grey
                          ),
                        ),
                        Text(
                          '${_tips.length} tips',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFFAFAFAF), // Soft Ash
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Tips List
                    ..._tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildTipCard(tip),
                    )).toList(),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Daily Reminders Section
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
                          color: const Color(0xFFA7C7A1).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
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
                              'Daily Reminders',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2F2F2F),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Get personalized tips sent to you',
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
                          // Enable reminders
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
                          'Enable',
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
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Heart Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: tip['doshaColor'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_outline,
                  color: tip['doshaColor'],
                  size: 16,
                ),
              ),
              SizedBox(width: 12),
              // Title and Dosha Tag
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        tip['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2F2F2F), // Charcoal Grey
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: tip['doshaColor'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tip['dosha'],
                        style: TextStyle(
                          fontSize: 10,
                          color: tip['doshaColor'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              // Heart Icon
              Icon(
                Icons.favorite_outline,
                color: const Color(0xFFA7C7A1), // Healing Sage Green
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 8),
          
          // Description
          Text(
            tip['description'],
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFFAFAFAF), // Soft Ash
            ),
          ),
          SizedBox(height: 12),
          
          // Details Row
          Row(
            children: [
              // Duration
              Row(
                children: [
                  Icon(Icons.access_time, color: const Color(0xFFAFAFAF), size: 14),
                  SizedBox(width: 4),
                  Text(
                    tip['duration'],
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFAFAFAF), // Soft Ash
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              // Difficulty
              Row(
                children: [
                  Icon(Icons.emoji_events_outlined, color: tip['difficultyColor'], size: 14),
                  SizedBox(width: 4),
                  Text(
                    tip['difficulty'],
                    style: TextStyle(
                      fontSize: 12,
                      color: tip['difficultyColor'],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              // Time of Day
              Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, color: const Color(0xFFAFAFAF), size: 14),
                  SizedBox(width: 4),
                  Text(
                    tip['timeOfDay'],
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFAFAFAF), // Soft Ash
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Benefit Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (tip['benefits'] as List<String>).map((benefit) => 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFA7C7A1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  benefit,
                  style: TextStyle(
                    fontSize: 10,
                    color: const Color(0xFFA7C7A1), // Healing Sage Green
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ).toList(),
          ),
          SizedBox(height: 12),
          
          // Action Row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Mark as done
                },
                child: Text(
                  'Mark as Done',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFA7C7A1), // Healing Sage Green
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  // Share tip
                },
                child: Row(
                  children: [
                    Text(
                      'Share Tip',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFFAFAFAF), // Soft Ash
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.share,
                      color: const Color(0xFFAFAFAF), // Soft Ash
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 