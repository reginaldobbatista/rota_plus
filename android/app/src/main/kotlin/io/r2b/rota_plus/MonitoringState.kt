package io.r2b.rota_plus

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

/**
 * Estado compartilhado entre o serviço de acessibilidade e o canal do Flutter.
 *
 * O `AccessibilityService` é instanciado pelo sistema, não por nós, então não
 * há como injetar dependências nele. Este objeto é o ponto de encontro.
 */
object MonitoringState {

    /** Indica se o motorista ligou o monitoramento. */
    @Volatile
    var isMonitoring: Boolean = false
        private set

    /**
     * Pacotes que o serviço pode ler.
     *
     * Definidos pelo Dart no início do monitoramento e espelhados no
     * `accessibility_config.xml`. A lista é fechada por decisão de política,
     * não por otimização.
     */
    @Volatile
    var monitoredPackages: Set<String> = emptySet()
        private set

    private var sink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    /** Liga o monitoramento para os pacotes informados. */
    fun start(packages: Set<String>) {
        monitoredPackages = packages
        isMonitoring = true
    }

    /** Desliga o monitoramento. */
    fun stop() {
        isMonitoring = false
    }

    /** Registra o destino das capturas. */
    fun attach(sink: EventChannel.EventSink?) {
        this.sink = sink
    }

    /**
     * Envia uma captura ao Dart.
     *
     * O canal exige a thread principal; o serviço de acessibilidade roda em
     * outra. Sem este salto, o envio falha silenciosamente.
     */
    fun emit(packageName: String, lines: List<String>) {
        val target = sink ?: return
        mainHandler.post {
            target.success(mapOf("package" to packageName, "lines" to lines))
        }
    }
}
