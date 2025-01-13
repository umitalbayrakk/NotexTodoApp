import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/task_model.dart';
import '../../models/task.dart';
import 'task_detail_dialog.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final Function(TaskModel) onStatusChanged;
  final Function(TaskModel) onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = TaskCategory.values[task.category];
    final priority = TaskPriority.values[task.priority];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => TaskDetailDialog(
          task: task,
          onStatusChanged: onStatusChanged,
          onDelete: onDelete,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(isDark ? 0.2 : 0.1),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: category.color.withOpacity(isDark ? 0.3 : 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: category.color.withOpacity(isDark ? 0.2 : 0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    color: category.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: category.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: [
                        Colors.green.shade400,
                        Colors.orange.shade400,
                        Colors.red.shade400
                      ][priority.index]
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag,
                          color: [
                            Colors.green.shade400,
                            Colors.orange.shade400,
                            Colors.red.shade400
                          ][priority.index],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ['Düşük', 'Orta', 'Yüksek'][priority.index],
                          style: TextStyle(
                            color: [
                              Colors.green.shade400,
                              Colors.orange.shade400,
                              Colors.red.shade400
                            ][priority.index],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) => onStatusChanged(task),
              ),
              title: Text(
                task.title,
                style: GoogleFonts.inter(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted
                      ? Colors.grey
                      : isDark
                          ? Colors.grey[200]
                          : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.note.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Oluşturulma: ${task.createdAt.toString().substring(0, 16)}',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
