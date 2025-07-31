# Firestore Permission Fix Guide

## Problem
After successful user creation in Firebase Auth, you're getting a `[cloud_firestore/permission-denied] Missing or insufficient permissions` error when trying to save user data to Firestore.

## Root Cause
The Firestore security rules are too restrictive and don't allow authenticated users to write to the `users` collection.

## Solution Steps

### Step 1: Deploy Firestore Security Rules

1. **Install Firebase CLI** (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Deploy the security rules**:
   ```bash
   ./deploy_firestore_rules.sh
   ```
   
   Or manually:
   ```bash
   firebase deploy --only firestore:rules
   ```

### Step 2: Verify Firestore Database Setup

1. **Go to Firebase Console**
   - Visit [Firebase Console](https://console.firebase.google.com/)
   - Select your project: `dr-viki-app`

2. **Check Firestore Database**
   - In the left sidebar, click on "Firestore Database"
   - If not created, click "Create database"
   - Choose "Start in production mode"
   - Select a location (preferably close to your users)

3. **Verify Security Rules**
   - Go to "Rules" tab in Firestore
   - Make sure the rules match the ones in `firestore.rules`

### Step 3: Test the Configuration

1. **Run the app**:
   ```bash
   flutter run --debug
   ```

2. **Try user registration**:
   - Use a new email address
   - Check console output for any errors
   - Verify data is saved to Firestore

### Step 4: Alternative Solutions

If you still get permission errors:

#### Option 1: Use Test Mode (Development Only)
Temporarily set Firestore rules to test mode:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

⚠️ **Warning**: Only use this for development. Never use test mode in production.

#### Option 2: Check User Authentication State
Make sure the user is properly authenticated before writing to Firestore:

```dart
if (FirebaseAuth.instance.currentUser != null) {
  // Write to Firestore
} else {
  // Handle unauthenticated state
}
```

#### Option 3: Use Try-Catch for Graceful Handling
The signup screen has been updated to handle Firestore errors gracefully:

```dart
try {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userCredential.user!.uid)
      .set({
    'name': name,
    'email': email,
    // ... other fields
  });
} catch (firestoreError) {
  // Handle the error gracefully
  // User is still created in Firebase Auth
}
```

## Security Rules Explanation

The provided `firestore.rules` file includes:

1. **User Data Protection**: Users can only read/write their own data
2. **Community Posts**: Users can read all posts, but only write their own
3. **Profile Data**: Users can only access their own profile data
4. **Health Data**: Users can only access their own health data
5. **Default Deny**: All other access is denied by default

## Testing the Fix

After deploying the rules:

1. **Test User Registration**:
   - Register a new user
   - Check if user data is saved to Firestore
   - Verify no permission errors

2. **Test Data Access**:
   - Login with the created user
   - Try to access user profile
   - Verify data can be read/written

3. **Test Security**:
   - Try to access another user's data (should be denied)
   - Verify security rules are working

## Common Issues and Solutions

### Issue: "Missing or insufficient permissions"
- **Solution**: Deploy the correct security rules
- **Check**: Verify user is authenticated before writing

### Issue: "Firestore not initialized"
- **Solution**: Make sure Firestore is created in Firebase Console
- **Check**: Verify database location is set

### Issue: "Network error"
- **Solution**: Check internet connectivity
- **Check**: Verify Firebase project is accessible

## Prevention

To prevent permission issues in the future:

1. **Always test security rules** before deploying to production
2. **Use proper authentication checks** before database operations
3. **Implement graceful error handling** for database operations
4. **Regularly review and update** security rules as your app grows

## Support

If you continue to experience issues:

1. Check Firebase Console for any service disruptions
2. Verify your Firebase project billing status
3. Review Firestore documentation for your specific use case
4. Test with a fresh Firebase project to isolate the issue 