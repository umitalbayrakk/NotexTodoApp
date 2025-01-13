class TaskModel {
  final String id;
  final String title;
  final String note;
  bool isCompleted;
  final DateTime createdAt;
  final int category;
  final int priority;

  TaskModel({
    required this.id,
    required this.title,
    required this.note,
    this.isCompleted = false,
    required this.createdAt,
    required this.category,
    required this.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? DateTime.now().toString(),
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'] ?? 0,
      priority: json['priority'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toString(),
      'category': category,
      'priority': priority,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? note,
    bool? isCompleted,
    DateTime? createdAt,
    int? category,
    int? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }
}
