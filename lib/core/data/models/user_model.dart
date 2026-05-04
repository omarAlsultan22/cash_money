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

  static const _name = 'name';
  static const _phone = 'phone';
  static const _location = 'location';
  static const _isEmailVerified = 'isEmailVerified';

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

  factory UserModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      userName: data[_name]?.toString() ?? '',
      userPhone: data[_phone]?.toString() ?? '',
      userLocation: data[_location]?.toString() ?? '',
      isEmailVerified: data[_isEmailVerified] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _name: userName,
      _phone: userPhone,
      _location: userLocation,
      _isEmailVerified: isEmailVerified,
    };
  }
}





