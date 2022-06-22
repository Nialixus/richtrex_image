import 'package:flutter/material.dart';

import '../richtrex_image.dart';

export 'image_state.dart' hide RichTrexImageState;

/// State manager of [RichTrexImage].
class RichTrexImageState with ChangeNotifier {
  /// Managing [size] and [focus] state in [RichTrexImage] widget.
  RichTrexImageState({required this.size});

  /// Initial size fetched from [RichTrexImage].
  Size size;

  /// Update new size of [size].
  void setSize(Size size) {
    if (size.width >= 0.0 && size.height >= 0.0 && focus) {
      this.size = size;
      notifyListeners();
    }
  }

  /// Stating whether user have focus in [RichTrexImage] or not.
  bool focus = false;

  /// Node to listen [focus] state.
  late FocusNode node = FocusNode()
    ..addListener(() {
      focus = node.hasFocus;
      notifyListeners();
    });
}
