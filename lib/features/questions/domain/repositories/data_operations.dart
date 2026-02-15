import '../../data/models/questions_result.dart';


abstract class DataOperations {
  Future<void> putData({
    required GetQuestionsResult result
  });
}