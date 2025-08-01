import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'bottom_navigation_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final String _apiKey = const String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  final String _apiUrl = "https://api.groq.com/openai/v1/chat/completions";
  int _currentIndex = 1;

  // Dr. Viki Brand Colors
  final Color primaryColor = const Color(0xFF27C2A4); // Futuristic Teal Glow
  final Color secondaryColor = const Color(0xFFA7C7A1); // Healing Sage Green
  final Color accentColor = const Color(0xFFE76F51); // Terracotta Orange
  final Color textColor = const Color(0xFF2F2F2F); // Charcoal Grey
  final Color lightTextColor = const Color(0xFFAFAFAF); // Soft Ash
  final Color backgroundColor = const Color(0xFFF8F4EC); // Warm Sand Beige

  List<String> _prefilledQuestions = [
    'What are the best Ayurvedic practices for my Vata dosha?',
    'How can I balance my Pitta dosha naturally?',
    'What foods should I avoid for Kapha imbalance?',
    'Can you suggest a daily wellness routine?',
    'What are the symptoms of dosha imbalance?',
    'How to improve my digestive health with Ayurveda?',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chat_history')
          .doc(user.uid)
          .collection('messages')
          .orderBy('timestamp')
          .get();

      if (mounted) {
        setState(() {
          _messages.clear();
          for (var doc in querySnapshot.docs) {
            final data = doc.data();
            _messages.add({
              'role': 'user',
              'content': data['user_query'] ?? '',
              'timestamp': data['timestamp']?.toDate(),
            });
            if (data['bot_response'] != null && data['bot_response'].isNotEmpty) {
              _messages.add({
                'role': 'assistant',
                'content': data['bot_response'] ?? '',
                'timestamp': data['timestamp']?.toDate(),
              });
            }
          }
          _messages.sort((a, b) => (a['timestamp'] as DateTime).compareTo(b['timestamp'] as DateTime));
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (e) {
      debugPrint("Error loading chat history: $e");
    }
  }

  Future<void> _clearChatHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final batch = FirebaseFirestore.instance.batch();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chat_history')
          .doc(user.uid)
          .collection('messages')
          .get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      if (mounted) setState(() => _messages.clear());
    } catch (e) {
      debugPrint("Error clearing chat history: $e");
      if (mounted) {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': 'Unable to clear chat history. Please try again.',
            'timestamp': DateTime.now(),
          });
        });
      }
    }
  }

  Future<void> _sendMessage(String userInput) async {
    if (userInput.isEmpty || _isLoading) return;

    final userMessage = {
      'role': 'user',
      'content': userInput,
      'timestamp': DateTime.now(),
    };

    setState(() {
      _messages.add(userMessage);
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    DocumentReference? docRef;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorMessage("Please log in to use Dr. Viki's AI assistant");
        return;
      }
      
      docRef = await FirebaseFirestore.instance
          .collection('chat_history')
          .doc(user.uid)
          .collection('messages')
          .add({
        'user_query': userInput,
        'bot_response': '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "llama3-70b-8192",
          "messages": [
            {
              "role": "system",
              "content": "You are Dr. Viki, an expert Ayurvedic wellness assistant. You provide personalized advice based on dosha principles (Vata, Pitta, Kapha). Focus on natural remedies, lifestyle recommendations, and holistic wellness. Always be supportive, knowledgeable, and encourage healthy practices. Respond in a warm, professional manner.",
            },
            ..._messages.map((msg) => {"role": msg["role"], "content": msg["content"]})
          ],
          "temperature": 0.7,
          "max_tokens": 1024,
          "top_p": 1,
          "stream": false
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data['choices'][0]['message']['content']?.trim() ?? '';
        
        if (botResponse.isEmpty) throw Exception("Empty response");

        setState(() => _messages.add({
          'role': 'assistant',
          'content': botResponse,
          'timestamp': DateTime.now(),
        }));

        await docRef.update({
          'bot_response': botResponse,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        throw HttpException("API Error", response.statusCode);
      }
    } on TimeoutException {
      _showErrorMessage("Connection timeout. Please try again.");
    } on SocketException {
      _showErrorMessage("No internet connection. Please check your network.");
    } on HttpException catch (e) {
      _showErrorMessage("Service temporarily unavailable. Please try again later.");
    } catch (e) {
      _showErrorMessage("Unable to process your request. Please try again.");
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      setState(() {
        _messages.add({
          "role": "assistant",
          "content": message,
          "timestamp": DateTime.now(),
        });
      });
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Response copied to clipboard'),
        backgroundColor: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Dr. ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'ViKi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'AI Assistant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Show help or tips
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dr. Viki Assistant Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Namaste! I\'m Dr. Viki',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your personal Ayurvedic wellness assistant. Ask me about dosha balance, natural remedies, lifestyle tips, and holistic wellness practices.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medical_services,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Suggested Questions
          if (_messages.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ask Dr. Viki about:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _prefilledQuestions.map((question) => InkWell(
                      onTap: () => _sendMessage(question),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primaryColor.withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          question,
                          style: TextStyle(
                            color: primaryColor, 
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Align(
                    alignment: message['role'] == 'user' 
                        ? Alignment.centerRight 
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: message['role'] == 'user' 
                            ? primaryColor 
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarkdownBody(
                            data: message['content'],
                            styleSheet: MarkdownStyleSheet(
                              p: TextStyle(
                                color: message['role'] == 'user' 
                                    ? Colors.white 
                                    : textColor,
                                fontSize: 15,
                                height: 1.4,
                              ),
                              strong: TextStyle(
                                color: message['role'] == 'user' 
                                    ? Colors.white 
                                    : primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (message['role'] == 'assistant') ...[
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.copy, size: 16, color: lightTextColor),
                                  onPressed: () => _copyToClipboard(message['content']),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Dr. Viki is thinking...',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -1)),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask Dr. Viki about your wellness...',
                        hintStyle: TextStyle(color: lightTextColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12),
                        prefixIcon: Icon(
                          Icons.medical_services_outlined,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      onSubmitted: (value) => _sendMessage(value),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() => message;
}