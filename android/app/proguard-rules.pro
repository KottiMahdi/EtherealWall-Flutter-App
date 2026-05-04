# OkHttp3 rules
-keepattributes Signature
-keepattributes AnnotationDefault
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn okio.**
-dontwarn retrofit2.**

# Keep rules for R8 to avoid missing classes error
-keep class javax.annotation.** { *; }
-keep class org.conscrypt.** { *; }

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Dio
-keep class com.dio.** { *; }
-dontwarn com.dio.**

# Okio
-keep class okio.** { *; }
-dontwarn okio.**
