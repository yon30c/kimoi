// ignore_for_file: constant_identifier_names

import 'dart:convert';

class Track {
  final String url;
  final String lang;

  Track(this.url, this.lang);
}

class Video {
  final String url;
  final String quality;
  String? videoUrl;
  Map<String, String>? headers;
  final List<Track> subtitleTracks;
  final List<Track> audioTracks;
  String? optionalVideoUrl;
  String? optionalQuality;


  Video({
    this.url = "",
    this.quality = "",
    this.videoUrl,
    this.headers,
    this.optionalVideoUrl,
    this.optionalQuality,
    this.subtitleTracks = const [],
    this.audioTracks = const [],
  });
  factory Video.fromRawJson(String str) => Video.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        url: json["url"],
        quality: json["quality"],
        videoUrl: json["videoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "quality": quality,
        "videoUrl": videoUrl,
      };

  Video.fromUri({
    required this.url,
    required this.quality,
    this.videoUrl,
    Uri? uri,
    this.headers,
  })  : subtitleTracks = [],
        audioTracks = [];
}

enum State {
  QUEUE,
  LOAD_VIDEO,
  DOWNLOAD_IMAGE,
  READY,
  ERROR,
}

mixin ProgressListener {
  void update(int bytesRead, int contentLength, bool done);
}
