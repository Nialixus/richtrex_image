import 'package:flutter/material.dart';

export 'image_state.dart' hide RichTrexImageState;

class RichTrexImageState with ChangeNotifier {
  RichTrexImageState({required this.size});

  Size size;
  void setSize(Size size) {
    if (size.width >= 0.0 && size.height >= 0.0 && focus) {
      this.size = size;
      notifyListeners();
    }
  }

  bool focus = false;
  late FocusNode node = FocusNode()
    ..addListener(() {
      focus = node.hasFocus;
      notifyListeners();
    });
}
