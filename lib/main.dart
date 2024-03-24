import 'package:flutter/material.dart';
import 'package:flutter_webtoon/screen/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wettoon',
      home: HomeScreen(),
    );
  }
}
