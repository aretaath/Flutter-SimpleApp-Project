import 'package:hive/hive.dart';
part 'todo_item.g.dart';

@HiveType(typeId: 0)
class TodoItem extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool completed;

  @HiveField(2)
  String category;

  TodoItem({
    required this.title,
    this.completed = false,
    required this.category,
  });
}
