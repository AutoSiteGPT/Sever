package com.halt.app

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.content.ContextCompat

/**
 * Manages all permissions required for app blocking
 * - Accessibility Service
 * - UsageStats
 * - Battery Optimization exemption
 */
class PermissionManager(private val context: Context) {
    
    /**
     * Check if UsageStats permission is granted
     */
    fun hasUsageStatsPermission(): Boolean {
        return try {
            val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    android.os.Process.myUid(),
                    context.packageName
                )
            } else {
                @Suppress("DEPRECATION")
                appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    android.os.Process.myUid(),
                    context.packageName
                )
            }
            mode == AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            false
        }
    }
    
    /**
     * Open UsageStats permission settings
     */
    fun requestUsageStatsPermission() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(intent)
    }
    
    /**
     * Check if battery optimization is disabled for this app
     */
    fun isBatteryOptimizationDisabled(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            powerManager.isIgnoringBatteryOptimizations(context.packageName)
        } else {
            true // Not applicable on older versions
        }
    }
    
    /**
     * Request to disable battery optimization
     */
    fun requestDisableBatteryOptimization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            try {
                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
                intent.data = Uri.parse("package:${context.packageName}")
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startActivity(intent)
            } catch (e: Exception) {
                // Fallback to general battery settings
                val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startActivity(intent)
            }
        }
    }
    
    /**
     * Check if all required permissions are granted
     */
    fun hasAllPermissions(): Boolean {
        return hasUsageStatsPermission() && isBatteryOptimizationDisabled()
    }
    
    /**
     * Get list of missing permissions
     */
    fun getMissingPermissions(): List<String> {
        val missing = mutableListOf<String>()
        if (!hasUsageStatsPermission()) {
            missing.add("UsageStats")
        }
        if (!isBatteryOptimizationDisabled()) {
            missing.add("Battery Optimization")
        }
        return missing
    }
}
