plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.noads.browser"
    compileSdk = 35  // ✅ Support Android 15 (API 35)

    defaultConfig {
        applicationId = "com.noads.browser"
        minSdk = 21
        targetSdk = 35  // ✅ Target Android 15 (API 35)
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // ⚠️ Ganti ke signingConfig release saat rilis final
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
