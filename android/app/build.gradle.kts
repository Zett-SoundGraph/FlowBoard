plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.soundgraph.flow.board"
    // Explicit 36, not flutter.compileSdkVersion — org-wide standard value
    // (see flowhub/pickup_table, already on 36), independent of whichever
    // Flutter version happens to be active when building.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.soundgraph.flow.board"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Org-wide standard value, not flutter.minSdkVersion — 23 covers
        // the oldest device in the fleet (Android 6 FrameTV); the 160T
        // unit runs Android 16, so the whole fleet's range is 23-36.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Same dev/prod split as CafeBeta-Kiosk (android/app/build.gradle.kts)
    // — a dev build gets its own applicationId (installable side-by-side
    // with prod) and app name, driven by main_dev.dart/main_prod.dart.
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Cafe Beta FlowBoard Dev")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Cafe Beta FlowBoard")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Renames the output APK from Flutter's default (app-dev-release.apk /
    // app-prod-release.apk) to
    // CafeBeta_FlowBoard_<versionName>.<versionCode, zero-padded>-<flavor>.apk
    // — see flowhub/android/app/build.gradle.kts for the fleet-wide
    // convention this mirrors (A.BC.MMDD versionName + NN versionCode, both
    // from pubspec.yaml, bumped by hand before each build). versionName
    // already carries flavor's own "-dev" suffix (see productFlavors
    // above), so this only adds the flavor name itself for prod builds.
    // Uses the older applicationVariants API (not androidComponents.
    // onVariants) — the newer Variant API's `output.outputFileName` didn't
    // resolve against this project's AGP version.
    applicationVariants.all {
        val variant = this
        variant.outputs.all {
            val output = this as com.android.build.gradle.internal.api.BaseVariantOutputImpl
            output.outputFileName =
                "CafeBeta_FlowBoard_${variant.versionName}.${variant.versionCode.toString().padStart(2, '0')}-${variant.flavorName}.apk"
        }
    }
}

flutter {
    source = "../.."
}
