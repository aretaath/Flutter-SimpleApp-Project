import 'package:flutter/material.dart';
import '../todo_item.dart';

class TaskTile extends StatelessWidget {
  final TodoItem task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (value) => onToggle(),
          activeColor: Colors.green,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? Colors.grey : Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
