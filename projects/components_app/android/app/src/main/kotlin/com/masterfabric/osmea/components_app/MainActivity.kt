package com.masterfabric.components

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.MediaRecorder
import android.os.Build
import android.os.Environment
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
  private val CHANNEL = "osmea/notifications"
  private val MIC_CHANNEL = "osmea/microphone"
  private val CHANNEL_ID = "osmea_demo_channel"

  private var mediaRecorder: MediaRecorder? = null
  private var recordingPath: String? = null

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      when (call.method) {
        "showNotification" -> {
          val title = call.argument<String>("title") ?: "OSMEA"
          val body = call.argument<String>("body") ?: "Test notification"
          showNotification(title, body)
          result.success(true)
        }
        else -> result.notImplemented()
      }
    }

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MIC_CHANNEL).setMethodCallHandler { call, result ->
      when (call.method) {
        "start" -> {
          val started = startRecording()
          result.success(started)
        }
        "stop" -> {
          val path = stopRecording()
          result.success(path)
        }
        else -> result.notImplemented()
      }
    }
  }

  private fun startRecording(): Boolean {
    return try {
      val dir = getExternalFilesDir(Environment.DIRECTORY_MUSIC) ?: filesDir
      val file = File(dir, "osmea_record_${System.currentTimeMillis()}.m4a")
      recordingPath = file.absolutePath

      mediaRecorder = MediaRecorder()
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        mediaRecorder?.setAudioSource(MediaRecorder.AudioSource.MIC)
      } else {
        @Suppress("DEPRECATION")
        mediaRecorder?.setAudioSource(MediaRecorder.AudioSource.MIC)
      }
      mediaRecorder?.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
      mediaRecorder?.setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
      mediaRecorder?.setAudioEncodingBitRate(128000)
      mediaRecorder?.setAudioSamplingRate(44100)
      mediaRecorder?.setOutputFile(recordingPath)
      mediaRecorder?.prepare()
      mediaRecorder?.start()
      true
    } catch (e: Exception) {
      e.printStackTrace()
      false
    }
  }

  private fun stopRecording(): String? {
    return try {
      mediaRecorder?.stop()
      mediaRecorder?.release()
      mediaRecorder = null
      recordingPath
    } catch (e: Exception) {
      e.printStackTrace()
      null
    }
  }

  private fun showNotification(title: String, body: String) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val name = "OSMEA Demo"
      val descriptionText = "Demo notifications"
      val importance = NotificationManager.IMPORTANCE_HIGH
      val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
        description = descriptionText
      }
      val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
      notificationManager.createNotificationChannel(channel)
    }

    val builder = NotificationCompat.Builder(this, CHANNEL_ID)
      .setSmallIcon(R.mipmap.ic_launcher)
      .setContentTitle(title)
      .setContentText(body)
      .setPriority(NotificationCompat.PRIORITY_HIGH)

    with(NotificationManagerCompat.from(this)) {
      notify(1001, builder.build())
    }
  }
}
