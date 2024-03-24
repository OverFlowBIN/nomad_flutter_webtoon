import 'package:flutter/material.dart';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:flutter_webtoon/services/api_service.dart';
import 'package:flutter_webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebToonModel>> webToons = ApiService.getTodaysToons();

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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          // snapshot을 이용하면 Future의 상태를 확인할 수 있습니다.
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(child: makeList(snapshot)),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: webToons,
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebToonModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      separatorBuilder: (context, index) {
        return const SizedBox(width: 40);
      },
      itemBuilder: (context, index) {
        var webToon = snapshot.data![index];
        return Webtoon(
          title: webToon.title,
          thumb: webToon.thumb,
          id: webToon.id,
        );
      },
    );
  }
}
