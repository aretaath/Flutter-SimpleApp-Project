import 'package:flutter/material.dart';
import 'todo_item.dart';
import 'task_tile.dart';

void main() {
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
  List<String> categories = ["Today", "Tomorrow", "Next Week", "Next Month"];
  int selectedCategory = 0;

  List<TodoItem> tasks = [
    TodoItem(title: "Upload a Video", completed: false, category: "Today"),
    TodoItem(title: "Go to the Gym", completed: false, category: "Tomorrow"),
    TodoItem(title: "Go to Office", completed: true, category: "Next Week"),
    TodoItem(title: "Complete a Task", completed: true, category: "Next Month"),
    TodoItem(title: "Go to the Market", completed: false, category: "Today"),
  ];

  List<TodoItem> get filteredTasks {
    return tasks
        .where((task) => task.category == categories[selectedCategory])
        .toList();
  }

  void _toggleTask(int index) {
    int originalIndex = tasks.indexOf(filteredTasks[index]);
    setState(() {
      tasks[originalIndex].completed = !tasks[originalIndex].completed;
    });
  }

  void _editTask(int index) {
    int originalIndex = tasks.indexOf(filteredTasks[index]);
    TextEditingController controller = TextEditingController(
      text: tasks[originalIndex].title,
    );
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
                    tasks[originalIndex].title = controller.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _deleteTask(int index) {
    int originalIndex = tasks.indexOf(filteredTasks[index]);
    setState(() {
      tasks.removeAt(originalIndex);
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
                    setState(() {
                      tasks.add(
                        TodoItem(
                          title: controller.text,
                          completed: false,
                          category: categories[selectedCategory],
                        ),
                      );
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
      body: Column(
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
                return TaskTile(
                  task: filteredTasks[index],
                  onToggle: () => _toggleTask(index),
                  onEdit: () => _editTask(index),
                  onDelete: () => _deleteTask(index),
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
      ),
    );
  }
}
