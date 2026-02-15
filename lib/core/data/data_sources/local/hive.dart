import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../features/questions/data/models/question_model.dart';
import '../../../../features/questions/data/models/questions_result.dart';


abstract class HiveOperations {
  static Box<List<GetQuestionsResult>>? _box;

  static Box get box {
    if (_box == null) {
      throw Exception('HiveOperations not initialized. Call init() first.');
    }
    return _box!;
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(QuestionModelAdapter());
    _box = await Hive.openBox<List<GetQuestionsResult>>('article');
    print('Box is opened..................');
  }

  static Future<void> putLocalData({
    required GetQuestionsResult result,
  }) async {
    try {
      await box.put(result.lastDocument, result);
      await box.flush();
      print("Data is done.........................");
    } catch (e) {
      print("Error saving local data: $e");
    }
  }

  static Future<GetQuestionsResult?> getLocalData(DocumentSnapshot? lastDocument) async {
    return await box.get(lastDocument);
  }

  static Future<void> clearData() async {
    await box.clear();
  }

  static Future<void> deleteData(DocumentSnapshot lastDocument) async {
    await box.delete(lastDocument);
  }

  static Future<void> closeBox() async {
    await box.flush();
    await _box?.close();
    await Hive.close();
  }
}