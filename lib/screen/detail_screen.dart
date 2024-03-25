import 'package:flutter/material.dart';
import 'package:flutter_webtoon/models/webtoon_detail_model.dart';
import 'package:flutter_webtoon/models/webtoon_episode_model.dart';
import 'package:flutter_webtoon/services/api_service.dart';
import 'package:flutter_webtoon/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;
  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  // 여기에 넣는 이유는 DetailScreen을 호출할 떄 poperty만 가지고오고,
  // sharedPreference는 property와 관계 없이 사용하기 위해
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.id)) {
        // 좋아요를 누른 웹툰이라면
        // setState()를 호출하여 화면을 다시 그립니다.
        setState(() {
          // 좋아요를 누른 웹툰이라면
          // setState()를 호출하여 화면을 다시 그립니다.
          // 만약 setState()를 호출하지 않으면 isLiked 값이 변경되어도 화면에 반영되지 않습니다.
          isLiked = true;
        });
      }
    } else {
      // initState에서 await을 사용하면 build() 메서드가 호출되기 전에 Future가 완료된다.
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    // initState()는 State 객체가 생성된 후 호출되는 메서드입니다.
    // initState()는 반드시 build() 메서드보다 먼저 호출되며, State 객체의 초기화 작업을 수행합니다.
    // State 객체가 생성된 후 한 번만 호출되므로, 여기서 Future를 초기화하는 것이 좋습니다.
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodeById(widget.id);
    initPrefs();
  }

  void favoriteOnPressed() async {
    final likedToons = prefs.getStringList('likedToons');
    if (!isLiked) {
      likedToons!.add(widget.id);
    } else {
      likedToons!.remove(widget.id);
    }
    await prefs.setStringList('likedToons', likedToons);
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: favoriteOnPressed,
            icon: Icon(isLiked
                ? Icons.favorite_outlined
                : Icons.favorite_outline_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 300,
                      clipBehavior: Clip
                          .hardEdge, // clipBehavior 때문에 이미지에 boarderRadius가 적용되지 않기에 Clip.hardEdge로 변경
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Image.network(
                        widget.thumb,
                        headers: const {
                          "User-Agent":
                              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // ListView 또는 데이터가 별로 없으면 Column으로 대체 가능
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(episode: episode, webtoonId: widget.id)
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
