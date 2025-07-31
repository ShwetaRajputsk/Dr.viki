# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep your app's classes
-keep class com.drviki.app.** { *; }

# Keep JSON classes
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Retrofit classes
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

# Keep OkHttp classes
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Keep WebView classes
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep camera plugin classes
-keep class io.flutter.plugins.camera.** { *; }

# Keep image picker classes
-keep class io.flutter.plugins.imagepicker.** { *; }

# Keep file selector classes
-keep class io.flutter.plugins.fileselector.** { *; }

# Keep webview classes
-keep class io.flutter.plugins.webviewflutter.** { *; }

# Keep share plus classes
-keep class io.flutter.plugins.share.** { *; }

# Keep url launcher classes
-keep class io.flutter.plugins.urllauncher.** { *; }

# Keep connectivity plus classes
-keep class io.flutter.plugins.connectivity.** { *; }

# Keep google sign in classes
-keep class io.flutter.plugins.googlesignin.** { *; }

# Keep cloud functions classes
-keep class io.flutter.plugins.firebase.functions.** { *; }

# Keep font awesome classes
-keep class io.flutter.plugins.fontawesome.** { *; }

# Keep shimmer classes
-keep class io.flutter.plugins.shimmer.** { *; }

# Keep path provider classes
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep intl classes
-keep class com.google.common.** { *; }

# Keep easy localization classes
-keep class com.example.easy_localization.** { *; }

# Keep flutter markdown classes
-keep class io.flutter.plugins.flutter_markdown.** { *; } 