plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("jacoco")
}
android {
    namespace = "com.example.mobile"
    compileSdk = flutter.compileSdkVersion
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
        applicationId = "com.example.mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

jacoco {
    toolVersion = "0.8.8"
}

tasks.withType(Test) {
    finalizedBy jacocoTestReport
}

task jacocoTestReport(type: JacocoReport) {
    dependsOn testDebugUnitTest

    reports {
        xml.required = true
        html.required = true
    }

    def fileFilter = ['/R.class', '/R$.class', '**/BuildConfig.']

    def debugTree = fileTree(dir: "$buildDir/tmp/kotlin-classes/debug", excludes: fileFilter)

    sourceDirectories.setFrom files(["src/main/java"])
    classDirectories.setFrom files([debugTree])
    executionData.setFrom fileTree(dir: buildDir, includes: [
        "jacoco/testDebugUnitTest.exec"
    ])
}
