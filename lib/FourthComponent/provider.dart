import 'package:flutter/foundation.dart';

class LikeState with ChangeNotifier {
  Set<String> _likedPostIds = {};

  Set<String> get likedPostIds => _likedPostIds;

  void toggleLike(String postId) {
    if (_likedPostIds.contains(postId)) {
      _likedPostIds.remove(postId);
    } else {
      _likedPostIds.add(postId);
    }
    notifyListeners();
  }
}