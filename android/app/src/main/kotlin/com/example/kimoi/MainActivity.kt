package com.example.kimoi

import android.os.StrictMode
import com.example.kimoi.extractors.MixDropExtractor
import com.example.kimoi.extractors.Mp4uploadExtractor
import com.example.kimoi.extractors.OkruExtractor
import com.example.kimoi.extractors.UploadExtractor
import com.example.kimoi.extractors.VoeExtractor
import com.example.kimoi.extractors.YourUploadExtractor
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import okhttp3.Headers

class MainActivity: FlutterActivity() {
    private val CHANNEL = ("extractors")
    val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        StrictMode.setThreadPolicy(policy)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->

            val videoList  = mutableMapOf<String, String>()

            var url = call.arguments as String;

            println(url)

            if (call.method == "extractVideoUrl" ) {

                val headers = Headers.Builder().set("referer", "https://uqload.com/").build()

                when {
                    url.contains("ok") -> if (!url.contains("streamcherry")) {
                        val videos = OkruExtractor().videosFromUrl(url)
                        videos.forEach {
                            var success = """{"url" : "${it.url}","videoUrl" : "${it.videoUrl}","quality" : "${it.quality}"}"""
                            videoList.put(it.quality , success )
                        }
                    }
                    url.contains("mp4upload") -> {
                        val videos = Mp4uploadExtractor().videosFromUrl(url, headers)
                        videos.forEach {
                            var succes = """{"url": "${it.url}","quality": "${it.quality}","videoUrl": "${it.videoUrl}"}"""
                            videoList.put(it.quality , succes )
                        }
                    }
                    url.contains("voe") -> {
                        val video = VoeExtractor().videoFromUrl(url)
                        if (video != null) {
                            var succes = """{"url": "${video.url}","quality": "${video.quality}","videoUrl":"${video.videoUrl}"}"""
                            videoList.put("Voe", succes)
                        }
                    }
                    url.contains("yourupload") -> {
                        val videos = YourUploadExtractor().videoFromUrl(url, headers)
                        videos.forEach {
                            var succes = """{"url": "${it.url}","quality": "${it.quality}","videoUrl": "${it.videoUrl}"}"""
                            videoList.put(it.quality, succes)
                        }
                    }
                    url.contains("mixdro") -> {
                        val videos = MixDropExtractor().videoFromUrl(url)
                        videos.forEach {
                            var succes = """{"url": "${it.url}","quality": "${it.quality}","videoUrl": "${it.videoUrl}"}"""
                            videoList.put(it.quality, succes)
                        }
                    }
                    url.contains("upload") -> if (!url.contains("yourupload") || !url.contains("mp4upload") ) {
                        val video = UploadExtractor().videoFromUrl(url, headers)
                        if (video != null) {
                            var success = """{"url": "${video.url}","quality": "${video.quality}","videoUrl": "${video.videoUrl}"}"""
                            videoList.put( "Upload" , success )
                        }
                    }
                }
                result.success(videoList)
            }
        }
    }
}
