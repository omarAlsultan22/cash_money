import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/components/constatnts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_info_model.dart';
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
        emit(AppDataSuccessState<UserModel>(userModel: userModel));
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error fetching document: $error');
      emit(AppDataErrorState(error: error.toString()));
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
          userModel.toJson());
      emit(AppDataSuccessState(key: Screens.update));
    }
    catch (error) {
      emit(AppDataErrorState(error: error.toString(), key: Screens.update));
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
        await user.verifyBeforeUpdateEmail(newEmail).then((_) {
          user.updatePassword(newPassword).then((_) {
            emit(AppDataSuccessState());
          });
        });
      } on FirebaseAuthException catch (e) {
        emit(AppDataErrorState(error: e.toString()));
      }
    } else {
      emit(AppDataErrorState(error: 'No user is currently logged in'));
    }
  }
}
