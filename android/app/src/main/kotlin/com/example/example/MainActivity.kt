package com.example.example

import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter.native/myid"

    private lateinit var flutterResult: MethodChannel.Result

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "runSDK") {
                    flutterResult = result

                    val intent = Intent(this, FaceIdActivity::class.java)
                    startActivityForResult(intent, 200)
                }
            }
    }

    // override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
    //     super.onActivityResult(requestCode, resultCode, data)
    //     if (requestCode == 200) {
    //         flutterResult.success(data.getStringExtra("code").toString())
    //     }
    // }

     override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 200) {
            flutterResult.success(data.getStringExtra("code").toString())
        }
         if (requestCode != 200) {
            flutterResult.success(data.getStringExtra("message").toString())
        }
    }
}

