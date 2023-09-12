package com.example.kimoi.extractors

import org.jsoup.nodes.Document
import com.example.kimoi.model.Video
import java.net.HttpURLConnection
import java.net.URL

class OkruExtractor() {

    private fun fixQuality(quality: String): String {
        val qualities = listOf(
            Pair("ultra", "2160p"),
            Pair("quad", "1440p"),
            Pair("full", "1080p"),
            Pair("hd", "720p"),
            Pair("sd", "480p"),
            Pair("low", "360p"),
            Pair("lowest", "240p"),
            Pair("mobile", "144p"),
        )
        return qualities.find { it.first == quality }?.second ?: quality
    }

    fun videosFromUrl(url: String, prefix: String = "", fixQualities: Boolean = true): List<Video> {

        val myURL = URL(url)
        val connection = myURL.openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36")
        connection.connect()

        val inputStream = connection.inputStream
        val response = inputStream.bufferedReader().readText()

        val document = Document(url).parser().parseInput(response, url)


        val videosString = document.selectFirst("div[data-options]")
            ?.attr("data-options")
            ?.substringAfter("\\\"videos\\\":[{\\\"name\\\":\\\"")
            ?.substringBefore("]")
            ?: return emptyList<Video>()
        return videosString.split("{\\\"name\\\":\\\"").reversed().mapNotNull {
            val videoUrl = it.substringAfter("url\\\":\\\"")
                .substringBefore("\\\"")
                .replace("\\\\u0026", "&")
            val quality = it.substringBefore("\\\"").let {
                if (fixQualities) {
                    fixQuality(it)
                } else {
                    it
                }
            }
            val videoQuality = ("Okru:" + quality).let {
                if (prefix.isNotBlank()) {
                    "$prefix $it"
                } else {
                    it
                }
            }
            if (videoUrl.startsWith("https://")) {
                Video(videoUrl, videoQuality, videoUrl, server = "Okru")
            } else {
                null
            }
        }
    }
}
