abstract class AppDataStates<T>{
  final T? userModel;
  final String? error;
  final int? points;
  AppDataStates({this.userModel, this.error, this.points});
}

class AppDataInitialState extends AppDataStates{}

class HomeInfoLoadingState extends AppDataStates {}
class HomeInfoSuccessState extends AppDataStates {}
class HomeInfoErrorState extends AppDataStates {
  HomeInfoErrorState({super.error});
}

class QuestionsDataLoadingState extends AppDataStates {}
class QuestionsDataSuccessState extends AppDataStates {}
class QuestionsDataErrorState extends AppDataStates {
  QuestionsDataErrorState({super.error});
}

class StartDataLoadingState extends AppDataStates {}
class StartDataSuccessState extends AppDataStates {}
class StartDataErrorState<T> extends AppDataStates {
  StartDataErrorState({super.error});
}

class AppDataLoadingState extends AppDataStates {}
class AppDataSuccessState<T> extends AppDataStates {
  AppDataSuccessState({super.userModel});
}
class AppDataErrorState extends AppDataStates {
  AppDataErrorState({super.error});
}

class QuizFinishedState extends AppDataStates {
  QuizFinishedState({super.points});
}



