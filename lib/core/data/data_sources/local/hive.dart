import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../features/questions/data/models/question_model.dart';
import '../../../../features/questions/data/models/questions_result.dart';


class HiveService {
  static Box<List<QuestionsData>>? _box;

  static Box get box {
    if (_box == null) {
      throw Exception('HiveOperations not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QuestionModelAdapter());
    _box = await Hive.openBox<List<QuestionsData>>('article');
    print('Box is opened..................');
  }

  Future<void> putLocalData({
    required QuestionsData result,
  }) async {
    try {
      await box.put(result.lastDocument, result);
      await box.flush();
      print("Data is done.........................");
    } catch (e) {
      print("Error saving local data: $e");
    }
  }

  Future<QuestionsData?> getLocalData(DocumentSnapshot? lastDocument) async {
    return await box.get(lastDocument);
  }

  Future<void> clearData() async {
    await box.clear();
  }

  Future<void> deleteData(DocumentSnapshot lastDocument) async {
    await box.delete(lastDocument);
  }

  Future<void> closeBox() async {
    await box.flush();
    await _box?.close();
    await Hive.close();
  }
}