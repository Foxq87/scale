import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String bannerUrl;
  final String password;
  final String school;
  final String imageUrl;
  final Timestamp creation;
  final List topics;
  final bool isVerified;
  final bool isDeveloper;

  UserModel({
    required this.email,
    required this.password,
    required this.creation,
    required this.topics,
    required this.id,
    required this.username,
    required this.imageUrl,
    required this.isVerified,
    required this.isDeveloper,
    required this.bio,
    required this.bannerUrl,
    required this.school,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc['id'],
      username: doc['username'],
      email: doc['email'],
      password: doc['password'],
      creation: doc['creation'],
      topics: doc['topics'],
      imageUrl: doc['imageUrl'],
      isDeveloper: doc['isDeveloper'],
      isVerified: doc['isVerified'],
      bio: doc['bio'],
      bannerUrl: doc['bannerUrl'],
      school: doc['school'],
    );
  }
}
