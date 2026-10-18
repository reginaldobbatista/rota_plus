package io.r2b.rota_plus

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * Liga o Dart ao serviço de captura.
 *
 * Dois canais: um de comandos (ligar, desligar, consultar permissão) e um de
 * eventos, por onde as capturas sobem.
 */
class MainActivity : FlutterActivity() {

    private companion object {
        const val METHOD_CHANNEL = "io.r2b.rota_plus/monitoring"
        const val EVENT_CHANNEL = "io.r2b.rota_plus/captures"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAccessibilityEnabled" ->
                    result.success(isAccessibilityServiceEnabled())

                "canDrawOverlay" -> result.success(canDrawOverlay())

                "openAccessibilitySettings" -> {
                    // Não existe API de runtime para esta permissão: o
                    // motorista precisa ativá-la na tela do sistema.
                    startActivity(
                        Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    )
                    result.success(null)
                }

                "openOverlaySettings" -> {
                    startActivity(
                        Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:$packageName")
                        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    )
                    result.success(null)
                }

                "startMonitoring" -> {
                    val packages = call.argument<List<String>>("packages")
                        ?.toSet()
                        .orEmpty()
                    MonitoringState.start(packages)
                    MonitoringForegroundService.start(applicationContext)
                    result.success(true)
                }

                "stopMonitoring" -> {
                    MonitoringState.stop()
                    MonitoringForegroundService.stop(applicationContext)
                    result.success(true)
                }

                "isMonitoring" -> result.success(
                    MonitoringState.isMonitoring &&
                        MonitoringForegroundService.isRunning
                )

                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                MonitoringState.attach(events)
            }

            override fun onCancel(arguments: Any?) {
                MonitoringState.attach(null)
            }
        })
    }

    /**
     * Verifica se o serviço de acessibilidade do app está ativo.
     *
     * Consulta a lista do sistema em vez de confiar em `instance`: o serviço
     * pode estar habilitado nos Ajustes e ainda não ter sido conectado.
     */
    private fun isAccessibilityServiceEnabled(): Boolean {
        val expected = "$packageName/${RideCaptureAccessibilityService::class.java.name}"

        val enabled = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false

        return enabled.split(':').any { it.equals(expected, ignoreCase = true) }
    }

    private fun canDrawOverlay(): Boolean =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true
        }
}
