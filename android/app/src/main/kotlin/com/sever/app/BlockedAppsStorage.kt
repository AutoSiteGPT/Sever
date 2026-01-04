package com.sever.app

import android.content.Context
import android.content.SharedPreferences

/**
 * Native storage for blocked apps list
 * Persists across app restarts and device reboots
 */
class BlockedAppsStorage(context: Context) {
    
    private val prefs: SharedPreferences = context.getSharedPreferences(
        "sever_blocked_apps",
        Context.MODE_PRIVATE
    )
    
    companion object {
        private const val KEY_BLOCKED_PACKAGES = "blocked_packages"
        private const val KEY_IS_BLOCKING_ACTIVE = "is_blocking_active"
        private const val DELIMITER = "|||"
    }
    
    /**
     * Save list of blocked package names
     */
    fun saveBlockedPackages(packageNames: List<String>) {
        val joined = packageNames.joinToString(DELIMITER)
        prefs.edit().putString(KEY_BLOCKED_PACKAGES, joined).apply()
    }
    
    /**
     * Get list of blocked package names
     */
    fun getBlockedPackages(): Set<String> {
        val joined = prefs.getString(KEY_BLOCKED_PACKAGES, "") ?: ""
        if (joined.isEmpty()) return emptySet()
        return joined.split(DELIMITER).toSet()
    }
    
    /**
     * Set blocking active state
     */
    fun setBlockingActive(active: Boolean) {
        prefs.edit().putBoolean(KEY_IS_BLOCKING_ACTIVE, active).apply()
    }
    
    /**
     * Check if blocking is active
     */
    fun isBlockingActive(): Boolean {
        return prefs.getBoolean(KEY_IS_BLOCKING_ACTIVE, false)
    }
    
    /**
     * Clear all blocked apps
     */
    fun clearAll() {
        prefs.edit().clear().apply()
    }
}
