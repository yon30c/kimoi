package com.example.kimoi.extractors
import com.example.kimoi.model.Video
import dev.datlag.jsunpacker.JsUnpacker
import okhttp3.Headers
import org.jsoup.nodes.Document
import java.net.HttpURLConnection
import java.net.URL

class Mp4uploadExtractor() {

    fun videosFromUrl(url: String, headers: Headers, prefix: String = "", suffix: String = ""): List<Video> {
        val newHeaders = headers.newBuilder()
            .add("referer", REFERER)
            .build()


        val myURL = URL(url)
        val connection = myURL.openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("referer", "https://mp4upload.com/")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36")
        connection.connect()

        val inputStream = connection.getInputStream()
        val response = inputStream.bufferedReader().readText()

        val doc = Document(url).parser().parseInput(response, url)

        val script = doc.selectFirst("script:containsData(eval):containsData(p,a,c,k,e,d)")?.data()
            ?.let(JsUnpacker::unpackAndCombine)
            ?: doc.selectFirst("script:containsData(player.src)")?.data()
            ?: return emptyList()

        // Close the input stream.
        inputStream.close()

        val videoUrl = script.substringAfter(".src(").substringBefore(")")
            .substringAfter("src:").substringAfter('"').substringBefore('"')

        val resolution = QUALITY_REGEX.find(script)?.groupValues?.let { "${it[1]}p" } ?: "Unknown resolution"
        val quality = "${prefix}Mp4Upload - $resolution$suffix"

        return listOf(Video(videoUrl, quality, videoUrl,"Mp4Upload" ,headers =  newHeaders))
    }

    companion object {
        private val QUALITY_REGEX by lazy { """\WHEIGHT=(\d+)""".toRegex() }
        private const val REFERER = "https://mp4upload.com/"
    }
}
