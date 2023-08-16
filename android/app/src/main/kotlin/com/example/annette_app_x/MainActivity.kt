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

class MainActivity : FlutterActivity() {

    private var sharedText: String? = null
    private val CHANNEL = "com.example.annette_app_x/homework_sharing"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = intent
        val action = intent.action
        val type = intent.type
        
        if(type != null) {
            handleViewText(intent) // Handle text being viewed
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getSharedText") {
                    result.success(sharedText)
                    //result.success(sharedText)
                }
            }
    }

    private fun handleViewText(intent: Intent) {
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
}
