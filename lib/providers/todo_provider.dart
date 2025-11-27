import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/hive_service.dart';

class TodoProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  List<Task> _tasks = [];
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  String get selectedCategory => _selectedCategory;
  String get selectedStatus => _selectedStatus;

  List<Task> get tasks {
    return _tasks.where((task) {
      final categoryMatch = _selectedCategory == 'All' || task.category == _selectedCategory;
      final statusMatch = _selectedStatus == 'All' ||
          (_selectedStatus == 'Completed' && task.isCompleted) ||
          (_selectedStatus == 'Pending' && !task.isCompleted);
      return categoryMatch && statusMatch;
    }).toList();
  }

  Future<void> init() async {
    await _hiveService.init();
    _tasks = _hiveService.getTasks();
    notifyListeners();
  }

  Future<void> addTask(String name, String category, DateTime deadline) async {
    final newTask = Task(
      name: name,
      category: category,
      deadline: deadline,
    );
    await _hiveService.addTask(newTask);
    _tasks = _hiveService.getTasks();
    notifyListeners();
  }

  Future<void> toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await _hiveService.updateTask(task);
    _tasks = _hiveService.getTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _hiveService.deleteTask(id);
    _tasks = _hiveService.getTasks();
    notifyListeners();
  }

  Future<void> reloadTasks() async {
    _tasks = _hiveService.getTasks();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void filterByStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }
}
