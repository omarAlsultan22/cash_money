import 'package:cash_money/shared/components/components.dart';
import 'package:cash_money/shared/components/constatnts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/cubit/state.dart';
import '../../shared/local/shared_preferences.dart';

class LoginCubit extends Cubit<AppDataStates> {
  LoginCubit() : super(AppDataInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      showToast('Please fill in all fields.');
      emit(AppDataErrorState('Fields cannot be empty.'));
      return;
    }
    emit(AppDataLoadingState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        CacheHelper.putValue(key: 'uId', value: UserDetails.uId);
      });
      showToast('Login successful!');
      emit(AppDataSuccessState());
    } on FirebaseAuthException catch (error) {
      String errorMessage = "Login failed. Please try again.";
      switch (error.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address.";
          break;
        default:
          errorMessage = error.message ?? errorMessage;
      }
      showToast(errorMessage);
      emit(AppDataErrorState(errorMessage));
    } catch (error) {
      showToast('An unexpected error occurred.');
      emit(AppDataErrorState(error.toString()));
    }
  }
}