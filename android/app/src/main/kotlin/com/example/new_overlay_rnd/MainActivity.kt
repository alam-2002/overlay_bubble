//package com.example.new_overlay_rnd
//
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity()


package com.example.new_overlay_rnd

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "chat_head_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startChatHead" -> {
                    val intent = Intent(this, ChatHeadService::class.java)
                    startService(intent)
                    result.success("Chat head started")
                }
                "stopChatHead" -> {
                    val intent = Intent(this, ChatHeadService::class.java)
                    stopService(intent)
                    result.success("Chat head stopped")
                }
                else -> result.notImplemented()
            }
        }
    }
}
