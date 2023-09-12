package com.example.kimoi.extractors
import com.example.kimoi.model.Track
import com.example.kimoi.model.Video
import okhttp3.Headers
import org.jsoup.nodes.Document
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLDecoder

class MixDropExtractor() {
    fun videoFromUrl(
        url: String,
        lang: String = "",
        prefix: String = "",
        externalSubs: List<Track> = emptyList(),
    ): List<Video> {

        val myURL = URL(url)
        val connection = myURL.openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36")
        connection.connect()

        val inputStream = connection.inputStream
        val response = inputStream.bufferedReader().readText()

        val doc = Document(url).parser().parseInput(response, url)

        val unpacked = doc.selectFirst("script:containsData(eval):containsData(MDCore)")
            ?.data()
            ?.let(Unpacker::unpack)
            ?: return emptyList()

        val videoUrl = "https:" + unpacked.substringAfter("Core.wurl=\"")
            .substringBefore("\"")

        val subs = if ("Core.remotesub" in unpacked) {
            val subUrl = unpacked.substringAfter("Core.remotesub=\"").substringBefore("\"")
            listOf(Track(URLDecoder.decode(subUrl, "utf-8"), "sub"))
        } else {
            emptyList()
        }

        val quality = prefix + ("MixDrop").let {
            when {
                lang.isNotBlank() -> "$it($lang)"
                else -> it
            }
        }

        val headers = Headers.of("Referer", "https://mixdrop.co/")
        return listOf(Video(videoUrl, quality, videoUrl, server = "MixDrop",headers = headers, subtitleTracks = subs + externalSubs))
    }
}
