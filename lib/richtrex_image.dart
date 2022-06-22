library richtrex_image;

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'src/image_state.dart';
import 'src/image_foreground.dart';

class RichTrexImage extends StatelessWidget {
  const RichTrexImage(this.url,
      {Key? key, required this.size, this.onChanged, this.resize = true})
      : super(key: key);
  final String url;
  final Size size;
  final bool resize;
  final void Function(Size size)? onChanged;

  @override
  Widget build(BuildContext context) {
    Widget error = Consumer<RichTrexImageState>(
        builder: (_, value, __) => Icon(
              Icons.image_sharp,
              color: Colors.grey,
              size: value.size.width,
            ));
    const Widget loading = CircularProgressIndicator();
    return ChangeNotifierProvider(
      create: (_) => RichTrexImageState(size: size),
      builder: (stateContext, child) {
        RichTrexImageState state = stateContext.read<RichTrexImageState>();
        state.addListener(
            () => onChanged != null ? onChanged!(state.size) : null);
        return GestureDetector(
            onTap: () => resize ? state.node.requestFocus() : () {},
            onPanUpdate: (pan) =>
                state.setSize(Size(pan.localPosition.dx, pan.localPosition.dy)),
            child: Focus(focusNode: state.node, child: child!));
      },
      child: Consumer<RichTrexImageState>(
          builder: (_, value, child) => CustomPaint(
              size: value.size,
              foregroundPainter: value.focus
                  ? const ImageForeground(color: Colors.blue)
                  : null,
              child: child!),
          child: FutureBuilder<String>(
              future: Future.value(url),
              builder: (_, snap) {
                if (snap.hasData == true) {
                  try {
                    if (snap.data!.startsWith("http")) {
                      return Consumer<RichTrexImageState>(
                          builder: (_, value, __) {
                        if (snap.data!.endsWith(".svg")) {
                          return SvgPicture.network(snap.data!,
                              placeholderBuilder: (_) => loading,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        }
                        return Image.network(snap.data!,
                            loadingBuilder: (_, child, progress) =>
                                progress?.cumulativeBytesLoaded ==
                                        progress?.expectedTotalBytes
                                    ? child
                                    : loading,
                            fit: BoxFit.fill,
                            width: value.size.width,
                            height: value.size.height);
                      });
                    } else if (snap.data!.startsWith("data")) {
                      final Uint8List memory =
                          base64Decode(snap.data!.split(",").last);
                      return Consumer<RichTrexImageState>(
                          builder: (_, value, __) => Image.memory(memory,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height));
                    }
                    return error;
                  } catch (e) {
                    return error;
                  }
                }

                return error;
              })),
    );
  }
}
