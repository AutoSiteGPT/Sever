package com.sever.app

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.view.accessibility.AccessibilityEvent

class AppBlockerAccessibilityService : AccessibilityService() {
    
    companion object {
        var blockedPackages: Set<String> = emptySet()
        var isBlocking: Boolean = false
    }
    
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED && isBlocking) {
            val packageName = event.packageName?.toString() ?: return
            
            // Check if the current app is in the blocked list
            if (blockedPackages.contains(packageName)) {
                // Launch the friction overlay activity
                val intent = Intent(this, FrictionOverlayActivity::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                intent.putExtra("packageName", packageName)
                startActivity(intent)
            }
        }
    }
    
    override fun onInterrupt() {
        // Handle interruption
    }
    
    override fun onServiceConnected() {
        super.onServiceConnected()
        // Service is connected and ready
    }
}
