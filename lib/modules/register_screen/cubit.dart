import 'package:cash_money/modles/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/cubit/state.dart';

class RegisterCubit extends Cubit<AppDataStates> {
  RegisterCubit() : super(AppDataInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  Future userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String location,
  }) async {
    emit(AppDataLoadingState());

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      storeDate(
        name: name,
        phone: phone,
        uId: value.user!.uid,
        location: location,
      );
    }).catchError((error) {
      emit(AppDataErrorState(error.toString()));
    });
  }

  Future storeDate({
    required String name,
    required String uId,
    required String phone,
    required String location,
  }) async{
    UserModel userModel = UserModel(
        name: name,
        uId: uId,
        phone: phone,
        location: location,
        isEmailVerified: false,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users').doc(uId).set(userModel.toMap()).then((value) {
      emit(AppDataModelSuccessState());
    })
        .catchError((error) {
      emit(AppDataErrorState(error.toString()));
    });
  }
}

