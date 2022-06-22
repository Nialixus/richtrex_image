import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:richtrex_image/richtrex_image.dart';

void main() {
  runApp(const MaterialApp(title: "RichTrex Image Demo", home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var controller = TextEditingController();

  String url =
      "https://www.kindpng.com/picc/b/355-3557482_package-icon-png.png";
  void setText(String url) => setState(() => this.url = url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Image Resize Demo")),
        body: SafeArea(
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(kToolbarHeight),
                child: RichTrexImage(url,
                    resize: false, size: const Size(100, 100)))),
        bottomSheet: Container(
            height: kToolbarHeight,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: "Insert URL Here",
                    suffixIcon: InkWell(
                        onTap: () => setText(controller.text),
                        child: Icon(Icons.send,
                            color: Colors.black.withOpacity(0.5)))))));
  }
}
