# Flutter ProGuard/R8 rules for Caf SDK
# These rules ensure the CAF SDK plugin works correctly in release builds

# The Android pre-handler for exceptions is loaded reflectively (via ServiceLoader).
-keep class kotlinx.coroutines.experimental.android.AndroidExceptionPreHandler { *; }

### GSON ##################################################################
# Gson uses generic type information stored in a class file when working with fields.
# ProGuard removes such information by default, so configure it to keep all of it.
-keepattributes Signature
# For using GSON @Expose annotation
-keepattributes *Annotation*
### END GSON ##################################################################

### Retrofit ##################################################################
# Preserve generic signatures, inner classes, and enclosing methods for Retrofit reflection.
-keepattributes Signature, InnerClasses, EnclosingMethod
# Retain runtime-visible annotations on methods and parameters.
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
# Keep annotation default values.
-keepattributes AnnotationDefault
# Retain service method parameters for interfaces with Retrofit annotations.
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}
# Suppress warnings for build tooling and certain JSR 305 annotations.
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*
# Explicitly keep Retrofit interfaces to prevent nullification by R8.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface * extends <1>
# Preserve continuations used by Kotlin suspend functions.
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
# For R8 full mode: keep generic return types for Retrofit methods.
-if interface * { @retrofit2.http.* public *** *(...); }
-keep,allowoptimization,allowshrinking,allowobfuscation class <3>
# Preserve Retrofit Response class.
-keep,allowobfuscation,allowshrinking class retrofit2.Response
### END Retrofit ##############################################################

### OkHttp ####################################################################
# Suppress warnings for JSR 305 annotations.
-dontwarn javax.annotation.**
# Adapt resource filenames for internal public suffix database.
-adaptresourcefilenames okhttp3/internal/publicsuffix/PublicSuffixDatabase.gz
# Suppress warnings for Animal Sniffer and platform-specific classes.
-dontwarn org.codehaus.mojo.animal_sniffer.*
-dontwarn okhttp3.internal.platform.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
# Keep all OkHttp and Okio classes.
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }
-dontwarn okio.**
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.ParametersAreNonnullByDefault
### END OkHttp ################################################################

### Kotlin Serialization ######################################################
# Keep Companion objects for serializable classes.
-if @kotlinx.serialization.Serializable class **
-keepclassmembers class <1> {
    static <1>$Companion Companion;
}
# Keep serializer functions on companion objects.
-if @kotlinx.serialization.Serializable class ** {
    static **$* *;
}
-keepclassmembers class <2>$<3> {
    kotlinx.serialization.KSerializer serializer(...);
}
# Retain INSTANCE and serializer for serializable objects.
-if @kotlinx.serialization.Serializable class ** {
    public static ** INSTANCE;
}
-keepclassmembers class <1> {
    public static <1> INSTANCE;
    kotlinx.serialization.KSerializer serializer(...);
}
# Preserve Companion objects in kotlinx.serialization.json.
-keepclassmembers class kotlinx.serialization.json.** {
    *** Companion;
}
-keepclasseswithmembers class kotlinx.serialization.json.** {
    kotlinx.serialization.KSerializer serializer(...);
}
# Preserve serializer lookup for serializable classes (adjust package name as needed).
-keepclassmembers @kotlinx.serialization.Serializable class packeage.** {
    *** Companion;
    *** INSTANCE;
    kotlinx.serialization.KSerializer serializer(...);
}
### END Kotlin Serialization #################################################

### AutoValue ################################################################
-dontwarn com.google.auto.**
-dontwarn autovalue.shaded.com.**
-dontwarn sun.misc.Unsafe
-dontwarn javax.lang.model.element.Modifier
### END AutoValue ############################################################

### Flutter Plugin ###########################################################
# Keep Flutter plugin classes
-keep class io.flutter.plugins.** { *; }

# Keep method channel classes
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.MethodChannel$Result { *; }

# Keep plugin registrar
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep CAF SDK Flutter plugin classes
-keep class io.caf.sdk.flutter.** { *; }
### END Flutter Plugin #######################################################

### CAF - Combate a Fraude ######################################################
# Keep exceptions attributes.
-keepattributes Exceptions
# Preserve all classes, interfaces, and class members for CAF modules.
-keep class com.caf.facelivenessiproov.** { *; }
-keep class com.combateafraude.documentdetector.** { *; }
-keep class com.combateafraude.** { *; }
-keep interface com.combateafraude.** { *; }
-keep class io.caf.** { *; }
-keep interface io.caf.** { *; }
-keepclassmembers class com.combateafraude.** { *; }
# Suppress warnings for java.nio.file and certain OkHttp internal classes.
-dontwarn java.nio.file.*
-dontwarn com.squareup.okhttp.internal.Platform
# Keep fields in classes extending GeneratedMessageLite (for Tink usage).
-keepclassmembers class * extends com.google.crypto.tink.shaded.protobuf.GeneratedMessageLite {
  <fields>;
}
# Preserve TensorFlow classes.
-keep class org.tensorflow.** { *; }
-keep class org.tensorflow.**$* { *; }
-dontwarn org.tensorflow.**
# Preserve IProov classes and Protobuf classes.
-keep public class com.iproov.sdk.IProov { public *; }
-keep class com.iproov.** { *; }
-keep class com.iproov.**$* { *; }
-keep class com.google.protobuf.** { *; }
-keep class com.google.protobuf.**$* { *; }
-dontwarn com.google.protobuf.**
# Suppress warnings for concurrent Flow classes.
-dontwarn java.util.concurrent.Flow*
# Preserve Kotlin and kotlinx classes.
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
### END CAF - Combate a Fraude ##################################################