package io.r2b.rota_plus

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

/**
 * Captura o texto visível das telas de oferta do Uber, 99 e inDrive.
 *
 * Três restrições guiam esta classe, todas com motivo concreto:
 *
 * 1. **Lista fechada de pacotes.** O filtro está em `accessibility_config.xml`
 *    e é reforçado aqui. É o que separa "lê três apps de transporte" de "lê
 *    tudo o que o usuário faz no telefone", e é o item central da revisão do
 *    Google Play.
 *
 * 2. **Nada é persistido nem registrado em log.** O texto capturado vive em
 *    memória pelo tempo de atravessar o canal e é descartado. Nome, telefone e
 *    endereço do passageiro nunca saem daqui.
 *
 * 3. **Trabalho mínimo por evento.** A Uber dispara dezenas de eventos por
 *    segundo durante a animação do cartão. Percorrer a árvore inteira a cada
 *    um queimaria bateria do motorista sem produzir informação nova, então há
 *    janela de agrupamento e descarte por hash.
 */
class RideCaptureAccessibilityService : AccessibilityService() {

    companion object {
        /** Instância ativa, usada para saber se o serviço está ligado. */
        @Volatile
        var instance: RideCaptureAccessibilityService? = null
            private set

        /** Janela de agrupamento, em milissegundos. */
        private const val DEBOUNCE_MS = 250L

        /** Teto de linhas por captura. */
        private const val MAX_LINES = 60

        /** Profundidade máxima percorrida na árvore de nós. */
        private const val MAX_DEPTH = 24
    }

    private var lastEmitAt = 0L
    private var lastHash = 0

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onDestroy() {
        instance = null
        super.onDestroy()
    }

    override fun onInterrupt() = Unit

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        val packageName = event?.packageName?.toString() ?: return
        if (!MonitoringState.isMonitoring) return
        if (packageName !in MonitoringState.monitoredPackages) return

        val now = System.currentTimeMillis()
        if (now - lastEmitAt < DEBOUNCE_MS) return

        val root = rootInActiveWindow ?: return
        val lines = try {
            collectText(root)
        } finally {
            // Nó não reciclado vaza memória no processo do serviço, que fica
            // ligado o expediente inteiro.
            root.recycle()
        }

        if (lines.isEmpty()) return

        // A mesma tela reapresentada não gera informação nova.
        val hash = lines.hashCode()
        if (hash == lastHash) return

        lastHash = hash
        lastEmitAt = now
        MonitoringState.emit(packageName, lines)
    }

    /**
     * Coleta o texto visível da árvore.
     *
     * Percorre em largura com teto de profundidade e de linhas: uma tela
     * patológica não pode travar o serviço.
     */
    private fun collectText(root: AccessibilityNodeInfo): List<String> {
        val lines = ArrayList<String>(MAX_LINES)
        val queue = ArrayDeque<Pair<AccessibilityNodeInfo, Int>>()
        queue.add(root to 0)

        while (queue.isNotEmpty() && lines.size < MAX_LINES) {
            val (node, depth) = queue.removeFirst()
            if (depth > MAX_DEPTH) continue

            if (node.isVisibleToUser) {
                val text = node.text?.toString()?.trim()
                if (!text.isNullOrEmpty() && text.length <= 120) {
                    lines.add(text)
                }
            }

            for (i in 0 until node.childCount) {
                val child = node.getChild(i) ?: continue
                queue.add(child to depth + 1)
            }
        }

        return lines
    }
}
