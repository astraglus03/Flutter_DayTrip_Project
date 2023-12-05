import 'package:flutter/material.dart';

class LikedItemsProvider with ChangeNotifier {
  List<Set<int>> likedItemsList = List.generate(6, (_) => {});

  void toggleLikedItem(int tabIndex, int index) {
    if (likedItemsList[tabIndex].contains(index)) {
      likedItemsList[tabIndex].remove(index);
    } else {
      likedItemsList[tabIndex].add(index);
    }
    notifyListeners();
  }
}