class WebToonModel {
  final String title, thumb, id;

  // Named Constructor
  WebToonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
