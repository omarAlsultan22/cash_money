import 'package:cash_money/shared/components/constatnts.dart';
import 'package:cash_money/shared/local/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cash_money/shared/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_data_model.dart';


class AppDataCubit extends Cubit<AppDataStates> {
  AppDataCubit() : super(AppDataInitialState());

  static AppDataCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  int points = 0;


  void resetQuiz() {
    currentIndex = 0;
    points = 0;
    emit(AppDataInitialState());
  }


  List<QuestionModel> questionsData = [];
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = false;


  Future<void> getData({Screens? key}) async {
    if(isLoadingMore) return;

    emit(AppDataLoadingState());
    try {
      Query query = FirebaseFirestore.instance.collection('data')
          .doc('0Hv1zUWKuetw3eP7Nplt').collection('userData');
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }
      final value = await query.limit(10).get();
      if (value.docs.isEmpty) {
        return;
      }

      DataModel dataModel = DataModel.fromQuerySnapshot(value);
      final data = dataModel.data;
      lastDocument = value.docs.last;

      if(data.isEmpty) {
        isLoadingMore = true;
        emit(AppDataSuccessState());
        return;
      }

      questionsData.addAll(data);
      emit(AppDataSuccessState());
    }
    catch (e) {
      emit(AppDataErrorState(key: key));
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
