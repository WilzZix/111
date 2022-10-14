package com.example.example

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.google.gson.Gson
import org.json.JSONObject
import uz.myid.android.sdk.capture.*
import java.util.logging.Logger
import uz.myid.android.sdk.capture.*

class FaceIdActivity : AppCompatActivity(), MyIdResultListener {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_face_id)

        startMyId()
    }

    private val TAG = "myIDLOG";

    override fun onError(e: MyIdException) {
        Log.e(TAG, e.message.toString())

        val gson = Gson()
         val resultIntent = Intent()
        // resultIntent.putExtra("code", gson.toJson(e))
        resultIntent.putExtra("message", gson.toJson(e))

        setResult(RESULT_CANCELED, resultIntent)
        finish()
    }

    override fun onSuccess(result: MyIdResult) {
        Log.w(TAG, result.toString())

        val gson = Gson()
        val resultIntent = Intent()
        resultIntent.putExtra("code", gson.toJson(result))

        setResult(RESULT_CANCELED, resultIntent)
        finish()
    }

    override fun onUserExited() {
         Log.w(TAG, "Exit")

         val resultIntent = Intent()
        // resultIntent.putExtra("code", "Пользователь покинул аутентификацию")
        resultIntent.putExtra("message", "Пользователь покинул аутентификацию")


        setResult(RESULT_CANCELED, resultIntent)
        finish()
    }

    private val client: MyIdClient = MyIdClient()
    private fun startMyId() {
        val clientId = "lendo_sdk-vF5Yvcr8bBCpH2cCvyJyo4nOd6caBaGLbMUxIHl3"
        val passportData = ""
        val dateOfBirth = ""
        val externalId = ""

        val myIdConfig = MyIdConfig.builder(clientId)
//            .withPassportData(passportData)
//            .withBirthDate(dateOfBirth)
//            .withExternalId(externalId)
            .withEntryType(MyIdEntryType.AUTH)
            .withBuildMode(MyIdBuildMode.PRODUCTION)
            .withLocale(MyIdLocale.RU)
            .withPhoto(false)
            // .withBackCamera(false)
            .build()
            

        val intent = client.createIntent(activity = this, myIdConfig)
        result.launch(intent)
    }

    private val result = takeUserResult(listener = this)
}