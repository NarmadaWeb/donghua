import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/donghua.dart';
import '../models/comment.dart';
import '../services/storage_service.dart';

class ContentProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Donghua> _donghuas = [];
  List<Comment> _comments = [];
  bool _isLoading = false;

  List<Donghua> get donghuas => _donghuas;
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    await _storageService.initializeData();

    final donghuasJson = await _storageService.readData('donghuas.json');
    _donghuas = donghuasJson.map((json) => Donghua.fromJson(json)).toList();

    final commentsJson = await _storageService.readData('comments.json');
    _comments = commentsJson.map((json) => Comment.fromJson(json)).toList();

    _isLoading = false;
    notifyListeners();
  }

  // CRUD for Donghua
  Future<void> addDonghua(Donghua donghua) async {
    _donghuas.add(donghua);
    await _saveDonghuas();
    notifyListeners();
  }

  Future<void> updateDonghua(Donghua updatedDonghua) async {
    final index = _donghuas.indexWhere((d) => d.id == updatedDonghua.id);
    if (index != -1) {
      _donghuas[index] = updatedDonghua;
      await _saveDonghuas();
      notifyListeners();
    }
  }

  Future<void> deleteDonghua(String id) async {
    _donghuas.removeWhere((d) => d.id == id);
    await _saveDonghuas();
    notifyListeners();
  }

  Future<void> _saveDonghuas() async {
    await _storageService.writeData('donghuas.json', _donghuas.map((d) => d.toJson()).toList());
  }

  // Comments
  List<Comment> getCommentsForDonghua(String donghuaId) {
    return _comments.where((c) => c.donghuaId == donghuaId).toList();
  }

  Future<void> addComment(String userId, String username, String donghuaId, String content) async {
    final newComment = Comment(
      id: const Uuid().v4(),
      userId: userId,
      username: username,
      donghuaId: donghuaId,
      content: content,
      timestamp: DateTime.now().toIso8601String(), // simplified timestamp
    );
    _comments.add(newComment);
    await _storageService.writeData('comments.json', _comments.map((c) => c.toJson()).toList());
    notifyListeners();
  }
}
