import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
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
                        // Chart Icon Button
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE76F51), // Terracotta Orange
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.bar_chart,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'My Reports',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your wellness journey history',
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFFA7C7A1), // Healing Sage Green
                      ),
                    ),
                  ],
                ),
              ),

              // Wellness Summary Section
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
                        'Wellness Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2F2F2F), // Charcoal Grey
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          // Total Scans
                          Expanded(
                            child: _buildSummaryMetric(
                              Icons.description_outlined,
                              '3',
                              'Total Scans',
                              const Color(0xFFA7C7A1), // Healing Sage Green
                            ),
                          ),
                          SizedBox(width: 16),
                          // Avg Balance
                          Expanded(
                            child: _buildSummaryMetric(
                              Icons.favorite_outline,
                              '75%',
                              'Avg Balance',
                              const Color(0xFFA7C7A1), // Healing Sage Green
                            ),
                          ),
                          SizedBox(width: 16),
                          // Recommendations
                          Expanded(
                            child: _buildSummaryMetric(
                              Icons.emoji_events_outlined,
                              '12',
                              'Recommendations',
                              const Color(0xFFE76F51), // Terracotta Orange
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Scan History Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Scan History List
                    _buildScanHistoryItem(
                      Icons.favorite_outline,
                      'Eye & Tongue Scan',
                      'Jan 15, 2024',
                      0.75,
                      '4 tips',
                      'Vata',
                      '75% balanced',
                      const Color(0xFFA7C7A1), // Healing Sage Green
                      isLatest: true,
                    ),
                    SizedBox(height: 12),
                    _buildScanHistoryItem(
                      Icons.favorite_outline,
                      'Tongue Analysis',
                      'Jan 12, 2024',
                      0.68,
                      '3 tips',
                      'Pitta',
                      '68% balanced',
                      const Color(0xFFE76F51), // Terracotta Orange
                    ),
                    SizedBox(height: 12),
                    _buildScanHistoryItem(
                      Icons.favorite_outline,
                      'Eye Scan',
                      'Jan 8, 2024',
                      0.82,
                      '5 tips',
                      'Kapha',
                      '82% balanced',
                      const Color(0xFF27C2A4), // Futuristic Teal Glow
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

  Widget _buildSummaryMetric(IconData icon, String value, String label, Color color) {
    return Column(
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
            color: const Color(0xFF2F2F2F), // Charcoal Grey
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScanHistoryItem(
    IconData icon,
    String title,
    String date,
    double progress,
    String tips,
    String dosha,
    String balance,
    Color color,
    {bool isLatest = false}
  ) {
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
          // Icon
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F), // Charcoal Grey
                      ),
                    ),
                    if (isLatest) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Latest',
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(0xFFA7C7A1), // Healing Sage Green
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFAFAFAF), // Soft Ash
                  ),
                ),
                SizedBox(height: 8),
                
                // Progress Bar
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFAFAFAF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  tips,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFAFAFAF), // Soft Ash
                  ),
                ),
              ],
            ),
          ),
          
          // Right side - Dosha and Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dosha,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 2),
              Text(
                balance,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF2F2F2F), // Charcoal Grey
                ),
              ),
              SizedBox(height: 8),
              Icon(
                Icons.chevron_right,
                color: const Color(0xFFAFAFAF), // Soft Ash
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 