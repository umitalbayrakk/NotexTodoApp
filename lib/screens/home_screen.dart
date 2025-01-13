import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> todos = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = true;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  TaskCategory _selectedCategory = TaskCategory.personal;
  TaskPriority _selectedPriority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    loadTodos();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _completedTodos =>
      todos.where((todo) => todo['isCompleted'] == true).toList();

  List<Map<String, dynamic>> get _pendingTodos =>
      todos.where((todo) => todo['isCompleted'] == false).toList();

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    setState(() {
      if (todosString != null) {
        todos = List<Map<String, dynamic>>.from(
          json.decode(todosString).map((x) => Map<String, dynamic>.from(x)),
        );
      }
      _isLoading = false;
    });
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todos', json.encode(todos));
  }

  void _addTodo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Yeni Görev',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Kategori',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: TaskCategory.values.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category.icon,
                              size: 18,
                              color: _selectedCategory == category
                                  ? Colors.white
                                  : category.color,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.name,
                              style: TextStyle(
                                color: _selectedCategory == category
                                    ? Colors.white
                                    : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                fontWeight: _selectedCategory == category
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        selected: _selectedCategory == category,
                        selectedColor: category.color,
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.grey[100],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        elevation: _selectedCategory == category ? 4 : 0,
                        pressElevation: 4,
                        shadowColor: category.color.withOpacity(0.4),
                        side: BorderSide(
                          color: _selectedCategory == category
                              ? category.color
                              : category.color.withOpacity(0.3),
                          width: 1.5,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = category);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Öncelik',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: TaskPriority.values.map((priority) {
                    final index = priority.index;
                    final colors = [
                      Colors.green.shade400,
                      Colors.orange.shade400,
                      Colors.red.shade400
                    ];
                    final labels = ['Düşük', 'Orta', 'Yüksek'];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flag,
                              size: 18,
                              color: _selectedPriority == priority
                                  ? Colors.white
                                  : colors[index],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              labels[index],
                              style: TextStyle(
                                color: _selectedPriority == priority
                                    ? Colors.white
                                    : Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black87,
                                fontWeight: _selectedPriority == priority
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        selected: _selectedPriority == priority,
                        selectedColor: colors[index],
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors.grey[100],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        elevation: _selectedPriority == priority ? 4 : 0,
                        pressElevation: 4,
                        shadowColor: colors[index].withOpacity(0.4),
                        side: BorderSide(
                          color: _selectedPriority == priority
                              ? colors[index]
                              : colors[index].withOpacity(0.3),
                          width: 1.5,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedPriority = priority);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                  hintText: 'Görev başlığını girin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Not',
                  hintText: 'Görev detaylarını girin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[100],
                  prefixIcon: const Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty) {
                      setState(() {
                        todos.add({
                          'title': _titleController.text,
                          'note': _noteController.text,
                          'isCompleted': false,
                          'createdAt': DateTime.now().toString(),
                          'category': _selectedCategory.index,
                          'priority': _selectedPriority.index,
                        });
                        saveTodos();
                      });
                      _titleController.clear();
                      _noteController.clear();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCategory.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Görevi Ekle',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () => setState(() => _isSearching = !_isSearching),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Görev ara...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.red,
                ),
                onChanged: (value) => setState(() {}),
              )
            : const Text('Notrix'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.toggleTheme,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Tümünü Temizle'),
                onTap: () {
                  setState(() {
                    todos.clear();
                    saveTodos();
                  });
                },
              ),
              PopupMenuItem(
                child: const Text('Tamamlananları Temizle'),
                onTap: () {
                  setState(() {
                    todos.removeWhere((todo) => todo['isCompleted']);
                    saveTodos();
                  });
                },
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tümü (${todos.length})'),
            Tab(text: 'Aktif (${_pendingTodos.length})'),
            Tab(text: 'Tamamlanan (${_completedTodos.length})'),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodoList(todos),
          _buildTodoList(_pendingTodos),
          _buildTodoList(_completedTodos),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        icon: const Icon(Icons.add),
        label: const Text('Yeni Görev'),
      ),
    );
  }

  Widget _buildTodoList(List<Map<String, dynamic>> todoList) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todoList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_outlined,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz görev eklenmemiş',
              style: GoogleFonts.inter(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Yeni bir görev eklemek için + butonuna tıklayın',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    final filteredTodos = _isSearching
        ? todoList
            .where((todo) => todo['title']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList()
        : todoList;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        final todo = filteredTodos[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    setState(() {
                      todos.remove(todo);
                      saveTodos();
                    });
                  },
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_outline,
                  label: 'Sil',
                  borderRadius: BorderRadius.circular(16),
                ),
              ],
            ),
            child: _buildTaskCard(todo),
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> todo) {
    final category = TaskCategory.values[todo['category'] ?? 0];
    final priority = TaskPriority.values[todo['priority'] ?? 1];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showTaskDetails(todo, category, priority),
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
                value: todo['isCompleted'],
                onChanged: (value) {
                  setState(() {
                    todo['isCompleted'] = value;
                    saveTodos();
                  });
                },
              ),
              title: Text(
                todo['title'],
                style: GoogleFonts.inter(
                  decoration:
                      todo['isCompleted'] ? TextDecoration.lineThrough : null,
                  color: todo['isCompleted']
                      ? Colors.grey
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[200]
                          : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todo['note'].isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo['note'],
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
                    'Oluşturulma: ${DateTime.parse(todo['createdAt']).toString().substring(0, 16)}',
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

  void _showTaskDetails(
      Map<String, dynamic> todo, TaskCategory category, TaskPriority priority) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                          todo['title'],
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            decoration: todo['isCompleted']
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo['isCompleted']
                                ? Colors.grey
                                : Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[200]
                                    : Colors.black87,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: todo['isCompleted'],
                        onChanged: (value) {
                          setState(() {
                            todo['isCompleted'] = value;
                            saveTodos();
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  if (todo['note'].isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Not',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[300]
                            : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      todo['note'],
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[300]
                            : Colors.grey[700],
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateTime.parse(todo['createdAt'])
                        .toString()
                        .substring(0, 16),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        todos.remove(todo);
                        saveTodos();
                      });
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
      ),
    );
  }
}
