import 'package:flutter/material.dart';

enum TaskPriority {
  low,
  medium,
  high,
}

enum TaskCategory {
  personal,
  work,
  shopping,
  health,
  meeting,
  other,
}

extension TaskCategoryExtension on TaskCategory {
  String get name {
    switch (this) {
      case TaskCategory.personal:
        return 'Kişisel';
      case TaskCategory.work:
        return 'İş';
      case TaskCategory.shopping:
        return 'Alışveriş';
      case TaskCategory.health:
        return 'Sağlık';
      case TaskCategory.meeting:
        return 'Toplantı';
      case TaskCategory.other:
        return 'Diğer';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.personal:
        return Icons.person_outline;
      case TaskCategory.work:
        return Icons.work_outline;
      case TaskCategory.shopping:
        return Icons.shopping_bag_outlined;
      case TaskCategory.health:
        return Icons.favorite_outline;
      case TaskCategory.meeting:
        return Icons.groups_outlined;
      case TaskCategory.other:
        return Icons.category_outlined;
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.personal:
        return const Color(0xFF6366F1); // Indigo
      case TaskCategory.work:
        return const Color(0xFF0EA5E9); // Sky
      case TaskCategory.shopping:
        return const Color(0xFFF59E0B); // Amber
      case TaskCategory.health:
        return const Color(0xFFF43F5E); // Rose
      case TaskCategory.meeting:
        return const Color(0xFF10B981); // Emerald
      case TaskCategory.other:
        return const Color(0xFF8B5CF6); // Violet
    }
  }
}
