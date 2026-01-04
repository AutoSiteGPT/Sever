package com.sever.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

/**
 * Receives BOOT_COMPLETED broadcast to restart blocking service
 * after device reboot
 */
class BootReceiver : BroadcastReceiver() {
    
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            // Check if blocking was active before reboot
            val storage = BlockedAppsStorage(context)
            if (storage.isBlockingActive()) {
                val blockedPackages = storage.getBlockedPackages()
                
                if (blockedPackages.isNotEmpty()) {
                    // Restart the blocking service
                    val serviceIntent = Intent(context, BlockingForegroundService::class.java)
                    serviceIntent.action = "START_BLOCKING"
                    serviceIntent.putStringArrayListExtra(
                        "packageNames",
                        ArrayList(blockedPackages)
                    )
                    
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        context.startForegroundService(serviceIntent)
                    } else {
                        context.startService(serviceIntent)
                    }
                }
            }
        }
    }
}
