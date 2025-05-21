import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/providers/task_provider.dart';
import 'package:to_do/widgets/task.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({
    super.key,
    required this.name,
    required this.description,
    required this.id,
  });

  final String name;
  final String description;
  final String? id;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Task(title: widget.name == "" ? "No Name" : widget.name),
              SizedBox(height: 8),
              Task(
                title:
                    widget.description == ""
                        ? "No description"
                        : widget.description,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.red.shade400),
        ),
        onPressed: () {
          context.read<TaskProvider>().deleteTask(taskId: widget.id);
          Navigator.pop(context, true);
        },
        child: Icon(Icons.delete_outline, color: Colors.white),
      ),
    );
  }
}
