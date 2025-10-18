import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String phone;
  final String location;
  final String uId;
  final bool isEmailVerified;

  UserModel({
    required this.uId,
    required this.name,
    required this.phone,
    required this.location,
    required this.isEmailVerified,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      uId: document.id,
      name: data['name'] ?? 'Unknown',
      phone: data['phone'] ?? 'Unknown',
      location: data['location'] ?? 'Unknown',
      isEmailVerified: data['isEmailVerified'] ?? false,
    );
  }

  UserModel.fromJson(Map<String, dynamic> json)
       : name = json['name'] ?? 'Unknown',
        phone = json['phone'] ?? 'Unknown',
        location = json['location'] ?? 'Unknown',
        uId = json['uId'] ?? '',
        isEmailVerified = json['isEmailVerified'] ?? false;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'location': location,
      'uId': uId,
      'isEmailVerified': isEmailVerified,
    };
  }
}





