package com.halt.app

import android.app.*
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class BlockingForegroundService : Service() {
    
    companion object {
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "halt_blocking_channel"
    }
    
    private lateinit var storage: BlockedAppsStorage
    
    override fun onCreate() {
        super.onCreate()
        storage = BlockedAppsStorage(this)
        createNotificationChannel()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            "START_BLOCKING" -> {
                val packageNames = intent.getStringArrayListExtra("packageNames")
                if (packageNames != null) {
                    // Save to persistent storage
                    storage.saveBlockedPackages(packageNames)
                    storage.setBlockingActive(true)
                    
                    // Update accessibility service
                    AppBlockerAccessibilityService.blockedPackages = packageNames.toSet()
                    AppBlockerAccessibilityService.isBlocking = true
                    startForeground(NOTIFICATION_ID, createNotification())
                }
            }
            "STOP_BLOCKING" -> {
                // Clear persistent storage
                storage.setBlockingActive(false)
                
                // Stop accessibility service
                AppBlockerAccessibilityService.isBlocking = false
                AppBlockerAccessibilityService.blockedPackages = emptySet()
                stopForeground(STOP_FOREGROUND_REMOVE)
                stopSelf()
            }
        }
        
        return START_STICKY
    }
    
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "App Blocking",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Notification for active app blocking"
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    private fun createNotification(): Notification {
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            PendingIntent.FLAG_IMMUTABLE
        )
        
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(getString(R.string.foreground_service_notification_title))
            .setContentText(getString(R.string.foreground_service_notification_text))
            .setSmallIcon(android.R.drawable.ic_lock_idle_lock)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }
}
