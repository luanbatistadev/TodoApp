import 'package:core/core.dart';

import '../errors/datasource_errors.dart';

class LoginMapper {
  static UserEntity fromMap(Map<String, dynamic> json) {
    try {
      return UserEntity(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
      );
    } catch (e, st) {
      throw LoginMapperException(message: e.toString(), stackTrace: st);
    }
  }

  static Map<String, dynamic> toMap(UserEntity user) {
    try {
      return {
        'id': user.id,
        'name': user.name,
        'email': user.email,
      };
    } catch (e, st) {
      throw LoginMapperException(message: e.toString(), stackTrace: st);
    }
  }
}
