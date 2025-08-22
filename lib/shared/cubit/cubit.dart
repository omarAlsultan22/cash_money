import 'package:cash_money/modles/user_data.dart';
import 'package:cash_money/shared/components/constatnts.dart';
import 'package:cash_money/shared/cubit/state.dart';
import 'package:cash_money/shared/local/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';

class AppDataCubit extends Cubit<AppDataStates> {
  AppDataCubit() : super(AppDataInitialState());

  static AppDataCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int points = 0;
  String userName = 'User';
  bool showAnswer = false;
  bool isLoadingMore = false;
  DocumentSnapshot? lastDocument;


  void resetQuiz() {
    currentIndex = 0;
    points = 0;
    showAnswer = false;
    emit(AppDataInitialState());
  }

  void submitAnswer(bool isCorrect, int totalQuestions) {
    if (showAnswer) return;

    showAnswer = true;
    if (isCorrect) points++;
    Future.delayed(const Duration(seconds: 1), () {
      showAnswer = false;
      moveToNextQuestion(totalQuestions);
    });
  }

  void moveToNextQuestion([int? totalQuestions]) {
    if (state is! AppDataSuccessState) return;

    final questions = questionsData;
    totalQuestions ??= questions.length;

    if (currentIndex < totalQuestions - 1) {
      currentIndex++;
      emit(AppDataSuccessState());
    } else {
      emit(QuizFinishedState(points: points));
    }
  }

  List<QuestionModel> questionsData = [];

  Future<void> getStartData() async {
    emit(AppDataLoadingState(key: Screens.questions));
    try {
      final dataList = await getData(
          lastDocument: lastDocument,
      );
      if(dataList.isNotEmpty) {
        questionsData.addAll(dataList);
        emit(AppDataSuccessState(key: Screens.questions));
        return;
      }
      isLoadingMore = true;
      emit(AppDataSuccessState(key: Screens.questions));
    }
    catch (e) {
      emit(AppDataErrorState(error: e.toString(), key: Screens.questions));
    }
  }
  Future<void> getQuestionsData() async {
    emit(AppDataLoadingState(key: Screens.start));
    try {
      final dataList = await getData(
          lastDocument: lastDocument,
      );
      if(dataList.isNotEmpty) {
        questionsData.addAll(dataList);
        emit(AppDataSuccessState(key: Screens.start));
        return;
      }
      isLoadingMore = true;
      emit(AppDataSuccessState(key: Screens.start));
    }
    catch (e) {
      emit(AppDataErrorState(error: e.toString(), key: Screens.start));
    }
  }

  Future getInfo() async {
    emit(AppDataLoadingState(key: Screens.home));
    try {
      final uId = await CacheHelper.getValue(key: 'uId');
      FirebaseFirestore.instance.collection('users').doc(uId).get().then((
          value) {
        final map = value.data() as Map<String, dynamic>;
        UserDetails.uId = map['uId'];
        UserDetails.name = map['name'];
      });
      emit(AppDataSuccessState(key: Screens.home));
    }
    catch (e) {
      emit(AppDataErrorState(error: e.toString(), key: Screens.home));
    }
  }
}
