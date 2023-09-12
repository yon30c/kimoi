package com.example.kimoi.extractors

import com.example.kimoi.model.Video
import okhttp3.Headers
import org.jsoup.nodes.Document
import java.net.HttpURLConnection
import java.net.URL

class YourUploadExtractor() {
    fun videoFromUrl(url: String, headers: Headers, name: String = "YourUpload", prefix: String = ""): List<Video> {
        val newHeaders = headers.newBuilder().add("referer", "https://www.yourupload.com/").build()
        return runCatching {

            val myURL = URL(url)
            val connection = myURL.openConnection() as HttpURLConnection
            connection.requestMethod = "GET"
            connection.setRequestProperty("Accept", "application/json")
            connection.setRequestProperty("referer", "https://www.yourupload.com/")
            connection.setRequestProperty("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36")
            connection.connect()

            val inputStream = connection.inputStream
            val response = inputStream.bufferedReader().readText()

            val document = Document(url).parser().parseInput(response, url)

            val baseData = document.selectFirst("script:containsData(jwplayerOptions)")?.data()
            if (!baseData.isNullOrEmpty()) {
                val basicUrl = baseData.substringAfter("file: '").substringBefore("',")
                val quality = prefix + name
                listOf(Video(basicUrl, quality, basicUrl, server = "YourUpload" ,  headers = newHeaders))
            } else {
                null
            }
        }.getOrNull() ?: emptyList<Video>()
    }
}
