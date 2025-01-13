import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/task_model.dart';
import '../../models/task.dart';

class TaskDetailDialog extends StatelessWidget {
  final TaskModel task;
  final Function(TaskModel) onStatusChanged;
  final Function(TaskModel) onDelete;

  const TaskDetailDialog({
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  category.icon,
                  color: category.color,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  category.name,
                  style: TextStyle(
                    color: category.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ['Düşük', 'Orta', 'Yüksek'][priority.index],
                        style: TextStyle(
                          color: [
                            Colors.green.shade400,
                            Colors.orange.shade400,
                            Colors.red.shade400
                          ][priority.index],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? Colors.grey
                              : isDark
                                  ? Colors.grey[200]
                                  : Colors.black87,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        onStatusChanged(task);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                if (task.note.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Not',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.note,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'Oluşturulma Tarihi',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.createdAt.toString().substring(0, 16),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Kapat',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onDelete(task);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Görevi Sil'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
