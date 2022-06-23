/// An extended package of [RichTrex] package.
library richtrex_image;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'src/image_state.dart';
import 'src/image_foreground.dart';

/// This widget allowing user to resize image.
class RichTrexImage extends StatelessWidget {
  /// Allowing user to resize image from network.
  ///
  /// ```dart
  /// RichTrexImage.network(
  ///   "https://your.image/url.png",
  ///   size: const Size(100.0, 100.0)
  /// );
  /// ```
  const RichTrexImage.network(this.source,
      {Key? key, required this.size, this.onChanged, this.resize = true})
      : _id = "network",
        super(key: key);

  /// Allowing user to resize image from memory.
  ///
  /// ```dart
  /// RichTrexImage.memory(
  ///   "data:image/svg+xml;...",
  ///   size: const Size(100.0, 100.0)
  /// );
  /// ```
  const RichTrexImage.memory(this.source,
      {Key? key, required this.size, this.onChanged, this.resize = true})
      : _id = "memory",
        super(key: key);

  /// Allowing user to resize image from asset.
  ///
  /// ```dart
  /// RichTrexImage.asset(
  ///   "assets/logo.png",
  ///   size: const Size(100.0, 100.0)
  /// );
  /// ```
  const RichTrexImage.asset(this.source,
      {Key? key, required this.size, this.onChanged, this.resize = true})
      : _id = "asset",
        super(key: key);

  /// Allowing user to resize image from file.
  ///
  /// ```dart
  /// RichTrexImage(
  ///   File("/images/logo.png").path,
  ///   size: const Size(100.0, 100.0)
  /// );
  /// ```
  const RichTrexImage.file(this.source,
      {Key? key, required this.size, this.onChanged, this.resize = true})
      : _id = "file",
        super(key: key);

  /// Image source from internet, memory, asset or file.
  final String source;

  /// Initial size of image.
  final Size size;

  /// Choose whether user allowed to resize image or not.
  ///
  /// By default [resize] is true.
  final bool resize;

  /// Updated [size] onChanged.
  final void Function(Size size)? onChanged;

  /// Private image type identifier.
  final String _id;

  @override
  Widget build(BuildContext context) {
    // Error widget displaying broken image icon.
    Widget error = Consumer<RichTrexImageState>(
        builder: (_, value, __) => Icon(
              Icons.image_sharp,
              color: Colors.grey,
              size: value.size.width,
            ));

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
              future: Future.value(source),
              builder: (_, snap) {
                if (snap.hasData == true) {
                  try {
                    if (_id == "network") {
                      return Consumer<RichTrexImageState>(
                          builder: (_, value, __) {
                        if (snap.data!.endsWith(".svg")) {
                          return SvgPicture.network(snap.data!,
                              placeholderBuilder: (_) => error,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        } else {
                          return Image.network(snap.data!,
                              loadingBuilder: (_, child, progress) =>
                                  progress != null
                                      ? progress.cumulativeBytesLoaded ==
                                              progress.expectedTotalBytes
                                          ? child
                                          : error
                                      : child,
                              errorBuilder: (_, __, ___) => error,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        }
                      });
                    } else if (_id == "memory") {
                      final Uint8List memory =
                          base64Decode(snap.data!.split(",").last);
                      return Consumer<RichTrexImageState>(
                          builder: (_, value, __) {
                        if (snap.data!.startsWith("data:image/svg+xml;")) {
                          return SvgPicture.memory(memory,
                              placeholderBuilder: (_) => error,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        } else {
                          return Image.memory(memory,
                              errorBuilder: (_, __, ___) => error,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        }
                      });
                    } else if (_id == "asset") {
                      return Consumer<RichTrexImageState>(
                          builder: (_, value, __) {
                        if (snap.data!.endsWith(".svg")) {
                          return SvgPicture.asset(snap.data!,
                              placeholderBuilder: (_) => error,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        } else {
                          return Image.asset(snap.data!,
                              errorBuilder: (_, __, ___) => error,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        }
                      });
                    } else if (_id == "file") {
                      final File file = File(snap.data!);
                      return Consumer<RichTrexImageState>(
                          builder: (_, value, __) {
                        if (file.path.endsWith(".svg")) {
                          return SvgPicture.file(file,
                              placeholderBuilder: (_) => error,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        } else {
                          return Image.file(file,
                              errorBuilder: (_, __, ___) => error,
                              fit: BoxFit.fill,
                              width: value.size.width,
                              height: value.size.height);
                        }
                      });
                    } else {
                      return error;
                    }
                  } catch (e) {
                    return error;
                  }
                } else {
                  return error;
                }
              })),
    );
  }
}
