import 'dart:convert';
import 'package:flutter_webtoon/models/webtoon_detail_model.dart';
import 'package:flutter_webtoon/models/webtoon_episode_model.dart';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = 'today';

  /// Get today's webtoons
  static Future<List<WebToonModel>> getTodaysToons() async {
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

  /// Get webtoon by id
  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final webtoon = jsonDecode(res.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }

    throw Error();
  }

  /// Get episode by id
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodeById(
      String id) async {
    List<WebtoonEpisodeModel> webToonInstances = [];
    final url = Uri.parse('$baseUrl/$id/episodes');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final episodeLatestList = jsonDecode(res.body);
      for (var episode in episodeLatestList) {
        webToonInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return webToonInstances;
    }

    throw Error();
  }
}
