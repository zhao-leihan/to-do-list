import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/task_model.dart';
import '../providers/todo_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = task.isCompleted;

    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF1A0B2E)], // Power Stone Purple
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C27B0).withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32)
            .animate(onPlay: (controller) => controller.repeat())
            .shake(duration: 500.ms)
            .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 500.ms),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TodoProvider>(context, listen: false).deleteTask(task.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B4E), // Lighter Purple
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted ? Colors.grey.withOpacity(0.2) : colorScheme.primary.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: isCompleted
              ? []
              : [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: GestureDetector(
            onTap: () {
              Provider.of<TodoProvider>(context, listen: false).toggleTaskStatus(task);
            },
            child: AnimatedContainer(
              duration: 300.ms,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? Colors.grey : colorScheme.primary, // Gold border
                  width: 2,
                ),
                color: isCompleted ? colorScheme.primary.withOpacity(0.2) : Colors.transparent,
              ),
              child: isCompleted
                  ? Icon(Icons.check, size: 16, color: colorScheme.primary)
                  : null,
            ),
          ),
          title: Text(
            task.name,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Colors.grey : Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: colorScheme.secondary.withOpacity(0.5)),
                    ),
                    child: Text(
                      task.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d').format(task.deadline).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
      .animate(target: isCompleted ? 1 : 0)
      .shimmer(duration: 1000.ms, color: const Color(0xFFFFD700)) // Gold shimmer
      .saturate(begin: 1, end: 0, duration: 500.ms) // Desaturate
      .fade(begin: 1, end: 0.5, duration: 500.ms), // Dim but don't hide
    );
  }
}
