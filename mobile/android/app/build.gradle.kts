import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Chave de upload do APK de release (docs/guia-firebase.md, seção 4).
// android/key.properties e a keystore ficam fora do git.
val propriedadesChave = Properties()
val arquivoChave = rootProject.file("key.properties")
if (arquivoChave.exists()) {
    FileInputStream(arquivoChave).use { propriedadesChave.load(it) }
}

android {
    namespace = "com.circuitodescobertas.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // ID definitivo: liga o app ao Firebase (google-services.json). Não alterar.
        applicationId = "com.circuitodescobertas.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Sem key.properties, o build de release falha em vez de sair
            // assinado com a chave de debug. O build de debug não é afetado.
            if (arquivoChave.exists()) {
                keyAlias = propriedadesChave.getProperty("keyAlias")
                keyPassword = propriedadesChave.getProperty("keyPassword")
                storeFile = file(propriedadesChave.getProperty("storeFile"))
                storePassword = propriedadesChave.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
