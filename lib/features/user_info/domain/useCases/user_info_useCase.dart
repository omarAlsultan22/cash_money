import '../repositories/user_info_repository.dart';
import '../../../../core/data/models/user_model.dart';


class UserInfoUseCase {
  final UserInfoRepository _repository;

  UserInfoUseCase({
    required UserInfoRepository userInfoRepository,
  })
      :_repository = userInfoRepository;

  Future<UserModel> getInfoExecute() async {
    return await _repository.getInfo();
  }


  Future<void> updateInfoExecute({
    required String userName,
    required String userPhone,
    required String userLocation
  }) async {
    return await _repository.updateInfo(
        userName: userName,
        userPhone: userPhone,
        userLocation: userLocation

    );
  }
}

