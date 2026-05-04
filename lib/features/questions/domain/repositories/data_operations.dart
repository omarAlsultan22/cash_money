import '../../data/models/questions_result.dart';


abstract class HiveDataPutter {
  Future<void> putData({
    required QuestionsData result
  });
}