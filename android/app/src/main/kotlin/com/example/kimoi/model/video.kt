package com.example.kimoi.model
import android.net.Uri
import okhttp3.Headers

data class Track(val url: String, val lang: String)

data class Video(val url: String,
                 val quality: String,
                 var videoUrl: String?,
                 val server: String,
                 val headers: Headers? = null,
                 val subtitleTracks: List<Track> = emptyList(),
                 val audioTracks: List<Track> = emptyList()
) {
    constructor(url: String,
                quality: String,
                videoUrl: String?,
                server: String,
                uri: Uri? = null,
                headers: Headers) : this(
        url,
        quality,
        videoUrl,
        server,
        headers,
    )
}

