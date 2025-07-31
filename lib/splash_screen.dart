import 'package:flutter/material.dart';
import 'OnboardingScreen.dart'; // Import the Onboarding screen
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  final bool firebaseInitialized;
  
  const SplashScreen({Key? key, required this.firebaseInitialized}) : super(key: key);
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    
    if (mounted) {
      try {
        print('SplashScreen: Starting navigation...');
        
        if (widget.firebaseInitialized) {
          print('SplashScreen: Firebase is initialized, checking user...');
          try {
            final user = FirebaseAuth.instance.currentUser;
            print('SplashScreen: Current user: ${user?.uid ?? 'null'}');
            
            if (user != null) {
              print('SplashScreen: User found, navigating to HomePage');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else {
              print('SplashScreen: No user found, navigating to Onboarding');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PlantApp()),
              );
            }
          } catch (e) {
            print('SplashScreen: Error checking user: $e');
            setState(() {
              _hasError = true;
              _errorMessage = 'Error checking user: $e';
            });
          }
        } else {
          print('SplashScreen: Firebase not initialized, going to onboarding');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PlantApp()),
          );
        }
      } catch (e) {
        print('SplashScreen: Navigation error: $e');
        setState(() {
          _hasError = true;
          _errorMessage = 'Navigation error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _errorMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _errorMessage = '';
                  });
                  _navigateToNextScreen();
                },
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.png', // Fixed path to match pubspec.yaml
              width: 500,
              height: 500,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading logo: $error');
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.medical_services,
                    size: 100,
                    color: Colors.green,
                  ),
                );
              },
            ),
            const SizedBox(height: 34),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
