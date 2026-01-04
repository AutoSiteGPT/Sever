package com.halt.app

import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.halt.app/blocker"
    private lateinit var permissionManager: PermissionManager
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        permissionManager = PermissionManager(this)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkAccessibilityPermission" -> {
                    result.success(isAccessibilityServiceEnabled())
                }
                "requestAccessibilityPermission" -> {
                    openAccessibilitySettings()
                    result.success(true)
                }
                "checkUsageStatsPermission" -> {
                    result.success(permissionManager.hasUsageStatsPermission())
                }
                "requestUsageStatsPermission" -> {
                    permissionManager.requestUsageStatsPermission()
                    result.success(true)
                }
                "checkBatteryOptimization" -> {
                    result.success(permissionManager.isBatteryOptimizationDisabled())
                }
                "requestBatteryOptimization" -> {
                    permissionManager.requestDisableBatteryOptimization()
                    result.success(true)
                }
                "checkAllPermissions" -> {
                    val allGranted = isAccessibilityServiceEnabled() &&
                                   permissionManager.hasAllPermissions()
                    result.success(allGranted)
                }
                "startBlockingService" -> {
                    val packageNames = call.argument<List<String>>("packageNames")
                    if (packageNames != null) {
                        startBlockingService(packageNames)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGS", "Package names required", null)
                    }
                }
                "stopBlockingService" -> {
                    stopBlockingService()
                    result.success(true)
                }
                "getInstalledApps" -> {
                    val apps = getInstalledApps()
                    result.success(apps)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun isAccessibilityServiceEnabled(): Boolean {
        val service = "${packageName}/${AppBlockerAccessibilityService::class.java.canonicalName}"
        val enabledServices = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        )
        return enabledServices?.contains(service) == true
    }
    
    private fun openAccessibilitySettings() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }
    
    private fun startBlockingService(packageNames: List<String>) {
        val intent = Intent(this, BlockingForegroundService::class.java)
        intent.putStringArrayListExtra("packageNames", ArrayList(packageNames))
        intent.action = "START_BLOCKING"
        startForegroundService(intent)
    }
    
    private fun stopBlockingService() {
        val intent = Intent(this, BlockingForegroundService::class.java)
        intent.action = "STOP_BLOCKING"
        startService(intent)
    }
    
    private fun getInstalledApps(): List<Map<String, String>> {
        val pm = packageManager
        val apps = mutableListOf<Map<String, String>>()
        
        val packages = pm.getInstalledApplications(PackageManager.GET_META_DATA)
        
        for (packageInfo in packages) {
            // Filter out system apps and the Halt app itself
            if ((packageInfo.flags and ApplicationInfo.FLAG_SYSTEM) == 0 && 
                packageInfo.packageName != packageName) {
                
                val appName = pm.getApplicationLabel(packageInfo).toString()
                apps.add(mapOf(
                    "packageName" to packageInfo.packageName,
                    "appName" to appName,
                    "iconPath" to ""
                ))
            }
        }
        
        return apps.sortedBy { it["appName"] }
    }
}
