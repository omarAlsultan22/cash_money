import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  final String userName;
  final String userPhone;
  final String userLocation;
  final bool isEmailVerified;

  UserModel({
    required this.userName,
    required this.userPhone,
    required this.userLocation,
    required this.isEmailVerified,
  });

  UserModel copyWith({
    String? userName,
    String? userPhone,
    String? userLocation,
    bool? isEmailVerified,
}) {
    return UserModel(
        userName: userName ?? this.userName,
        userPhone: userPhone ?? this.userPhone,
        userLocation: userLocation ?? this.userLocation,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified);
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      userName: data['name'] ?? '',
      userPhone: data['phone'] ?? '',
      userLocation: data['location'] ?? '',
      isEmailVerified: data['isEmailVerified'] ?? false,
    );
  }

  UserModel.fromJson(Map<String, dynamic> json)
       : userName = json['name'] ?? '',
        userPhone = json['phone'] ?? '',
        userLocation = json['location'] ?? '',
        isEmailVerified = json['isEmailVerified'] ?? false;


  Map<String, dynamic> toJson() {
    return {
      'name': userName,
      'phone': userPhone,
      'location': userLocation,
      'isEmailVerified': isEmailVerified,
    };
  }
}





