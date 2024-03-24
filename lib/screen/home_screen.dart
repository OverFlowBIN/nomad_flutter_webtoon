import 'package:flutter/material.dart';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:flutter_webtoon/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebToonModel>> webToons = ApiService().getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          title: const Text(
            "오늘의 웹툰",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            // snapshot을 이용하면 Future의 상태를 확인할 수 있습니다.
            if (snapshot.hasData) {
              return const Text("There is data");
            }
            return const Text("Loading...");
          },
          future: webToons,
        ));
  }
}
