package com.example.annette_app_x

import android.content.Intent
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.net.Uri
import java.io.BufferedReader
import java.io.InputStreamReader
import android.util.Log

class MainActivity : FlutterActivity() {

    private var sharedText: String? = null
    private val CHANNEL = "com.example.annette_app_x/homework_sharing"
    var channel: MethodChannel? = null

    fun handleViewText(intent: Intent) {
        Log.d("MainActivity.kt (handleViewText)", intent.action.toString())
        if (intent.action == Intent.ACTION_VIEW) {
            val dataUri = intent.data
            if (dataUri != null) {
                try {
                    val inputStream = contentResolver.openInputStream(dataUri)
                    val reader = BufferedReader(InputStreamReader(inputStream))
                    val stringBuilder = StringBuilder()

                    var line: String?
                    while (reader.readLine().also { line = it } != null) {
                        stringBuilder.append(line)
                        stringBuilder.append('\n')
                    }

                    val fileContent = stringBuilder.toString()

                    sharedText = fileContent

                    // Now 'fileContent' contains the content of the file
                    // You can display or process it as needed
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
        //intent.getStringExtra(Intent.EXTRA_TEXT)*/
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val action = intent.action
        val type = intent.type

        Log.d("MainActivity.kt (onNewIntent)", "NewIntent")
        Log.d("MainActivity.kt (onNewIntent)", intent.type.toString())
        
        if(type != null && channel != null) {
            handleViewText(intent) // Handle text being viewed

            channel!!.invokeMethod("importHomework", sharedText)
            }
    }
    
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
    }
}