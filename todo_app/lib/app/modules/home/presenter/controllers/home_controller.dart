// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:core/translate/app_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:dependency_module/dependency_module.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tads_design_system/tads_design_system.dart';
import 'package:todo_do_app/app/modules/home/domain/dtos/create_task_dto.dart';
import 'package:todo_do_app/app/modules/home/domain/dtos/delete_task_dto.dart';
import 'package:todo_do_app/app/modules/home/domain/dtos/edit_task_dto.dart';
import 'package:todo_do_app/app/modules/home/domain/dtos/get_all_tasks_dto.dart';
import 'package:todo_do_app/app/modules/home/domain/entities/task_entity.dart';
import 'package:todo_do_app/app/modules/home/domain/usecases/create_task_usecase.dart';
import 'package:todo_do_app/app/modules/home/domain/usecases/delete_task_usecase.dart';
import 'package:todo_do_app/app/modules/home/domain/usecases/edit_task_usecase.dart';
import 'package:todo_do_app/app/modules/home/domain/usecases/get_list_tasks_usecase.dart';
import 'package:todo_do_app/app/modules/home/external/mappers/task_database_mapper.dart';
import 'package:todo_do_app/app/modules/home/external/mappers/task_entity_mapper.dart';
import 'package:todo_do_app/app/modules/home/infra/datasources/i_task_local_datasource.dart';
import 'package:todo_do_app/app/modules/home/presenter/stores/states/task_state.dart';
import 'package:todo_do_app/app/modules/home/presenter/stores/task_store.dart';

class HomeController {
  HomeController(
    this._connectionService,
    this._overlayService,
    this.authStore,
    this.taskStore,
    this._localStorageService,
    this._createTaskUsecase,
    this._editTaskUsecase,
    this._deleteTaskUsecase,
    this._getListTasksUsecase,
    this._localNotificationService,
    this._taskLocalDatasource,
  );

  final IConnectionService _connectionService;
  final IOverlayService _overlayService;
  final AuthStore authStore;
  final TaskStore taskStore;
  final ILocalStorageService _localStorageService;
  final ICreateTaskUsecase _createTaskUsecase;
  final IEditTaskUsecase _editTaskUsecase;
  final IDeleteTaskUsecase _deleteTaskUsecase;
  final IGetListTasksUsecase _getListTasksUsecase;
  final ILocalNotificationService _localNotificationService;
  final ITaskLocalDatasource _taskLocalDatasource;
  final _debouncer = Debouncer(milliseconds: 500);

  void gotoEditTask(TaskEntity task) =>
      Modular.to.pushNamed(AppRoutes.toEditTask, arguments: task);

  Future<void> updateCompletedList(TaskEntity task) async {
    _debouncer.run(() async {
      _updateCompletedListAsync(task);
    });
  }

  Future<void> _updateCompletedListAsync(TaskEntity task) async {
    if (!kIsWeb) {
      _localNotificationService.deleteNotification(task.id);
    }
    final result = await _editTaskUsecase(
      EditTaskDTO(
        deadlineAt: task.deadlineAt,
        updateAt: DateTime.now(),
        done: true,
        id: task.id,
        name: task.name,
      ),
    );
    if (result.isLeft()) {
      result.fold((l) => _overlayService.showErrorSnackBar(l.message), id);
    }
  }

  void updateTasksList(TaskEntity task, AppLocalizations localizations) {
    if (CustomTime.isAfter(DateTime.now(), task.deadlineAt)) {
      _debouncer.run(() {
        _updateTaskListAsync(task, localizations);
      });
    } else {
      _overlayService.showErrorSnackBar(
        localizations.errorStatusChange,
      );
    }
  }

  void deleteCompletedTaskItem(TaskEntity task) {
    _deleteCompletedTaskItemAsync(task);
  }

  Future<void> _deleteCompletedTaskItemAsync(TaskEntity task) async {
    if (!kIsWeb) {
      _localNotificationService.deleteNotification(task.id);
    }
    final result = await _deleteTaskUsecase(
      DeleteTaskDTO(
        id: task.id,
      ),
    );
    if (result.isLeft()) {
      result.fold((l) => _overlayService.showErrorSnackBar(l.message), id);
    }
  }

  void deleteAnTaskItem(TaskEntity task) {
    _deleteAnTaskItemAsync(task);
  }

  Future<void> _deleteAnTaskItemAsync(TaskEntity task) async {
    if (!kIsWeb) {
      _localNotificationService.deleteNotification(task.id);
    }
    final result = await _deleteTaskUsecase(DeleteTaskDTO(id: task.id));
    if (result.isLeft()) {
      result.fold((l) => _overlayService.showErrorSnackBar(l.message), id);
    }
  }

  Future<void> getList(
      {String? searchText, required AppLocalizations localizations}) async {
    await syncTask(localizations);
    taskStore.setLoadingValue(true);
    final result =
        await _getListTasksUsecase(GetAllTasksDTO(searchText: searchText));

    result.fold(
      (l) => _overlayService.showErrorSnackBar(l.message),
      (r) => taskStore.setList(_organizeList(r, localizations)),
    );
  }

