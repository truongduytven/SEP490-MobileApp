package com.example.sepp490

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.sepp490/navigation"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Check if the activity was started with an intent
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        intent?.let {
            val navigateTo = it.getStringExtra("navigateTo")
            if (navigateTo == "home_doctor_advise") {
                flutterEngine?.dartExecutor?.binaryMessenger?.let { it1 -> MethodChannel(it1, CHANNEL).invokeMethod("navigateTo", "home_doctor_advise") }
            }
        }
    }
}