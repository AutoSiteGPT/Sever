package com.halt.app

import android.app.Activity
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.TextView

class FrictionOverlayActivity : Activity() {
    
    private var isHolding = false
    private var holdStartTime = 0L
    private val holdDuration = 5000L // 5 seconds
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var progressText: TextView
    private lateinit var appNameText: TextView
    
    private val updateProgressRunnable = object : Runnable {
        override fun run() {
            if (isHolding) {
                val elapsed = System.currentTimeMillis() - holdStartTime
                val remaining = ((holdDuration - elapsed) / 1000).toInt() + 1
                
                if (remaining > 0) {
                    progressText.text = remaining.toString()
                    handler.postDelayed(this, 100)
                } else {
                    // Hold complete, dismiss
                    finish()
                }
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Make this activity full screen and show over lock screen
        window.addFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN or
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
        )
        
        setContentView(R.layout.activity_friction_overlay)
        
        progressText = findViewById(R.id.progressText)
        appNameText = findViewById(R.id.appNameText)
        
        val packageName = intent.getStringExtra("packageName") ?: ""
        val appName = getAppName(packageName)
        appNameText.text = "$appName\nis blocked"
        
        progressText.text = "HOLD"
        
        val rootView = findViewById<View>(R.id.rootView)
        rootView.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    startHold()
                    true
                }
                MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                    stopHold()
                    true
                }
                else -> false
            }
        }
    }
    
    private fun startHold() {
        if (!isHolding) {
            isHolding = true
            holdStartTime = System.currentTimeMillis()
            handler.post(updateProgressRunnable)
        }
    }
    
    private fun stopHold() {
        if (isHolding) {
            isHolding = false
            handler.removeCallbacks(updateProgressRunnable)
            progressText.text = "HOLD"
        }
    }
    
    private fun getAppName(packageName: String): String {
        return try {
            val pm = packageManager
            val appInfo = pm.getApplicationInfo(packageName, 0)
            pm.getApplicationLabel(appInfo).toString().uppercase()
        } catch (e: PackageManager.NameNotFoundException) {
            "APP"
        }
    }
    
    override fun onBackPressed() {
        // Prevent back button from dismissing
    }
    
    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(updateProgressRunnable)
    }
}
