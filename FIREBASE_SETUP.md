# Dr. Viki Firebase Setup Guide

## Overview
This guide will help you set up Firebase for the Dr. Viki app, which is separate from the existing CropFit project.

## Step 1: Create New Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `dr-viki-app`
4. Enable Google Analytics (optional)
5. Choose your analytics account
6. Click "Create project"

## Step 2: Add Apps to Firebase Project

### Android App
1. In Firebase Console, click "Add app" and select Android
2. Android package name: `com.drviki.app`
3. App nickname: `Dr Viki Android`
4. Download `google-services.json` and place it in `android/app/`

### iOS App
1. Click "Add app" and select iOS
2. iOS bundle ID: `com.drviki.app`
3. App nickname: `Dr Viki iOS`
4. Download `GoogleService-Info.plist` and place it in `ios/Runner/`

### Web App
1. Click "Add app" and select Web
2. App nickname: `Dr Viki Web`
3. Register app

## Step 3: Update Firebase Configuration

1. Replace the placeholder values in `lib/firebase_options_dr_viki.dart` with your actual Firebase configuration
2. Update `main.dart` to use the new Firebase options:

```dart
import 'firebase_options_dr_viki.dart';

// In main() function:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Step 4: Configure Authentication

1. In Firebase Console, go to Authentication
2. Enable Email/Password authentication
3. Enable Google Sign-in
4. Add your authorized domains

## Step 5: Configure Firestore Database

1. Go to Firestore Database
2. Create database in production mode
3. Choose a location (preferably close to your users)
4. Set up security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Step 6: Update App Configuration

### Update android/app/build.gradle
```gradle
android {
    defaultConfig {
        applicationId "com.drviki.app"
        // ... other config
    }
}
```

### Update ios/Runner/Info.plist
```xml
<key>CFBundleIdentifier</key>
<string>com.drviki.app</string>
```

## Step 7: Test the Setup

1. Run the app
2. Test user registration
3. Verify data is saved to Firestore
4. Test profile completion flow

## Database Schema

The app uses the following Firestore collections:

### users/{userId}
```json
{
  "name": "string",
  "email": "string",
  "imageUrl": "string",
  "age": "number",
  "gender": "string",
  "height": "number",
  "weight": "number",
  "location": "string",
  "occupation": "string",
  "lifestyle": "string",
  "medicalHistory": "string",
  "healthConcerns": "string",
  "profileCompleted": "boolean",
  "profileCompletedAt": "timestamp",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Troubleshooting

1. **Firebase not initialized**: Check that you're importing the correct firebase_options file
2. **Authentication errors**: Verify your Firebase project settings
3. **Database permission errors**: Check Firestore security rules
4. **Build errors**: Ensure all configuration files are in the correct locations

## Next Steps

1. Set up Firebase Storage for profile images
2. Configure Firebase Functions for backend logic
3. Set up Firebase Analytics for user behavior tracking
4. Configure Firebase Crashlytics for error reporting 