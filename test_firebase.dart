import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options_dr_viki.dart';

void main() async {
  try {
    print('=== Firebase Configuration Test ===');
    
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
    
    // Check configuration
    final app = Firebase.app();
    final options = app.options;
    
    print('Project ID: ${options.projectId}');
    print('App ID: ${options.appId}');
    print('Auth Domain: ${options.authDomain}');
    print('Storage Bucket: ${options.storageBucket}');
    print('Database URL: ${options.databaseURL}');
    
    // Test Firebase Auth
    final auth = FirebaseAuth.instance;
    print('Firebase Auth instance: ${auth != null}');
    
    // Test auth state changes
    final authState = auth.authStateChanges();
    print('Auth state changes: ${authState != null}');
    
    print('✅ All tests passed!');
    
  } catch (e) {
    print('❌ Test failed: $e');
    if (e is FirebaseException) {
      print('Error code: ${e.code}');
      print('Error message: ${e.message}');
    }
  }
} 