import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/dtos/create_task_dto.dart';
import '../../domain/dtos/delete_task_dto.dart';
import '../../domain/dtos/edit_task_dto.dart';
import '../../domain/entities/task_entity.dart';
import '../../infra/datasources/i_task_remote_datasource.dart';
import '../mappers/create_task_mapper.dart';

import '../mappers/edit_task_mapper.dart';
import '../mappers/task_entity_mapper.dart';

class TaskRemoteDatasourceImpl implements ITaskRemoteDatasource {
  const TaskRemoteDatasourceImpl();

  @override
  Future<TaskEntity> createTask(CreateTaskDTO params) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('tasks')
          .doc(params.id.toString())
          .set(CreateTaskMapper.toJson(params));

      return TaskEntityMapper.fromMap({
        'id': params.id,
        'name': params.name,
        'done': params.done,
        'createAt': params.createAt.toIso8601String(),
        'updateAt': params.updateAt.toIso8601String(),
        'deadlineAt': params.deadlineAt.toIso8601String(),
      });
    } on IAppException {
      rethrow;
    } catch (e, s) {
      throw DatasourceException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<List<TaskEntity>> getListTasks() async {
    try {
      final task = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('tasks')
          .get();

      final list = task.docs;

      return list.map((e) => TaskEntityMapper.fromMap(e.data())).toList();
    } on IAppException {
      rethrow;
    } catch (e, s) {
      throw DatasourceException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<TaskEntity> editTask(EditTaskDTO params) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('tasks')
          .doc(params.id.toString())
          .update(
            EditTaskMapper.toMap(params),
          );
      final task = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('tasks')
          .doc(params.id.toString()).get();

      return TaskEntityMapper.fromMap(task.data()!);
    } on IAppException {
      rethrow;
    } catch (e, s) {
      throw DatasourceException(message: e.toString(), stackTrace: s);
    }
  }

  @override
  Future<void> deleteTask(DeleteTaskDTO params) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('tasks')
          .doc(params.id.toString())
          .delete();
    } on IAppException {
      rethrow;
    } catch (e, s) {
      throw DatasourceException(message: e.toString(), stackTrace: s);
    }
  }
}
