import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  final String userName;

  UserModel({
    required this.userName,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      userName: data['name']?.toString() ?? '',
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





