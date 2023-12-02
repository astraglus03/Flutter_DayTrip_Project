import 'package:flutter/foundation.dart';

class SaveClass with ChangeNotifier {
  List<Map<String, dynamic>> _savedItems = [];

  List<Map<String, dynamic>> get savedItems => _savedItems;

  void toggleLike(int index, bool isLiked, String imagePath) {
    final Map<String, dynamic> item = {
      'index': index,
      'isLiked': isLiked,
      'imagePath': imagePath, // imagePath 추가
    };

    int existingIndex = _savedItems.indexWhere((element) => element['index'] == index);

    if (existingIndex != -1) {
      _savedItems.removeAt(existingIndex);
    } else {
      _savedItems.add(item);
    }

    notifyListeners();
  }
  void removeFromSavedList(int index) {
    _savedItems.removeAt(index);
    notifyListeners(); // 상태 변경 알림
  }
}