

class UserModel {
  final String? userName;

  UserModel({
    this.userName,
  });

  bool get isNotEmpty => userName!.isNotEmpty;

  factory UserModel.fromDocumentSnapshot(Map<String, dynamic> data) {
    return UserModel(
      userName: data['name'].toString(),
    );
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : userName = json['name']?.toString() ?? '';


  Map<String, dynamic> toJson() {
    return {
      'name': userName,
    };
  }
}





