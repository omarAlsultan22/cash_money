class AppDataStates{}

class AppDataInitialState extends AppDataStates{}

class HomeInfoLoadingState extends AppDataStates {}
class HomeInfoSuccessState extends AppDataStates {}
class HomeInfoErrorState extends AppDataStates {
  final String error;
  HomeInfoErrorState(this.error);
}

class QuestionsDataLoadingState extends AppDataStates {}
class QuestionsDataSuccessState extends AppDataStates {}
class QuestionsDataErrorState extends AppDataStates {
  final String error;
  QuestionsDataErrorState(this.error);
}

class StartDataLoadingState extends AppDataStates {}
class StartDataSuccessState extends AppDataStates {}
class StartDataErrorState extends AppDataStates {
  final String error;
  StartDataErrorState(this.error);
}

class AppDataLoadingState extends AppDataStates {}
class AppDataSuccessState<T> extends AppDataStates {
  final T? userModel;
  AppDataSuccessState({this.userModel});
}
class AppDataErrorState extends AppDataStates {
  final String error;
  AppDataErrorState(this.error);
}

class QuizFinishedState extends AppDataStates {
  final int points;
  QuizFinishedState({required this.points});
}



