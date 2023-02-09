// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String userName;

  const User({
    required this.name,
    required this.id,
    required this.userName,
  });

  User copyWith({
    String? name,
    String? id,
    String? userName,
  }) {
    return User(
      name: name ?? this.name,
      id: id ?? this.id,
      userName: userName ?? this.userName,
    );
  }

  String toJson() => json.encode(<String, dynamic>{
        'name': name,
        'id': id,
        'user_name': userName,
      });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] as String,
        id: json['id'] as String,
        userName: json['user_name'] as String,
      );

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, userName];
}
