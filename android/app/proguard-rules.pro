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

# Stripe Android SDK rules - Updated for flutter_stripe 11.1.0
-keep class com.stripe.** { *; }
-keep class com.stripe.android.** { *; }
-keepclassmembers class com.stripe.** { *; }
-keepclassmembers class com.stripe.android.** { *; }

# Keep Stripe Payment Sheet classes
-keep class com.stripe.android.paymentsheet.** { *; }
-keep class com.stripe.android.payments.** { *; }
-keep class com.stripe.android.core.** { *; }
-keep class com.stripe.android.ui.** { *; }
-keep class com.stripe.android.model.** { *; }
-keep class com.stripe.android.networking.** { *; }
-keep class com.stripe.android.identity.** { *; }
-keep class com.stripe.android.financialconnections.** { *; }

# Keep Stripe CardBrand and related enums
-keep enum com.stripe.android.model.CardBrand { *; }
-keep enum com.stripe.android.model.** { *; }

# Keep all Stripe model classes with their fields
-keep class com.stripe.android.model.* {
    <fields>;
    <methods>;
}

# Flutter Stripe plugin specific
-keep class com.flutter.stripe.** { *; }
-keep class io.flutter.plugins.stripe.** { *; }

# Keep classes that use reflection
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Retrofit rules (if using Retrofit with Stripe)
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# OkHttp rules (often used with Stripe)
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# Gson rules (if using Gson with Stripe)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Firebase rules
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep model classes (add your specific model classes here)
-keep class com.events121.app.** { *; }

# Additional rules for Android API 33+ and recent versions
-dontwarn java.lang.invoke.StringConcatFactory
-dontwarn org.bouncycastle.jsse.BCSSLParameters
-dontwarn org.bouncycastle.jsse.BCSSLSocket
-dontwarn org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
-dontwarn org.conscrypt.Conscrypt$Version
-dontwarn org.conscrypt.Conscrypt
-dontwarn org.conscrypt.ConscryptHostnameVerifier
-dontwarn org.openjsse.javax.net.ssl.SSLParameters
-dontwarn org.openjsse.javax.net.ssl.SSLSocket
-dontwarn org.openjsse.net.ssl.OpenJSSE

# Disable warnings for missing classes
-dontwarn **
