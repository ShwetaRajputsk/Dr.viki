# Crash Troubleshooting Guide - Dr. Viki Flutter App

## 🚨 **Current Issue: App Crashes After Installation**

### **Problem Description:**
- App installs successfully
- App crashes immediately when opened
- App shuts down after a few seconds

## 🔍 **Diagnostic Steps**

### 1. **Check Device Logs**
```bash
# Connect device and check logs
flutter logs
```

### 2. **Test on Different Devices**
- Test on Android emulator
- Test on physical Android device
- Test on different Android versions

### 3. **Check Firebase Configuration**
```bash
# Verify google-services.json exists
ls -la android/app/google-services.json

# Check Firebase project settings
# Go to Firebase Console > Project Settings
```

## 🛠️ **Applied Fixes**

### ✅ **Enhanced Error Handling**
- Added comprehensive error catching in `main.dart`
- Added fallback mechanisms for Firebase initialization
- Added error screens in `splash_screen.dart`

### ✅ **Improved Firebase Initialization**
```dart
// Direct Firebase initialization with fallback
try {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
} catch (e) {
  // Fallback to FirebaseFix
  await FirebaseFix.initializeFirebaseWithRetry();
}
```

### ✅ **Crash-Safe Wrapper**
```dart
runZonedGuarded(() async {
  // App initialization
}, (error, stack) {
  print('❌ UNHANDLED ERROR: $error');
});
```

## 🧪 **Testing Protocol**

### **Step 1: Debug Testing**
```bash
flutter run --debug
```
- Check console for error messages
- Monitor Firebase initialization
- Test all features

### **Step 2: Release Testing**
```bash
flutter build apk --release
flutter install --release
```
- Install on physical device
- Test app startup
- Monitor for crashes

### **Step 3: Log Analysis**
```bash
# Check device logs
adb logcat | grep -E "(flutter|firebase|crash)"
```

## 🚨 **Common Crash Causes & Solutions**

### 1. **Firebase Initialization Crashes**
**Symptoms**: App crashes immediately on startup
**Solutions**:
- Check internet connectivity
- Verify Firebase project configuration
- Check `google-services.json` file
- Test with Firebase disabled

### 2. **Memory Issues**
**Symptoms**: App crashes after a few seconds
**Solutions**:
- Reduce image sizes
- Optimize memory usage
- Check for memory leaks

### 3. **Permission Issues**
**Symptoms**: App crashes when accessing features
**Solutions**:
- Check AndroidManifest.xml permissions
- Request runtime permissions
- Handle permission denials

### 4. **Asset Loading Issues**
**Symptoms**: App crashes when loading images/assets
**Solutions**:
- Verify asset paths in pubspec.yaml
- Add error builders for images
- Use fallback assets

## 🔧 **Immediate Fixes Applied**

### **Enhanced Main.dart**
```dart
void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('❌ FLUTTER ERROR: ${details.exception}');
  };

  runZonedGuarded(() async {
    // App initialization with error handling
  }, (error, stack) {
    print('❌ UNHANDLED ERROR: $error');
  });
}
```

### **Improved Splash Screen**
```dart
class SplashScreen extends StatefulWidget {
  final bool firebaseInitialized;
  
  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return ErrorScreen(); // Fallback error screen
    }
    // Normal splash screen
  }
}
```

### **Firebase Fallback**
```dart
try {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
} catch (e) {
  // Continue without Firebase
  firebaseInitialized = false;
}
```

## 📱 **Device-Specific Testing**

### **Android Testing Checklist:**
1. **Clean Installation**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

2. **Fresh Device Test**
   - Uninstall existing app
   - Clear device cache
   - Install fresh APK

3. **Permission Check**
   - Grant all required permissions
   - Test with permissions denied
   - Check runtime permissions

4. **Network Testing**
   - Test with WiFi
   - Test with mobile data
   - Test offline mode

## 🔍 **Debug Information**

### **Current Build Status:**
- ✅ Debug APK: Built successfully
- ✅ Release APK: Built successfully (67.8MB)
- ✅ Firebase Configuration: Present
- ✅ Assets: All present

### **Error Logging:**
- Added comprehensive error logging
- Added Firebase initialization tracking
- Added crash reporting

### **Fallback Mechanisms:**
- Firebase initialization fallback
- Error screens for crashes
- Graceful degradation

## 🎯 **Next Steps**

### **Immediate Actions:**
1. **Install the new APK** on your device
2. **Check device logs** for specific error messages
3. **Test on different devices** if possible
4. **Report specific error messages** if crashes persist

### **If Crashes Continue:**
1. **Enable verbose logging**:
   ```bash
   flutter run --verbose
   ```

2. **Check Firebase Console**:
   - Go to Firebase Console
   - Check Authentication logs
   - Verify project settings

3. **Test Minimal Version**:
   - Create a minimal test app
   - Add features one by one
   - Identify specific crash trigger

## 📞 **Support Information**

### **Debug Commands:**
```bash
# Check device logs
flutter logs

# Build with verbose output
flutter build apk --release --verbose

# Install and run
flutter install --release
```

### **Error Reporting:**
When reporting crashes, include:
1. Device model and Android version
2. Specific error messages from logs
3. Steps to reproduce the crash
4. Time of crash occurrence

## 🚀 **Expected Results**

### **After Applying Fixes:**
- ✅ App should start without crashing
- ✅ Firebase should initialize properly
- ✅ Error screens should appear if issues occur
- ✅ App should continue working even with Firebase issues

### **If Still Crashing:**
- Check device logs for specific error messages
- Test on different devices
- Verify Firebase project configuration
- Consider creating a minimal test version

---

**Status**: 🔧 **ENHANCED CRASH PREVENTION APPLIED**
**Version**: 1.0.1 Enhanced
**Last Updated**: Current
**Build Status**: SUCCESSFUL

🎯 **Please test the new APK and report any specific error messages!** 