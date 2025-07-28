import 'package:cash_money/modles/user_data.dart';
import 'package:cash_money/shared/components/constatnts.dart';
import 'package:cash_money/shared/cubit/state.dart';
import 'package:cash_money/shared/local/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDataCubit extends Cubit<AppDataStates> {
  AppDataCubit() : super(AppDataInitialState());

  static AppDataCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int points = 0;
  String userName = 'User';
  bool showAnswer = false;


  void resetQuiz() {
    currentIndex = 0;
    points = 0;
    showAnswer = false;
    emit(AppDataLoadingState());
    getData();
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
    if (state is! AppDataListSuccessState) return;

    final questions = dataList;
    totalQuestions ??= questions.length;

    if (currentIndex < totalQuestions - 1) {
      currentIndex++;
      emit(AppDataListSuccessState());
    } else {
      emit(QuizFinishedState(points: points));
    }
  }

  List<QuestionModel> dataList = [];

  Future getData() async {
    emit(AppDataLoadingState());
    await FirebaseFirestore.instance.collection('data')
        .doc('0Hv1zUWKuetw3eP7Nplt').collection('userData')
        .get().then((value) {
      DataModel data = DataModel.fromQuerySnapshot(value);
      dataList = data.data;
      emit(AppDataListSuccessState());
    }).catchError((error) {
      emit(AppDataErrorState(error.toString()));
    });
  }

  Future getInfo() async {
    final uId = await CacheHelper.getValue(key: 'uId');
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      final map = value.data() as Map<String, dynamic>;
      UserDetails.uId = map['uId'];
      UserDetails.name = map['name'];
    });
  }
}
