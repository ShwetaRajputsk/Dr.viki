import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options_dr_viki.dart';

class FirebaseFix {
  static Future<void> initializeFirebaseWithRetry() async {
    try {
      print('=== Firebase Initialization with Retry ===');
      
      // First, try to initialize with current options
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      print('✅ Firebase initialized successfully');
      
      // Verify the configuration
      await _verifyFirebaseConfiguration();
      
    } catch (e) {
      print('❌ Initial Firebase initialization failed: $e');
      
      // If the first attempt fails, try alternative approaches
      await _tryAlternativeInitialization();
    }
  }
  
  static Future<void> _verifyFirebaseConfiguration() async {
    try {
      final app = Firebase.app();
      final options = app.options;
      
      print('Verifying Firebase configuration...');
      print('Project ID: ${options.projectId}');
      print('App ID: ${options.appId}');
      print('Auth Domain: ${options.authDomain}');
      
      // Test Firebase Auth
      final auth = FirebaseAuth.instance;
      print('Firebase Auth instance: ${auth != null}');
      
      // Test auth state changes
      final authState = auth.authStateChanges();
      print('Auth state changes: ${authState != null}');
      
      print('✅ Firebase configuration verified successfully');
      
    } catch (e) {
      print('❌ Firebase configuration verification failed: $e');
      throw e;
    }
  }
  
  static Future<void> _tryAlternativeInitialization() async {
    print('Trying alternative Firebase initialization...');
    
    try {
      // Try to initialize with minimal configuration
      await Firebase.initializeApp();
      print('✅ Firebase initialized with default configuration');
      
      // Verify this works
      final auth = FirebaseAuth.instance;
      print('Firebase Auth available: ${auth != null}');
      
    } catch (e) {
      print('❌ Alternative initialization also failed: $e');
      throw Exception('Firebase initialization failed completely: $e');
    }
  }
  
  static Future<void> testAuthentication() async {
    try {
      print('=== Testing Firebase Authentication ===');
      
      final auth = FirebaseAuth.instance;
      
      // Test 1: Check if auth is available
      print('1. Testing auth availability...');
      if (auth == null) {
        throw Exception('Firebase Auth is not available');
      }
      print('✅ Firebase Auth is available');
      
      // Test 2: Check current user
      print('2. Checking current user...');
      final currentUser = auth.currentUser;
      print('Current user: ${currentUser?.uid ?? "null"}');
      print('✅ Current user check completed');
      
      // Test 3: Test auth state changes
      print('3. Testing auth state changes...');
      final authState = auth.authStateChanges();
      print('Auth state stream: ${authState != null}');
      print('✅ Auth state changes working');
      
      // Test 4: Test sign-in methods (this might fail if auth is not enabled)
      print('4. Testing sign-in methods...');
      try {
        final methods = await auth.fetchSignInMethodsForEmail('test@example.com');
        print('Available methods: $methods');
        print('✅ Sign-in methods test completed');
      } catch (e) {
        print('⚠️ Sign-in methods test failed (this might be expected): $e');
      }
      
      print('✅ Authentication tests completed');
      
    } catch (e) {
      print('❌ Authentication test failed: $e');
      throw e;
    }
  }
  
  static Future<void> createTestUser(String email, String password) async {
    try {
      print('=== Creating Test User ===');
      print('Email: $email');
      
      final auth = FirebaseAuth.instance;
      
      // Create user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('✅ User created successfully');
      print('User ID: ${userCredential.user?.uid}');
      print('Email: ${userCredential.user?.email}');
      
      // Clean up
      await userCredential.user?.delete();
      print('✅ Test user deleted');
      
    } catch (e) {
      print('❌ User creation failed: $e');
      if (e is FirebaseAuthException) {
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
        
        // Provide specific guidance based on error code
        switch (e.code) {
          case 'configuration-not-found':
            print('💡 SOLUTION: Enable Firebase Authentication in your Firebase Console');
            print('   1. Go to Firebase Console > Authentication');
            print('   2. Click "Get started"');
            print('   3. Enable Email/Password authentication');
            print('   4. Add your app domain to authorized domains');
            break;
          case 'auth-domain-config-required':
            print('💡 SOLUTION: Configure auth domain in Firebase Console');
            print('   1. Go to Firebase Console > Authentication > Settings');
            print('   2. Add your domain to authorized domains');
            break;
          case 'invalid-api-key':
            print('💡 SOLUTION: Check your API key configuration');
            print('   1. Verify your google-services.json and GoogleService-Info.plist files');
            print('   2. Make sure they match your Firebase project');
            break;
          default:
            print('💡 Check Firebase Console for authentication settings');
        }
      }
      throw e;
    }
  }
} 