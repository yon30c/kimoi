
class Episode {
  final String url;
  final String info;
  final String? date;
  final int number;
  int progress;
  bool isCompleted;
  bool wactching;

  Episode({
    required this.url,
    required this.info,
    required this.number,
    this.isCompleted = false,
    this.wactching = false,
    this.progress = 0,
    this.date,
  });
}
