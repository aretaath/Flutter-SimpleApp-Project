# Flutter Simple Application

| Name  | Areta Athayayumna Arwaa |
|-------|-------------------------|
| NRP   | 5025221068              |

## Description  
This To-Do List application is a Flutter-based task management application that allows users to manage their task lists based on time categories. This application has CRUD (Create, Read, Update, Delete) features, where users can add new tasks, view task lists based on the selected category, mark tasks as complete or incomplete, edit task names, and delete unnecessary tasks.  

## Steps to Apply Hive Local Storage
1. Add hive dependency in `pubspec.yaml`. This addition includes some important packages to support using Hive as local database, such as `hive` (Main library), `hive_flutter` (Provides flutter specific features), `hive_generator` (Automatically generate adapter file), and `build_runner` (Generates code via annotations).

    ```
    dependencies:
      flutter:
        sdk: flutter
      hive: ^2.2.3
      hive_flutter: ^1.1.0
    
    dev_dependencies:
      flutter_test:
        sdk: flutter
      hive_generator: ^2.0.1
      build_runner: ^2.1.11
    ```

2.  Modify `todo_item.dart` to become hive model by adding annotation `@HiveType` and `@HiveField` on class and its attributes so Hive knows how to store _TodoItem_ object. To gives the object the ability to save itself, delete itself, and more, the class needs to be connected to Hive by adding extends `HiveObject`.

3. After adding annotation in `todo_item.dart`, in terminal run `build_runner` command. This command will generate `todo_item.g.dart` automatically. This file contains adapter code used to store and get object from database.

    ```
    dart run build_runner build
    ```

4. Modify `main.dart` to use Hive by initializing Hive using `await Hive.initFlutter()` and opening local database in hive `Hive.openBox`. Register generated adapter `TodoItemAdapter` and open box named `todoBox` to make sure Hive is ready to use as soon as the app starts, and the box is ready to store the to do list.

    ```
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();
      Hive.registerAdapter(TodoItemAdapter());
      await Hive.openBox<TodoItem>('myBox');
    
      runApp(const TodoApp());
    }
    ```

5. Update every part of the app that handles to do data to use Hive `Box` for storage, including the parts that do Create, Read, Update, and Delete (CRUD) in _TodoScreenState_. Change the variables, the _initState_ part, and other related parts as needed. 

    - A newly created _TodoItem_ object is directly added to the box using `.add()`
      ```
      final newTask = TodoItem(
        title: controller.text,
        completed: false,
        category: categories[selectedCategory],
      );
      setState(() {
        _myBox.add(newTask);
      });
      ``` 
  
    - With `_myBox.values` we get all the data saved in the box and filter it based on the selected category 
  
      ```
      List<TodoItem> get filteredTasks {
        return _myBox.values
            .where((task) => task.category == categories[selectedCategory])
            .toList();
      }
      ```
  
    - Updates are made directly to the Hive object and saved using `task.save()` 
  
      ```
      task.completed = !task.completed;
      task.save();
      ```
  
    - Deleting a task is done using `.delete()` directly from the _TodoItem_ object
      ```
      task.delete();
      ```


## Demo  
You can see the application demo through the following link:  
[Application Demo](https://drive.google.com/file/d/1_WKxhMiIfWg--L8wdjepKIVXQ3bmLOpd/view?usp=sharing)  
