package io.r2b.rota_plus

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

/**
 * Mantém o app vivo enquanto o motorista está em expediente.
 *
 * A notificação persistente não é enfeite: sem um serviço em primeiro plano o
 * Android encerra o processo depois de alguns minutos com a tela desligada, e
 * o monitoramento simplesmente pararia sem aviso.
 */
class MonitoringForegroundService : Service() {

    companion object {
        private const val CHANNEL_ID = "rota_plus_monitoring"
        private const val NOTIFICATION_ID = 1001

        /** Indica se o serviço está no ar. */
        @Volatile
        var isRunning: Boolean = false
            private set

        /** Sobe o serviço. */
        fun start(context: Context) {
            val intent = Intent(context, MonitoringForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        /** Encerra o serviço. */
        fun stop(context: Context) {
            context.stopService(
                Intent(context, MonitoringForegroundService::class.java)
            )
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createChannel()
        startForeground(NOTIFICATION_ID, buildNotification())
        isRunning = true
        // START_STICKY: se o sistema matar o processo por pressão de memória,
        // o serviço volta sozinho — o motorista não perde o monitoramento no
        // meio do expediente.
        return START_STICKY
    }

    override fun onDestroy() {
        isRunning = false
        super.onDestroy()
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val channel = NotificationChannel(
            CHANNEL_ID,
            "Monitoramento de corridas",
            // IMPORTANCE_LOW: a notificação precisa existir, mas não deve
            // emitir som a cada atualização enquanto a pessoa dirige.
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Mantém o Rota Plus ativo durante o expediente"
            setShowBadge(false)
        }

        getSystemService(NotificationManager::class.java)
            ?.createNotificationChannel(channel)
    }

    private fun buildNotification(): Notification {
        val openApp = packageManager.getLaunchIntentForPackage(packageName)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            openApp,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Rota Plus está ativo")
            .setContentText("Monitorando ofertas de corrida")
            .setSmallIcon(android.R.drawable.ic_menu_compass)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .build()
    }
}
