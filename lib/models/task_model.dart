import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime deadline;

  @HiveField(4)
  bool isCompleted;

  Task({
    String? id,
    required this.name,
    required this.category,
    required this.deadline,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();
}
