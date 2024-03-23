import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:flutter_webtoon/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WebToonModel> webToons = [];
  bool IsLoading = true;

  @override
  void initState() {
    super.initState();
    waitForWebToons();
  }

  void waitForWebToons() async {
    webToons = await ApiService.getTodaysToons();
    IsLoading = false;
    setState(() {});
  }

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
    );
  }
}
