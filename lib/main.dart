import 'package:flutter/material.dart';
import 'package:flutteranim/anim_widgets/animation_example2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark),
      home: const AnimationExample2(),
    );
  }
}
