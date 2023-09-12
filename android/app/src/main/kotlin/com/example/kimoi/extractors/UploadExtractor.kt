package com.example.kimoi.extractors

import com.example.kimoi.model.Video
import okhttp3.Headers
import org.jsoup.nodes.Document
import java.net.HttpURLConnection
import java.net.URL

class UploadExtractor() {
    fun videoFromUrl(url: String, headers: Headers): Video? {
        return try {

            val myURL = URL(url)
            val connection = myURL.openConnection() as HttpURLConnection
            connection.requestMethod = "GET"
            connection.setRequestProperty("Accept", "application/json")
            connection.setRequestProperty("referer", "https://uqload.com/")
            connection.setRequestProperty("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36")
            connection.setRequestProperty(headers.name(0), headers.value(0))
            connection.connect()

            val inputStream = connection.inputStream
            val response = inputStream.bufferedReader().readText()

            val document = Document(url).parser().parseInput(response, url)

            val basicUrl = document.selectFirst("script:containsData(var player =)")!!.data().substringAfter("sources: [\"").substringBefore("\"],")

            if (!basicUrl.contains("http")) {
                return null
            }
            return Video(basicUrl, "Uqload", basicUrl, headers = headers, server = "Upload")
        } catch (e: Exception) {
            null
        }
    }
}
