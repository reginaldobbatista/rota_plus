plugins {
    id("com.android.application")
    // O AGP 9 já traz suporte a Kotlin; aplicar `kotlin-android` aqui gera
    // aviso de incompatibilidade com versões futuras do Flutter.
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "io.r2b.rota_plus"
    // Acima do padrão do Flutter (36) porque permission_handler_android 14.x
    // exige 37. Ao subir o Flutter, verifique se já pode voltar a
    // flutter.compileSdkVersion.
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "io.r2b.rota_plus"
        // Acima do padrão do Flutter (24) porque sentry_flutter 10 exige 26.
        // Consequência de produto: deixa de suportar Android 7.0/7.1. Em 2026
        // isso é fração pequena da base, e a alternativa seria publicar sem
        // crash reporting.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: configuração de assinatura própria antes de publicar.
            // Por enquanto assina com a chave de debug para `flutter run --release`.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// DSL do Kotlin Gradle Plugin 2.x: substitui o `kotlinOptions` dentro de
// `android {}`, que foi removido no AGP 9.
kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
