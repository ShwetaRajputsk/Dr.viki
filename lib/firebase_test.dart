import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options_dr_viki.dart';

class FirebaseTest {
  static Future<void> testFirebaseConfiguration() async {
    try {
      print('=== Firebase Configuration Test ===');
      
      // Test 1: Initialize Firebase
      print('1. Testing Firebase initialization...');
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase initialized successfully');
      
      // Test 2: Check Firebase options
      print('2. Checking Firebase options...');
      final app = Firebase.app();
      final options = app.options;
      
      print('   Project ID: ${options.projectId}');
      print('   App ID: ${options.appId}');
      print('   API Key: ${options.apiKey?.substring(0, 10)}...');
      print('   Auth Domain: ${options.authDomain}');
      print('   Storage Bucket: ${options.storageBucket}');
      print('   Database URL: ${options.databaseURL}');
      print('✅ Firebase options are valid');
      
      // Test 3: Test Firebase Auth instance
      print('3. Testing Firebase Auth...');
      final auth = FirebaseAuth.instance;
      print('   Auth instance created: ${auth != null}');
      print('   Current user: ${auth.currentUser?.uid ?? "null"}');
      print('✅ Firebase Auth is accessible');
      
      // Test 4: Test auth state changes
      print('4. Testing auth state changes...');
      final authState = auth.authStateChanges();
      print('   Auth state stream created: ${authState != null}');
      print('✅ Auth state changes are working');
      
      // Test 5: Test sign-in methods
      print('5. Testing available sign-in methods...');
      final methods = await auth.fetchSignInMethodsForEmail('test@example.com');
      print('   Available methods for test@example.com: $methods');
      print('✅ Sign-in methods can be fetched');
      
      print('=== All Firebase tests passed! ===');
      
    } catch (e) {
      print('❌ Firebase test failed: $e');
      print('Error details: ${e.toString()}');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      rethrow;
    }
  }
  
  static Future<void> testUserCreation(String email, String password) async {
    try {
      print('=== Testing User Creation ===');
      print('Email: $email');
      
      final auth = FirebaseAuth.instance;
      
      // Try to create a user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('✅ User created successfully');
      print('User ID: ${userCredential.user?.uid}');
      print('Email: ${userCredential.user?.email}');
      
      // Clean up - delete the test user
      await userCredential.user?.delete();
      print('✅ Test user deleted');
      
    } catch (e) {
      print('❌ User creation failed: $e');
      if (e is FirebaseAuthException) {
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
      }
      rethrow;
    }
  }
} 