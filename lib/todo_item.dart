class TodoItem {
  String title;
  bool completed;
  String category;

  TodoItem({
    required this.title,
    this.completed = false,
    required this.category,
  });
}
