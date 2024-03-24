import 'dart:convert';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = 'today';

  Future<List<WebToonModel>> getTodaysToons() async {
    List<WebToonModel> webToonInstances = [];
    final url = Uri.parse('$baseUrl/$today');

    // return Future<Response> (without await)
    // return Response (with await)
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> webToonList =
          jsonDecode(res.body); // jsonDecode default type is dynamic

      for (var webToon in webToonList) {
        final toon = WebToonModel.fromJson(webToon);
        webToonInstances.add(toon);
      }
      return webToonInstances;
    }

    throw Error();
  }
}
