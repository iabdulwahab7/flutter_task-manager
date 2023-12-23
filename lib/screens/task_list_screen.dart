// lib/screens/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          Task task = taskProvider.tasks[index];
          return Slidable(
            actionPane: const SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: [
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => taskProvider.deleteTask(index),
              ),
            ],
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: Checkbox(
                value: task.isCompleted,
                onChanged: (value) => taskProvider.toggleTaskCompletion(index),
              ),
              onTap: () => _editTask(context, index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(
                    Task(title: titleController.text),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editTask(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController(
            text: Provider.of<TaskProvider>(context).tasks[index].title);

        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .editTask(index, Task(title: titleController.text));
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
