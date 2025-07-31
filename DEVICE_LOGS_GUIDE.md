# Device Logs Guide - Troubleshooting App Crashes

## 🚨 **Current Situation:**
- App crashes after installation via Google Drive
- Need to get device logs to identify the cause
- Device is connected but not authorized

## 📱 **Step 1: Authorize Your Device**

### **Enable USB Debugging:**
1. **On your Android phone:**
   - Go to **Settings**
   - Scroll down and tap **"About phone"**
   - Tap **"Build number" 7 times** (you'll see "You are now a developer!")
   - Go back to **Settings** → **Developer options**
   - Enable **"USB debugging"**

2. **Connect and Authorize:**
   - Connect your phone to your Mac via USB cable
   - On your phone, look for a popup: **"Allow USB debugging?"**
   - Tap **"Allow"** and check **"Always allow from this computer"**

3. **Verify Connection:**
   ```bash
   adb devices
   ```
   Should show: `QSNR5D5DS8ORFERS    device` (instead of "unauthorized")

## 🔍 **Step 2: Get Crash Logs**

### **Once Device is Authorized, Run These Commands:**

```bash
# Check device connection
adb devices

# Get all crash logs
adb logcat | grep -E "(FATAL|crash|Exception|Error)"

# Get Flutter-specific logs
adb logcat | grep -E "(flutter|Flutter)"

# Get Firebase-specific logs
adb logcat | grep -E "(firebase|Firebase)"

# Get logs for your specific app
adb logcat | grep "com.drviki.app"

# Get all logs and save to file
adb logcat > crash_logs.txt
```

## 📦 **Step 3: Test Both APK Versions**

### **Available APKs:**
1. **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk` (More detailed logs)
2. **Release APK**: `build/app/outputs/flutter-apk/app-release.apk` (Optimized)

### **Installation Steps:**
1. **Upload both APKs to Google Drive**
2. **Download and install the Debug APK first**
3. **Run the app and check for crashes**
4. **Get logs using the commands above**

## 🧪 **Step 4: Real-time Log Monitoring**

### **Monitor Logs While App Runs:**
```bash
# Monitor logs in real-time
adb logcat | grep -E "(flutter|firebase|crash|FATAL|Exception)"

# Or save logs to file while testing
adb logcat > app_logs.txt
```

### **Test Sequence:**
1. **Clear app data** (if previously installed)
2. **Install debug APK**
3. **Start monitoring logs:**
   ```bash
   adb logcat | grep -E "(flutter|firebase|crash)"
   ```
4. **Open the app**
5. **Watch for error messages in the terminal**

## 🔧 **Step 5: Alternative Log Methods**

### **Method A: Using Android Studio**
1. **Open Android Studio**
2. **Connect your device**
3. **Go to View → Tool Windows → Logcat**
4. **Filter by package: `com.drviki.app`**

### **Method B: Using Device's Built-in Logs**
1. **Settings → Developer options → Bug report shortcut**
2. **Enable it and use the shortcut**
3. **Share the bug report**

### **Method C: Using Flutter Doctor**
```bash
flutter doctor -v
flutter logs
```

## 📋 **Step 6: What to Look For**

### **Common Crash Indicators:**
```
FATAL EXCEPTION: main
java.lang.RuntimeException
android.content.ActivityNotFoundException
firebase.FirebaseException
flutter.FlutterException
```

### **Firebase-Specific Errors:**
```
FirebaseApp not initialized
google-services.json not found
Authentication failed
Network error
```

### **Flutter-Specific Errors:**
```
Flutter engine initialization failed
Asset loading error
Widget build error
```

## 🚨 **Step 7: Immediate Actions**

### **If Device Won't Authorize:**
1. **Try different USB cable**
2. **Try different USB port**
3. **Restart both phone and Mac**
4. **Check if phone shows "USB debugging" notification**

### **If No Logs Appear:**
1. **Check if app actually crashes or just closes**
2. **Try installing on different device**
3. **Check if logs are being filtered**

### **If Logs Show Firebase Issues:**
1. **Check internet connection**
2. **Verify Firebase project settings**
3. **Check google-services.json file**

## 📞 **Step 8: Report Findings**

### **When Reporting, Include:**
1. **Device model and Android version**
2. **Specific error messages from logs**
3. **Steps to reproduce the crash**
4. **Whether it happens on debug or release APK**
5. **Whether it happens on different devices**

### **Example Report:**
```
Device: Samsung Galaxy S21, Android 13
Error: FATAL EXCEPTION: main
java.lang.RuntimeException: Firebase not initialized
Steps: Install APK → Open app → Immediate crash
```

## 🎯 **Expected Results**

### **After Following These Steps:**
- ✅ Device should be authorized
- ✅ Logs should be visible
- ✅ Specific error messages should be identified
- ✅ Root cause of crash should be clear

### **If Still Having Issues:**
1. **Try the debug APK** (more detailed logs)
2. **Test on different device**
3. **Check if it's a device-specific issue**
4. **Report specific error messages**

---

**Status**: 🔧 **READY FOR LOG ANALYSIS**
**Next Step**: Authorize device and get crash logs
**APKs Ready**: Debug and Release versions available

🎯 **Please follow these steps and share the specific error messages you find!** 