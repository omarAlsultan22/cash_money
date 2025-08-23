enum Screens {home, start, questions, update}

abstract class AppDataStates<T>{
  final T? userModel;
  final String? error;
  final int? points;
  final Screens? key;
  AppDataStates({this.userModel, this.error, this.points, this.key});
}

class AppDataInitialState<T> extends AppDataStates<T>{
  AppDataInitialState() : super();
}
class AppDataLoadingState<T> extends AppDataStates<T> {
  AppDataLoadingState({super.key});
}
class AppDataSuccessState<T> extends AppDataStates<T> {
  AppDataSuccessState({super.userModel, super.key});
}
class AppDataErrorState<T> extends AppDataStates<T> {
  AppDataErrorState({super.error, super.key});
}

class QuizFinishedState<T> extends AppDataStates<T> {
  QuizFinishedState({super.points});
}



