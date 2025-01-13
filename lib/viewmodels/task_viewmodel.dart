import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/task.dart';

class TaskViewModel extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  TaskCategory _selectedCategory = TaskCategory.personal;
  TaskPriority _selectedPriority = TaskPriority.medium;
  String _searchQuery = '';

  // Getters
  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  TaskCategory get selectedCategory => _selectedCategory;
  TaskPriority get selectedPriority => _selectedPriority;
  String get searchQuery => _searchQuery;

  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<TaskModel> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  List<TaskModel> get filteredTasks {
    if (_searchQuery.isEmpty) return _tasks;
    return _tasks
        .where((task) =>
            task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  // Setters
  void setCategory(TaskCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriority(TaskPriority priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Methods
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('todos');

    if (tasksString != null) {
      final List<dynamic> decodedTasks = json.decode(tasksString);
      _tasks = decodedTasks.map((task) => TaskModel.fromJson(task)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'todos', json.encode(_tasks.map((task) => task.toJson()).toList()));
  }

  Future<void> addTask(String title, String note) async {
    final task = TaskModel(
      id: DateTime.now().toString(),
      title: title,
      note: note,
      createdAt: DateTime.now(),
      category: _selectedCategory.index,
      priority: _selectedPriority.index,
    );

    _tasks.add(task);
    await saveTasks();
    notifyListeners();
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      await saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(TaskModel task) async {
    _tasks.removeWhere((t) => t.id == task.id);
    await saveTasks();
    notifyListeners();
  }

  Future<void> clearAllTasks() async {
    _tasks.clear();
    await saveTasks();
    notifyListeners();
  }

  Future<void> clearCompletedTasks() async {
    _tasks.removeWhere((task) => task.isCompleted);
    await saveTasks();
    notifyListeners();
  }
}