  Future<void> setList(List<QueryDocumentSnapshot<Object?>> list,
      AppLocalizations localizations) async {
    List<TaskEntity> listTasks = [];
    list
        .map((DocumentSnapshot e) => listTasks
            .add(TaskEntityMapper.fromMap(e.data() as Map<String, dynamic>)))
        .toList();
    await syncTask(localizations);
    final listFinal = await _taskLocalDatasource.getListTasks(list: listTasks);
    taskStore.setLoadingValue(true);
    taskStore.setList(_organizeList(listFinal, localizations));
  }

  TaskState _organizeList(
      List<TaskEntity> list, AppLocalizations localizations) {
    List<TaskEntity> completedTask = [];
    list.map((e) {
      e.done == true ? completedTask.add(e) : null;
    }).toList();
    list.removeWhere((element) => element.done == true);
    if (!kIsWeb) {
      list.map((e) {
        if (CustomTime.isAfter(DateTime.now(), e.deadlineAt)) {
          _localNotificationService.replaceANotification(
            ShowLocalNotificationDTO(
              id: e.id,
              title: '${localizations.notificationTitle} ${e.name}',
              endDate: e.deadlineAt,
              body: localizations.notificationBody,
              secondBody: localizations.notificationSecondBody,
            ),
          );
        }
      }).toList();
    }

    return TaskState(list, completedTask, isSyncing: false);
  }

  Future<void> syncTask(AppLocalizations localizations) async {
    final taskJson = await _localStorageService
        .getString(const LocalDatabaseGetStringDTO(key: 'tasks'));

    List createTask = [];
    List deleteTask = [];
    List editTask = [];

    if (_connectionService.isOnline) {
      if (taskJson != null) {
        final resultMap = jsonDecode(taskJson);
        final create = (resultMap['create'] as List)
            .map((e) => TaskEntityMapper.fromMap(e as Map<String, dynamic>))
            .toList();
        final edit = (resultMap['edit'] as List)
            .map((e) => TaskEntityMapper.fromMap(e as Map<String, dynamic>))
            .toList();
        final delete = (resultMap['delete'] as List)
            .map((e) => TaskEntityMapper.fromMap(e as Map<String, dynamic>))
            .toList();

        if (create.isNotEmpty || edit.isNotEmpty || delete.isNotEmpty) {
          taskStore.syncTasks(true);
          await Future.wait(
            create.map((e) async {
              final result = await _createTaskUsecase(
                CreateTaskDTO(
                  id: e.id,
                  createAt: e.createAt,
                  updateAt: e.updateAt,
                  done: e.done,
                  name: e.name,
                  deadlineAt: e.deadlineAt,
                  localizations: localizations,
                ),
              );
              result.fold((l) => createTask.add(TaskEntityMapper.toMap(e)), id);
            }).toList(),
          );

          await Future.wait(
            edit.map((e) async {
              final result = await _editTaskUsecase(
                EditTaskDTO(
                  id: e.id,
                  done: e.done,
                  name: e.name,
                  updateAt: e.updateAt,
                  deadlineAt: e.deadlineAt,
                ),
              );

              result.fold((l) => editTask.add(TaskEntityMapper.toMap(e)), id);
            }).toList(),
          );

          await Future.wait(
            delete.map((e) async {
              final result = await _deleteTaskUsecase(DeleteTaskDTO(id: e.id));

              result.fold((l) => deleteTask.add(TaskEntityMapper.toMap(e)), id);
            }).toList(),
          );
        }

        await _localStorageService.setString(
          LocalDatabaseSetStringDTO(
            key: 'tasks',
            value: jsonEncode(
              TaskDatabaseMapper.toMap(
                create: createTask,
                delete: deleteTask,
                edit: editTask,
              ),
            ),
          ),
        );
        taskStore.syncTasks(false);
      }
    }
  }

  Future<void> _updateTaskListAsync(
      TaskEntity task, AppLocalizations localizations) async {
    if (!kIsWeb) {
      _localNotificationService.replaceANotification(
        ShowLocalNotificationDTO(
          id: task.id,
          title: '${localizations.notificationTitle} ${task.name}',
          endDate: task.deadlineAt,
          body: localizations.notificationBody,
          secondBody: localizations.notificationSecondBody,
        ),
      );
    }
    final params = EditTaskDTO(
      deadlineAt: task.deadlineAt,
      updateAt: DateTime.now(),
      id: task.id,
      name: task.name,
    );

    final result = await _editTaskUsecase(params);

    if (result.isLeft()) {
      result.fold((l) => _overlayService.showErrorSnackBar(l.message), id);
    }
  }

  Future<void> logout(AppLocalizations localizations) async {
    if (_connectionService.isOnline) {
      await authStore.logout();
    } else if (taskStore.state.isSyncing) {
      await _overlayService.showErrorSnackBar(localizations.errorSync);
    } else {
      await _overlayService
          .showErrorSnackBar(localizations.errorLogoutWithoutInterner);
    }
  }
}
