import 'package:flutter/foundation.dart';

class SaveClass with ChangeNotifier {
  List<Map<String, dynamic>> _savedItems = [];

  List<Map<String, dynamic>> get savedItems => _savedItems;

  void toggleLike(bool isLiked, String pid, String imagePath, String spaceName) {
    final Map<String, dynamic> item = {
      'pid': pid,
      'isLiked': isLiked,
      'imagePath': imagePath,
      'spaceName': spaceName,
    };

    int existingIndex =
    _savedItems.indexWhere((element) => element['pid'] == pid);

    if (existingIndex != -1) {
      if (!isLiked) {
        _savedItems.removeAt(existingIndex);
      } else {
        _savedItems[existingIndex] = item;
      }
    } else {
      if (isLiked) {
        _savedItems.add(item);
      }
    }

    notifyListeners();
  }

  void removeFromSavedList(String pid) {
    int existingIndex =
    _savedItems.indexWhere((element) => element['pid'] == pid);
    if (existingIndex != -1) {
      _savedItems.removeAt(existingIndex);
      notifyListeners(); // 상태 변경 알림
    }
  }
}