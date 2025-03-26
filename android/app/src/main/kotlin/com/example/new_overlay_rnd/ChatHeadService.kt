package com.example.new_overlay_rnd

import android.app.*
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.view.*
import android.widget.ImageView
import androidx.core.app.NotificationCompat
import android.graphics.Point
import android.view.Display


class ChatHeadService : Service() {
    private lateinit var windowManager: WindowManager
    private lateinit var chatHeadView: View
    private lateinit var closeView: View
    private lateinit var params: WindowManager.LayoutParams
    private lateinit var closeParams: WindowManager.LayoutParams

    override fun onCreate() {
        super.onCreate()

        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        // Inflate Chat Head Layout
        chatHeadView = LayoutInflater.from(this).inflate(R.layout.chat_head, null)

        params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.TOP or Gravity.START
        params.x = 100
        params.y = 100

        // Inflate Close View Layout
        closeView = LayoutInflater.from(this).inflate(R.layout.close_view, null)

        closeParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
        closeParams.gravity = Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL

        closeParams.y = 200  // Adjust lower if needed

        windowManager.addView(closeView, closeParams)  // ✅ Add closeView first
        windowManager.addView(chatHeadView, params)   // ✅ Then add chatHeadView on top


        closeView.visibility = View.GONE // Hide "X" initially

        val chatHeadImage = chatHeadView.findViewById<ImageView>(R.id.chatHeadImage)

        chatHeadImage.setOnTouchListener(object : View.OnTouchListener {
            private var initialX: Int = 0
            private var initialY: Int = 0
            private var initialTouchX: Float = 0f
            private var initialTouchY: Float = 0f
            private val tapThreshold = 10  // Small threshold to detect tap vs drag

            override fun onTouch(view: View?, event: MotionEvent?): Boolean {
                when (event?.action) {
                    MotionEvent.ACTION_DOWN -> {
                        initialX = params.x
                        initialY = params.y
                        initialTouchX = event.rawX
                        initialTouchY = event.rawY
                        closeView.visibility = View.VISIBLE
                        windowManager.updateViewLayout(closeView, closeParams)
                        return true
                    }
                    MotionEvent.ACTION_MOVE -> {
                        params.x = initialX + (event.rawX - initialTouchX).toInt()
                        params.y = initialY + (event.rawY - initialTouchY).toInt()
                        windowManager.updateViewLayout(chatHeadView, params)
                        return true
                    }
                    MotionEvent.ACTION_UP -> {
                        closeView.visibility = View.GONE

                        val deltaX = Math.abs(event.rawX - initialTouchX)
                        val deltaY = Math.abs(event.rawY - initialTouchY)

                        if (deltaX < tapThreshold && deltaY < tapThreshold) {
                            // It's a tap, open the app
                            openApp()
                        } else if (isInsideCloseArea(params)) {
                            stopSelf() // Close the chat head
                        }
                        return true
                    }
                }
                return false
            }
        })
    }

    private fun isInsideCloseArea(params: WindowManager.LayoutParams): Boolean {
        val display: Display = windowManager.defaultDisplay
        val screenSize = Point()
        display.getSize(screenSize)

        val chatHeadCenterX = params.x + (chatHeadView.width / 2)
        val chatHeadCenterY = params.y + (chatHeadView.height / 2)

        val closeCenterX = screenSize.x / 2
        val closeCenterY = (screenSize.y - 150).toInt()  // Explicitly ensure it's an Int

        val closeThreshold = 150 // Reduce threshold for better accuracy

        return (Math.abs(chatHeadCenterX - closeCenterX) < closeThreshold) &&
                (Math.abs(chatHeadCenterY - closeCenterY) < closeThreshold)
    }

    private fun openApp() {
        val packageName = packageName
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        intent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    override fun onDestroy() {
        super.onDestroy()
        windowManager.removeView(chatHeadView)
        windowManager.removeView(closeView)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
