# Firebase Configuration Fix Guide

## Problem
You're experiencing the error `[firebase_auth/configuration-not-found]` when trying to register users in your Dr. Viki Flutter app.

## Root Cause
This error typically occurs when:
1. Firebase Authentication is not enabled in your Firebase project
2. The Firebase project configuration is incomplete
3. There are issues with the Firebase project setup

## Solution Steps

### Step 1: Enable Firebase Authentication

1. **Go to Firebase Console**
   - Visit [Firebase Console](https://console.firebase.google.com/)
   - Select your project: `dr-viki-app`

2. **Enable Authentication**
   - In the left sidebar, click on "Authentication"
   - Click "Get started" if you haven't set up authentication yet
   - Go to the "Sign-in method" tab

3. **Enable Email/Password Authentication**
   - Click on "Email/Password"
   - Toggle the "Enable" switch to ON
   - Click "Save"

4. **Enable Google Sign-in (Optional)**
   - Click on "Google"
   - Toggle the "Enable" switch to ON
   - Add your authorized domain (e.g., `localhost` for development)
   - Click "Save"

### Step 2: Configure Authorized Domains

1. **Go to Authentication Settings**
   - In Authentication, click on the "Settings" tab
   - Scroll down to "Authorized domains"

2. **Add Your Domains**
   - Add `localhost` for local development
   - Add your production domain if you have one
   - For mobile apps, this is usually not required

### Step 3: Verify Firebase Configuration Files

1. **Check Android Configuration**
   - Verify `android/app/google-services.json` exists and is valid
   - Make sure the package name matches: `com.drviki.app`

2. **Check iOS Configuration**
   - Verify `ios/Runner/GoogleService-Info.plist` exists and is valid
   - Make sure the bundle ID matches: `com.drviki.app`

3. **Check Web Configuration**
   - Verify your `lib/firebase_options_dr_viki.dart` has correct values
   - Make sure `authDomain` is set correctly

### Step 4: Update Firebase Options

The Firebase options file has been updated with the database URL. Make sure your `lib/firebase_options_dr_viki.dart` includes:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyBNlh_20GxdMlqSTr_3UsaBOs_Zt61KEoc',
  appId: '1:472330705050:web:a6ca636e8306c0c755e723',
  messagingSenderId: '472330705050',
  projectId: 'dr-viki-app',
  authDomain: 'dr-viki-app.firebaseapp.com',
  storageBucket: 'dr-viki-app.firebasestorage.app',
  measurementId: 'G-4S7ZXCQ413',
  databaseURL: 'https://dr-viki-app-default-rtdb.firebaseio.com',
);
```

### Step 5: Test the Configuration

1. **Run the App**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check Console Output**
   - Look for Firebase initialization messages
   - Check for any error messages
   - Verify that authentication tests pass

3. **Test User Registration**
   - Try to register a new user
   - Check if the error is resolved

### Step 6: Additional Troubleshooting

If the issue persists:

1. **Check Firebase Project Settings**
   - Go to Project Settings in Firebase Console
   - Verify your app configurations
   - Make sure API keys are correct

2. **Verify Firestore Database**
   - Ensure Firestore is created and accessible
   - Check security rules

3. **Check Network Connectivity**
   - Ensure your device/emulator has internet access
   - Check if Firebase services are accessible

## Common Error Codes and Solutions

### `configuration-not-found`
- **Cause**: Firebase Authentication not enabled
- **Solution**: Enable Authentication in Firebase Console

### `auth-domain-config-required`
- **Cause**: Auth domain not configured
- **Solution**: Add your domain to authorized domains

### `invalid-api-key`
- **Cause**: Incorrect API key
- **Solution**: Verify your configuration files

### `network-request-failed`
- **Cause**: Network connectivity issues
- **Solution**: Check internet connection and Firebase service status

## Testing the Fix

After implementing the fixes:

1. **Run the app** and check console output
2. **Try user registration** with a test email
3. **Verify data is saved** to Firestore
4. **Test authentication flow** end-to-end

## Prevention

To prevent this issue in the future:

1. **Always enable Authentication** when setting up a new Firebase project
2. **Test configuration** before deploying to production
3. **Use the provided Firebase fix utilities** for better error handling
4. **Keep configuration files updated** with the latest Firebase settings

## Support

If you continue to experience issues:

1. Check the Firebase Console for any service disruptions
2. Verify your Firebase project billing status
3. Review Firebase documentation for your specific platform
4. Test with a fresh Firebase project to isolate the issue 