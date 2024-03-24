class WebtoonEpisodeModel {
  final String id;
  final String title;
  final String rating;
  final String date;

  WebtoonEpisodeModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.date,
  });

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        rating = json['rating'],
        date = json['date'];
}
