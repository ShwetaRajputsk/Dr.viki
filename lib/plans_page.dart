import 'package:flutter/material.dart';

class PlansPage extends StatefulWidget {
  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  String _selectedPlan = 'Basic Wellness'; // Default selected plan

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Basic Wellness',
      'price': '\$9.99',
      'period': '/month',
      'icon': Icons.favorite,
      'color': const Color(0xFFA7C7A1), // Healing Sage Green
      'features': [
        'Daily dosha tips',
        'Basic health scans',
        'Weekly progress reports',
        'Community access',
        'Basic meditation guides',
      ],
      'isCurrent': true,
      'isPopular': false,
    },
    {
      'name': 'Premium Balance',
      'price': '\$19.99',
      'period': '/month',
      'icon': Icons.favorite,
      'color': const Color(0xFFA7C7A1), // Healing Sage Green
      'features': [
        'Unlimited health scans',
        'Personalized meal plans',
        'Advanced dosha analysis',
        'Live yoga sessions',
        'Personal wellness coach',
        'Priority support',
      ],
      'isCurrent': false,
      'isPopular': true,
    },
    {
      'name': 'Family Harmony',
      'price': '\$29.99',
      'period': '/month',
      'icon': Icons.favorite,
      'color': const Color(0xFFE76F51), // Terracotta Orange
      'features': [
        'Up to 4 family members',
        'Family wellness dashboard',
        'Customized plans for each member',
        'Group meditation sessions',
        'Nutrition planning for family',
        'Expert consultations',
      ],
      'isCurrent': false,
      'isPopular': false,
    },
  ];

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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFAFAFAF).withOpacity(0.2), // Soft Ash
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: const Color(0xFF2F2F2F), size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    // Heart Icon Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Title Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wellness Plans',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Choose your perfect wellness journey',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Current Plan Section
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
                        'Current Plan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2F2F2F), // Charcoal Grey
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFA7C7A1).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_outline,
                              color: const Color(0xFFA7C7A1), // Healing Sage Green
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Basic Wellness',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2F2F2F), // Charcoal Grey
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '\$9.99/month',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF2F2F2F), // Charcoal Grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA7C7A1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFA7C7A1), // Healing Sage Green
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Choose Your Plan Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Your Plan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Plan Cards
                    ..._plans.map((plan) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildPlanCard(plan),
                    )).toList(),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Upgrade Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle upgrade
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA7C7A1), // Healing Sage Green
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Upgrade to Basic Wellness',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    
                    // Compare Plans Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle compare plans
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2F2F2F), // Charcoal Grey
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: const Color(0xFFA7C7A1), // Healing Sage Green
                              width: 1,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Compare All Plans',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final isSelected = _selectedPlan == plan['name'];
    final isCurrent = plan['isCurrent'] as bool;
    final isPopular = plan['isPopular'] as bool;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFFA7C7A1) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Popular Tag
          if (isPopular)
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE76F51), // Terracotta Orange
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Most Popular',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: plan['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      plan['icon'],
                      color: plan['color'],
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2F2F2F), // Charcoal Grey
                          ),
                        ),
                        SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: plan['price'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: plan['color'],
                                ),
                              ),
                              TextSpan(
                                text: plan['period'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF2F2F2F), // Charcoal Grey
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Selection Indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFA7C7A1) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              // Features List
              ...(plan['features'] as List<String>).map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: const Color(0xFFA7C7A1), // Healing Sage Green
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF2F2F2F), // Charcoal Grey
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ],
      ),
    );
  }
} 