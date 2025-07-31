import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options_dr_viki.dart';

void main() async {
  try {
    print('=== Firestore Test ===');
    
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized');
    
    // Test Firestore connection
    final firestore = FirebaseFirestore.instance;
    print('✅ Firestore instance created');
    
    // Test reading from a collection (this should work even without auth)
    try {
      final testDoc = await firestore.collection('test').doc('test').get();
      print('✅ Firestore read test completed');
    } catch (e) {
      print('⚠️ Firestore read test failed (expected if no auth): $e');
    }
    
    // Test authentication
    final auth = FirebaseAuth.instance;
    print('✅ Firebase Auth instance created');
    
    // Test creating a user (this will fail if auth is not enabled)
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'testpassword123',
      );
      print('✅ Test user created: ${userCredential.user?.uid}');
      
      // Test writing to Firestore with authenticated user
      try {
        await firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': 'Test User',
          'email': 'test@example.com',
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('✅ Firestore write test successful');
      } catch (firestoreError) {
        print('❌ Firestore write test failed: $firestoreError');
      }
      
      // Clean up - delete test user
      await userCredential.user?.delete();
      print('✅ Test user deleted');
      
    } catch (authError) {
      print('❌ Authentication test failed: $authError');
    }
    
    print('=== Firestore Test Complete ===');
    
  } catch (e) {
    print('❌ Test failed: $e');
  }
} 