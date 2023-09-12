package com.example.kimoi.extractors

import com.example.kimoi.model.Video
import org.jsoup.nodes.Document
import java.net.HttpURLConnection
import java.net.URL


class VoeExtractor() {
    fun videoFromUrl(url: String, quality: String? = null): Video? {

        val myURL = URL(url)
        val connection = myURL.openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36")
        connection.connect()

        val inputStream = connection.inputStream
        val response = inputStream.bufferedReader().readText()

        val document = Document(url).parser().parseInput(response, url)

        val script = document.selectFirst("script:containsData(const sources),script:containsData(var sources)")
            ?.data()
            ?: return null
        val videoUrl = script.substringAfter("hls': '").substringBefore("'")
        val resolution = script.substringAfter("video_height': ").substringBefore(",")
        val qualityStr = quality ?: "VoeCDN(${resolution}p)"
        return Video(url, qualityStr, videoUrl, server = "Voe")
    }
}
