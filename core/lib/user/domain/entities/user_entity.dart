import 'package:todo_do_app/app/modules/home/domain/entities/task_entity.dart';

class UserEntity {
  UserEntity({
    this.id = '',
    this.name = '',
    this.email = '',
    List<TaskEntity>? tasks,
  }) : tasks = tasks ?? [];

  final String id;
  final String name;
  final String email;

  final List<TaskEntity> tasks;

  UserEntity copyWith({String? name, String? token, String? refreshToken, List<TaskEntity>? tasks}) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      email: email,
      tasks: tasks ?? this.tasks,
    );
  }

  factory UserEntity.empty() => UserEntity();
}
