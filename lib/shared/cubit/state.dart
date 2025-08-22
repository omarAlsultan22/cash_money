enum Screens {home, start, questions, update}

abstract class AppDataStates<T>{
  final T? userModel;
  final String? error;
  final int? points;
  final Screens? key;
  AppDataStates({this.userModel, this.error, this.points, this.key});
}

class AppDataInitialState extends AppDataStates{}
class AppDataLoadingState extends AppDataStates {
  AppDataLoadingState({super.key});
}
class AppDataSuccessState<T> extends AppDataStates {
  AppDataSuccessState({super.userModel, super.key});
}
class AppDataErrorState extends AppDataStates {
  AppDataErrorState({super.error, super.key});
}

class QuizFinishedState extends AppDataStates {
  QuizFinishedState({super.points});
}



