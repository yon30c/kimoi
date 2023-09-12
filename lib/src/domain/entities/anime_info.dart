import '../domain.dart';

class AnimeInfo {
  final String episodios;
  final String tipo;
  final String title;
  final String estado;
  final String estreno;
  final String imageUrl;
  final String idioma;
  final String? description;
  final List<String> genres;
  final List<List<Chapter>> episodes;
  final List<Anime> related;

  AnimeInfo(
      {
      required this.title,
      required this.related,
      required this.estado,
      required this.idioma,
      required this.episodios,
      required this.estreno,
      required this.tipo,
      required this.episodes,
      required this.description,
      required this.imageUrl,
      required this.genres});
}
