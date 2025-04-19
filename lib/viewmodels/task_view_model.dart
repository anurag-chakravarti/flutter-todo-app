import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  TaskViewModel() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedTasks = prefs.getString('tasks');
    if (storedTasks != null) {
      _tasks = (json.decode(storedTasks) as List)
          .map((task) => TaskModel.fromJson(task))
          .toList();
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    _tasks.add(TaskModel(title: title));
    await _saveTasks();
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(int index) async {
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    await _saveTasks();
    notifyListeners();
  }

  Future<void> removeTask(int index) async {
    _tasks.removeAt(index);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', json.encode(_tasks.map((task) => task.toJson()).toList()));
  }
}


