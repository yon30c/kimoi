package com.example.kimoi.extractors
import com.example.kimoi.model.Track
import com.example.kimoi.model.Video
import okhttp3.Headers
import java.net.HttpURLConnection
import java.net.URL

class DoodExtractor() {

    fun videoFromUrl(
        url: String,
        quality: String? = null,
        redirect: Boolean = true,
        externalSubs: List<Track> = emptyList(),
    ): Video? {
        val newQuality = quality ?: ("Doodstream" + if (redirect) " mirror" else "")

        return runCatching {
            val myURL = URL(url)
            val connection = myURL.openConnection() as HttpURLConnection
            connection.requestMethod = "GET"
            connection.setRequestProperty("Accept", "application/json")
            connection.setRequestProperty("User-agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36")
            connection.connect()

            val inputStream = connection.inputStream
            val response = inputStream.bufferedReader().readText()

            val newUrl = if (redirect) connection.url.toString() else url

            val doodHost = Regex("https://(.*?)/").find(newUrl)!!.groupValues[1]
            val content = response
            if (!content.contains("'/pass_md5/")) return null
            val md5 = content.substringAfter("'/pass_md5/").substringBefore("',")
            val token = md5.substringAfterLast("/")
            val randomString = getRandomString()
            val expiry = System.currentTimeMillis()

            val videoUrlS = URL("https://$doodHost/pass_md5/$md5")
            val connect = videoUrlS.openConnection() as HttpURLConnection
            connect.requestMethod = "GET"
            connect.setRequestProperty("referer", newUrl)
            connect.connect()

            val impStream = connect.inputStream

            val videoUrlStart = impStream.bufferedReader().readText()

            val videoUrl = "$videoUrlStart$randomString?token=$token&expiry=$expiry"
            Video(newUrl, newQuality, videoUrl, server = "Doodstream" ,headers = doodHeaders(doodHost), subtitleTracks = externalSubs)
        }.getOrNull()
    }

    fun videosFromUrl(
        url: String,
        quality: String? = null,
        redirect: Boolean = true,
    ): List<Video> {
        val video = videoFromUrl(url, quality, redirect)
        return video?.let(::listOf) ?: emptyList<Video>()
    }

    private fun getRandomString(length: Int = 10): String {
        val allowedChars = ('A'..'Z') + ('a'..'z') + ('0'..'9')
        return (1..length)
            .map { allowedChars.random() }
            .joinToString("")
    }

    private fun doodHeaders(host: String) = Headers.Builder().apply {
        add("User-Agent", "Aniyomi")
        add("Referer", "https://$host/")
    }.build()
}
