import 'package:flutter/material.dart';
import 'chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options_dr_viki.dart';
import 'splash_screen.dart';
import 'onboardingscreen.dart';
import 'login.dart';
import 'signup.dart';
import 'home_page.dart';
import 'complete_profile.dart';
import 'edit_profile.dart';
import 'account.dart';
import 'community.dart';
import 'ask.dart' as ask;
import 'package:easy_localization/easy_localization.dart';
import 'shop.dart';
import 'firebase_test.dart';
import 'firebase_fix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('Initializing Firebase with retry mechanism...');
    await FirebaseFix.initializeFirebaseWithRetry();
    
    // Test authentication functionality
    try {
      await FirebaseFix.testAuthentication();
    } catch (e) {
      print('Authentication test failed: $e');
    }
    
  } catch (e) {
    print('Firebase initialization error: $e');
    print('Error details: ${e.toString()}');
    if (e is FirebaseException) {
      print('Firebase error code: ${e.code}');
      print('Firebase error message: ${e.message}');
    }
  }
  
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('hi')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr Viki',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins', // Set Poppins as the global font
textTheme: TextTheme(
  bodyLarge: TextStyle(fontFamily: 'Poppins'),
  bodyMedium: TextStyle(fontFamily: 'Poppins'),
  bodySmall: TextStyle(fontFamily: 'Poppins'),
  displayLarge: TextStyle(fontFamily: 'Poppins'),
  displayMedium: TextStyle(fontFamily: 'Poppins'),
  displaySmall: TextStyle(fontFamily: 'Poppins'),
  headlineLarge: TextStyle(fontFamily: 'Poppins'),
  headlineMedium: TextStyle(fontFamily: 'Poppins'),
  headlineSmall: TextStyle(fontFamily: 'Poppins'),
  titleLarge: TextStyle(fontFamily: 'Poppins'),
  titleMedium: TextStyle(fontFamily: 'Poppins'),
  titleSmall: TextStyle(fontFamily: 'Poppins'),
),
      ),
      home: SplashScreen(),
      routes: {
        '/onboarding': (context) => PlantApp(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/completeProfile': (context) => CompleteProfileScreen(),
        '/account': (context) => AccountPage(),
        '/editProfile': (context) => EditProfileScreen(),
        '/community': (context) => CommunityPage(),
        '/askCommunity': (context) => ask.AskCommunityScreen(),
        '/chat': (context) => ChatPage(),
        '/shop': (context) => ShopPage(),
      },
    );
  }
}

class AuthFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (snapshot.hasData) {
          return HomePage();
        }
        return PlantApp();
      },
    );
  }
}
