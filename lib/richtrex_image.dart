library richtrex_image;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RichTrexImage extends StatelessWidget {
  const RichTrexImage({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    const Widget error = Icon(Icons.image_sharp, color: Colors.grey);
    return FutureBuilder<String>(
        future: Future.value(url),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasData == true) {
              try {
                if (snap.data!.startsWith("http")) {
                  if (snap.data!.endsWith(".svg")) {
                    return SvgPicture.network(snap.data!);
                  }
                  return Image.network(snap.data!);
                } else if (snap.data!.startsWith("data")) {
                  return Image.memory(base64Decode(snap.data!.split(",").last));
                }
                return error;
              } catch (e) {
                return error;
              }
            }
            return error;
          }
          return const CircularProgressIndicator(
            color: Colors.grey,
          );
        });
  }
}
