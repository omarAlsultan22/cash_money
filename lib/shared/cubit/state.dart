class AppDataStates{}

class AppDataInitialState extends AppDataStates{}

class AppDataLoadingState extends AppDataStates {}

class AppDataListSuccessState<T> extends AppDataStates {
  final List<T>? listModel;
  AppDataListSuccessState({this.listModel});
}
class AppDataModelSuccessState<T> extends AppDataStates {
final T? userModel;
AppDataModelSuccessState({this.userModel});
}

class AppDataErrorState extends AppDataStates {
  final String error;
  AppDataErrorState(this.error);
}

class QuizFinishedState extends AppDataStates {
  final int points;
  QuizFinishedState({required this.points});
}



