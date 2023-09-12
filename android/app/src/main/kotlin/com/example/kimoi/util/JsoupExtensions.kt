package com.example.kimoi.util
import okhttp3.Response
import org.jsoup.nodes.Document

/**
 * Returns a Jsoup document for this response.
 * @param html the body of the response. Use only if the body was read before calling this method.
 */
fun Response.asJsoup(html: String? = null): Document {
    return Document(html)
}