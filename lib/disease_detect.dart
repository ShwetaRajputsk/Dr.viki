import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_screen.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'bottom_navigation_bar.dart';
import 'prediction.dart';
import 'package:easy_localization/easy_localization.dart';

class CropDiseaseHome extends StatefulWidget {
  @override
  _CropDiseaseHomeState createState() => _CropDiseaseHomeState();
}

class _CropDiseaseHomeState extends State<CropDiseaseHome> with TickerProviderStateMixin {
  String _currentStep = 'intro'; // intro, questions, analyzing, results
  int _currentQuestion = 0;
  List<String> _answers = [];
  Map<String, int> _doshaScores = {'vata': 0, 'pitta': 0, 'kapha': 0};
  int _currentIndex = 2;
  late AnimationController _animationController;
  late AnimationController _progressController;
  double _progress = 0.0;

  final List<Map<String, dynamic>> _questions = [
    {
      'id': 1,
      'question': "How would you describe your body frame?",
      'options': [
        {'text': "Thin, light build", 'dosha': "vata"},
        {'text': "Medium, muscular build", 'dosha': "pitta"},
        {'text': "Large, solid build", 'dosha': "kapha"}
      ]
    },
    {
      'id': 2,
      'question': "How is your sleep pattern?",
      'options': [
        {'text': "Light sleeper, often restless", 'dosha': "vata"},
        {'text': "Moderate sleep, wake up refreshed", 'dosha': "pitta"},
        {'text': "Deep sleeper, need more sleep", 'dosha': "kapha"}
      ]
    },
    {
      'id': 3,
      'question': "What's your appetite like?",
      'options': [
        {'text': "Variable, sometimes forget to eat", 'dosha': "vata"},
        {'text': "Strong, regular hunger", 'dosha': "pitta"},
        {'text': "Low, can skip meals easily", 'dosha': "kapha"}
      ]
    },
    {
      'id': 4,
      'question': "How do you handle stress?",
      'options': [
        {'text': "Worry, anxiety, overthinking", 'dosha': "vata"},
        {'text': "Irritation, anger, frustration", 'dosha': "pitta"},
        {'text': "Withdraw, become sluggish", 'dosha': "kapha"}
      ]
    },
    {
      'id': 5,
      'question': "What's your skin type?",
      'options': [
        {'text': "Dry, thin, cool to touch", 'dosha': "vata"},
        {'text': "Warm, oily, sensitive", 'dosha': "pitta"},
        {'text': "Thick, oily, cool and soft", 'dosha': "kapha"}
      ]
    },
    {
      'id': 6,
      'question': "How do you learn new things?",
      'options': [
        {'text': "Quick to learn, quick to forget", 'dosha': "vata"},
        {'text': "Moderate pace, good retention", 'dosha': "pitta"},
        {'text': "Slow to learn, excellent memory", 'dosha': "kapha"}
      ]
    },
    {
      'id': 7,
      'question': "What's your energy level like?",
      'options': [
        {'text': "Bursts of energy, then fatigue", 'dosha': "vata"},
        {'text': "Consistent, high energy", 'dosha': "pitta"},
        {'text': "Steady, enduring energy", 'dosha': "kapha"}
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _handleStartAnalysis() {
    setState(() {
      _currentStep = 'questions';
    });
  }

  void _handleAnswer(String selectedDosha) {
    setState(() {
      _answers.add(selectedDosha);
    });

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      _calculateDoshaScores();
      setState(() {
        _currentStep = 'analyzing';
      });
      
      _progressController.forward();
      
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _currentStep = 'results';
        });
      });
    }
  }

  void _calculateDoshaScores() {
    Map<String, int> scores = {'vata': 0, 'pitta': 0, 'kapha': 0};
    for (String answer in _answers) {
      scores[answer] = (scores[answer] ?? 0) + 1;
    }
    
    int total = _answers.length;
    setState(() {
      _doshaScores = {
        'vata': ((scores['vata']! / total) * 100).round(),
        'pitta': ((scores['pitta']! / total) * 100).round(),
        'kapha': ((scores['kapha']! / total) * 100).round(),
      };
    });
  }

  void _handleRestart() {
    setState(() {
      _currentStep = 'intro';
      _currentQuestion = 0;
      _answers.clear();
      _doshaScores = {'vata': 0, 'pitta': 0, 'kapha': 0};
    });
  }

  Widget _buildIntroCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFA7C7A1).withOpacity(0.1),
                const Color(0xFF27C2A4).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFE76F51).withOpacity(0.2),
                      const Color(0xFF27C2A4).withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology,
                  color: const Color(0xFFE76F51),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'AI-Powered Dosha Analysis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2F2F2F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Discover your unique Ayurvedic constitution through our intelligent assessment. Answer 7 simple questions to understand your mind-body type.',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF2F2F2F).withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDoshaPreview('Vata', 'Air & Space', const Color(0xFFA7C7A1), Icons.eco),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDoshaPreview('Pitta', 'Fire & Water', const Color(0xFFE76F51), Icons.local_fire_department),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDoshaPreview('Kapha', 'Earth & Water', const Color(0xFF27C2A4), Icons.water_drop),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildFeatureCard(Icons.schedule, 'Quick Assessment', 'Only 7 questions, 3 minutes', const Color(0xFF27C2A4)),
        const SizedBox(height: 12),
        _buildFeatureCard(Icons.psychology, 'AI-Powered Analysis', 'Precise dosha calculation', const Color(0xFFE76F51)),
        const SizedBox(height: 12),
        _buildFeatureCard(Icons.favorite, 'Personalized Results', 'Detailed constitution breakdown', const Color(0xFFA7C7A1)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _handleStartAnalysis,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE76F51),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'This analysis is based on traditional Ayurvedic principles and modern AI algorithms for educational purposes.',
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF2F2F2F).withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDoshaPreview(String name, String elements, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            elements,
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF2F2F2F).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2F2F2F).withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentQuestion];
    final progress = ((_currentQuestion + 1) / _questions.length) * 100;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                const Color(0xFFF8F4EC).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF27C2A4).withOpacity(0.2),
                      const Color(0xFFA7C7A1).withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${_currentQuestion + 1}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF27C2A4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                question['question'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2F2F2F),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Choose the option that best describes you',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF2F2F2F).withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ...question['options'].map<Widget>((option) => _buildOptionCard(option)).toList(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildStepIndicator(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFA7C7A1).withOpacity(0.05),
                const Color(0xFF27C2A4).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: const Color(0xFFE76F51), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Understanding your dosha helps create a personalized wellness plan',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2F2F2F).withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(Map<String, dynamic> option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleAnswer(option['dosha']),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getDoshaColor(option['dosha']).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getDoshaIcon(option['dosha']),
                    color: _getDoshaColor(option['dosha']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option['text'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2F2F2F),
                      height: 1.4,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFF2F2F2F).withOpacity(0.3),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_questions.length, (index) {
        bool isCompleted = index < _currentQuestion;
        bool isCurrent = index == _currentQuestion;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: isCurrent ? 12 : 8,
          height: isCurrent ? 12 : 8,
          decoration: BoxDecoration(
            color: isCompleted 
                ? const Color(0xFF27C2A4)
                : isCurrent 
                    ? const Color(0xFFE76F51)
                    : const Color(0xFFA7C7A1).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Color _getDoshaColor(String dosha) {
    switch (dosha) {
      case 'vata': return const Color(0xFFA7C7A1);
      case 'pitta': return const Color(0xFFE76F51);
      case 'kapha': return const Color(0xFF27C2A4);
      default: return const Color(0xFFA7C7A1);
    }
  }

  IconData _getDoshaIcon(String dosha) {
    switch (dosha) {
      case 'vata': return Icons.eco;
      case 'pitta': return Icons.local_fire_department;
      case 'kapha': return Icons.water_drop;
      default: return Icons.eco;
    }
  }

  Widget _buildAnalysisLoader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                const Color(0xFFF8F4EC).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFE76F51).withOpacity(0.2),
                      const Color(0xFF27C2A4).withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.psychology,
                          color: const Color(0xFFE76F51),
                          size: 24,
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2 * 3.14159,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE76F51),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'AI Analysis in Progress',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2F2F2F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Our advanced algorithms are processing your responses to determine your unique Ayurvedic constitution.',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF2F2F2F).withOpacity(0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA7C7A1).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressController.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF27C2A4),
                                  const Color(0xFFA7C7A1),
                                  const Color(0xFFE76F51),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_progressController.value * 100).round()}% Complete',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF2F2F2F).withOpacity(0.6),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildDoshaPreviewCards(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFE76F51).withOpacity(0.05),
                const Color(0xFF27C2A4).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule, color: const Color(0xFFE76F51), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Please wait while we create your personalized dosha profile...',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2F2F2F).withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoshaPreviewCards() {
    return Row(
      children: [
        Expanded(child: _buildDoshaPreviewCard('Vata', 'Air & Space', const Color(0xFFA7C7A1), Icons.eco, 40)),
        const SizedBox(width: 12),
        Expanded(child: _buildDoshaPreviewCard('Pitta', 'Fire & Water', const Color(0xFFE76F51), Icons.local_fire_department, 35)),
        const SizedBox(width: 12),
        Expanded(child: _buildDoshaPreviewCard('Kapha', 'Earth & Water', const Color(0xFF27C2A4), Icons.water_drop, 25)),
      ],
    );
  }

  Widget _buildDoshaPreviewCard(String name, String elements, Color color, IconData icon, int percentage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            elements,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF2F2F2F).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    final dominantDosha = _getDominantDosha();
    final primaryInfo = _getDoshaInfo(dominantDosha);
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                const Color(0xFFF8F4EC).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF27C2A4).withOpacity(0.2),
                      const Color(0xFFA7C7A1).withOpacity(0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: const Color(0xFFE76F51),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your Dosha Analysis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2F2F2F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Based on your responses, here\'s your Ayurvedic constitution',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF2F2F2F).withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildDoshaBreakdown(),
        const SizedBox(height: 24),
        _buildPrimaryDoshaDetails(primaryInfo),
        const SizedBox(height: 24),
        _buildActionButtons(),
        const SizedBox(height: 16),
        _buildDisclaimer(),
      ],
    );
  }

  String _getDominantDosha() {
    final max = _doshaScores.values.reduce((a, b) => a > b ? a : b);
    if (_doshaScores['vata'] == max) return 'vata';
    if (_doshaScores['pitta'] == max) return 'pitta';
    return 'kapha';
  }

  Map<String, dynamic> _getDoshaInfo(String dosha) {
    final info = {
      'vata': {
        'name': 'Vata',
        'elements': 'Air & Space',
        'color': const Color(0xFFA7C7A1),
        'icon': Icons.eco,
        'traits': ['Creative', 'Energetic', 'Quick-thinking', 'Flexible'],
        'description': 'You have a Vata-dominant constitution. Vata governs movement, circulation, and nervous system function.',
        'recommendations': [
          'Maintain regular routines',
          'Practice grounding activities like yoga',
          'Eat warm, nourishing foods',
          'Get adequate sleep and rest'
        ]
      },
      'pitta': {
        'name': 'Pitta',
        'elements': 'Fire & Water',
        'color': const Color(0xFFE76F51),
        'icon': Icons.local_fire_department,
        'traits': ['Focused', 'Ambitious', 'Intelligent', 'Natural leader'],
        'description': 'You have a Pitta-dominant constitution. Pitta governs digestion, metabolism, and transformation.',
        'recommendations': [
          'Avoid excessive heat and spicy foods',
          'Practice cooling activities like swimming',
          'Maintain work-life balance',
          'Include cooling foods in your diet'
        ]
      },
      'kapha': {
        'name': 'Kapha',
        'elements': 'Earth & Water',
        'color': const Color(0xFF27C2A4),
        'icon': Icons.water_drop,
        'traits': ['Calm', 'Stable', 'Compassionate', 'Strong endurance'],
        'description': 'You have a Kapha-dominant constitution. Kapha governs structure, immunity, and growth.',
        'recommendations': [
          'Engage in regular physical activity',
          'Eat light, warm, and spiced foods',
          'Maintain an active lifestyle',
          'Avoid excessive sleep and sedentary habits'
        ]
      }
    };
    return info[dosha]!;
  }

  Widget _buildDoshaBreakdown() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFF8F4EC).withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Constitution Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2F2F2F),
            ),
          ),
          const SizedBox(height: 16),
          ..._doshaScores.entries.map((entry) => _buildDoshaScoreCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildDoshaScoreCard(String dosha, int percentage) {
    final info = _getDoshaInfo(dosha);
    final isHighest = dosha == _getDominantDosha();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighest 
            ? const Color(0xFFE76F51).withOpacity(0.1)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighest 
              ? const Color(0xFFE76F51).withOpacity(0.2)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: info['color'].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(info['icon'], color: info['color'], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                Text(
                  info['elements'],
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF2F2F2F).withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: info['color'],
                ),
              ),
              if (isHighest)
                Row(
                  children: [
                    Icon(Icons.star, color: const Color(0xFFE76F51), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Dominant',
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color(0xFFE76F51),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryDoshaDetails(Map<String, dynamic> primaryInfo) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFF8F4EC).withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFA7C7A1).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryInfo['color'].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(primaryInfo['icon'], color: primaryInfo['color'], size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Primary: ${primaryInfo['name']} Constitution',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F2F2F),
                      ),
                    ),
                    Text(
                      primaryInfo['elements'],
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2F2F2F).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            primaryInfo['description'],
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF2F2F2F).withOpacity(0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your Key Traits:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2F2F2F),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (primaryInfo['traits'] as List<String>).map((trait) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryInfo['color'],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                trait,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Wellness Recommendations:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2F2F2F),
            ),
          ),
          const SizedBox(height: 8),
          ...(primaryInfo['recommendations'] as List<String>).map((rec) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: const Color(0xFF27C2A4), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rec,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF2F2F2F).withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to consult page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE76F51),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medical_services),
                const SizedBox(width: 8),
                Text(
                  'Consult with Doctor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _handleRestart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27C2A4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh),
                const SizedBox(width: 8),
                Text(
                  'Retake Analysis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFA7C7A1).withOpacity(0.05),
            const Color(0xFF27C2A4).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: const Color(0xFFE76F51), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'This analysis is based on traditional Ayurvedic principles and is for educational purposes. Consult with a qualified practitioner for personalized health advice.',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF2F2F2F).withOpacity(0.6),
                height: 1.4,
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
      if (_currentIndex == 0) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: const Color(0xFF2F2F2F)),
        ),
        title: Column(
          children: [
            Text(
              'Know Your Dosha',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2F2F2F),
              ),
            ),
            Text(
              'AI-Powered Analysis',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFF2F2F2F).withOpacity(0.6),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE76F51).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.psychology, color: const Color(0xFFE76F51), size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (_currentStep == 'questions') ...[
                Row(
                  children: [
                    Text(
                      'Question ${_currentQuestion + 1} of ${_questions.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2F2F2F).withOpacity(0.7),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${((_currentQuestion + 1) / _questions.length * 100).round()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE76F51),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA7C7A1).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentQuestion + 1) / _questions.length,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF27C2A4),
                            const Color(0xFFE76F51),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (_currentStep == 'intro') _buildIntroCard(),
              if (_currentStep == 'questions') _buildQuestionCard(),
              if (_currentStep == 'analyzing') _buildAnalysisLoader(),
              if (_currentStep == 'results') _buildResultsCard(),
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
}