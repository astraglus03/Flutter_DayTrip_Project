import 'package:flutter/foundation.dart';

class LikeState with ChangeNotifier {
  Set<String> _likedPostIds = {}; // 사용자가 좋아요를 누른 게시물 ID를 저장하는 Set

  Set<String> get likedPostIds => _likedPostIds;

  // 좋아요 토글 기능 구현
  void toggleLike(String postId) {
    if (_likedPostIds.contains(postId)) {
      _likedPostIds.remove(postId);
    } else {
      _likedPostIds.add(postId);
    }
    notifyListeners(); // 상태 변경을 리스너에 알림
  }
}