import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modles/user_model.dart';
import '../../shared/components/constatnts.dart';
import '../../shared/cubit/state.dart';

class AppModelCubit extends Cubit<AppDataStates> {
  AppModelCubit() : super((AppDataInitialState()));

  static AppModelCubit get(context) => BlocProvider.of(context);

  Future<void> getInfo(String uId) async {
    emit(AppDataLoadingState());
    DocumentReference docRef = FirebaseFirestore.instance.collection(
        'users').doc(uId);
    try {
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        UserModel userModel = UserModel.fromJson(data);
        print('Document data: $data');
        emit(AppDataModelSuccessState<UserModel>(userModel: userModel));
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error fetching document: $error');
      emit(AppDataErrorState(error.toString()));
    }
  }

  Future updateInfo({
    required String name,
    required String uId,
    required String phone,
    required String location,
  }) async {
    emit(AppDataLoadingState());
    try {
      UserDetails.name = name;
      UserModel userModel = UserModel(
        name: name,
        uId: uId,
        phone: phone,
        location: location,
        isEmailVerified: false,
      );
      await FirebaseFirestore.instance.collection('users').doc(uId).update(
          userModel.toMap());
      emit(AppDataListSuccessState());
    }
    catch (error) {
      emit(AppDataErrorState(error.toString()));
    }
  }

  Future<void> changeEmailAndPassword({
    required String newEmail,
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(AppDataLoadingState());
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      try {
        await user.reauthenticateWithCredential(credential);
        await user.updateEmail(newEmail).then((_) {
          user.updatePassword(newPassword).then((_) {
            emit(AppDataListSuccessState());
          });
        });
      } on FirebaseAuthException catch (e) {
        emit(AppDataErrorState(e.toString()));
      }
    } else {
      emit(AppDataErrorState('No user is currently logged in'));
    }
  }
}
