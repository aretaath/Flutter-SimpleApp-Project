import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'todo_item.dart';
import 'task_tile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoItemAdapter());
  await Hive.openBox<TodoItem>('myBox');

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  final Box<TodoItem> _myBox = Hive.box<TodoItem>('myBox');

  List<String> categories = ["Today", "Tomorrow", "Next Week", "Next Month"];
  int selectedCategory = 0;

  List<TodoItem> get filteredTasks {
    return _myBox.values
        .where((task) => task.category == categories[selectedCategory])
        .toList();
  }

  void _toggleTask(TodoItem task) {
    setState(() {
      task.completed = !task.completed;
      task.save();
    });
  }

  void _editTask(TodoItem task) {
    TextEditingController controller = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Task"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Enter Task Name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    task.title = controller.text;
                    task.save();
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _deleteTask(TodoItem task) {
    setState(() {
      task.delete();
    });
  }

  void _addTask() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add Task"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Enter Task Name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    final newTask = TodoItem(
                      title: controller.text,
                      completed: false,
                      category: categories[selectedCategory],
                    );
                    setState(() {
                      _myBox.add(newTask);
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: _myBox.listenable(),
        builder: (context, box, _) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue.shade300],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Task Manager",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Manage your tasks easily",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 41, 60),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(categories.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ChoiceChip(
                              label: Text(categories[index]),
                              selected: selectedCategory == index,
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedCategory = index;
                                });
                              },
                              selectedColor: const Color.fromARGB(
                                255,
                                64,
                                141,
                                205,
                              ),
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    selectedCategory == index
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return TaskTile(
                      task: task,
                      onToggle: () => _toggleTask(task),
                      onEdit: () => _editTask(task),
                      onDelete: () => _deleteTask(task),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Add a New Task",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
