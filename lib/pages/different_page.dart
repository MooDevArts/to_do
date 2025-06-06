import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/global/constants.dart';
import 'package:to_do/providers/task_provider.dart';

class DifferentPage extends StatefulWidget {
  const DifferentPage({super.key});

  @override
  State<DifferentPage> createState() => _DifferentPageState();
}

class _DifferentPageState extends State<DifferentPage> {

  String taskName = "";
  String taskDescription = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: Column(
              spacing: 10,
              children: [
                TextField(
                  // onSubmitted: (value) {
                  //   taskName = value;
                  //   // print(taskName);
                  // },
                  onChanged: (value) {
                    taskName = value;
                  },
                  // focusNode: _firstTextFieldFocusNode,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "The Laundry",
                    label: Row(
                      spacing: spacingSmall,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bubble_chart,
                          color: Theme.of(context).primaryColor,
                          // size: 16,
                        ),
                        Text("Task"),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.0),
                    ),
                  ),
                ),
                TextField(
                  // focusNode: _secondTextFieldFocusNode,
                  // minLines: 1,
                  // maxLines: null,
                  onSubmitted: (value) {
                    taskDescription = value;
                    // print(taskDescription);
                    context.read<TaskProvider>().addTask(taskName: taskName, taskDescription: taskDescription);
                    Navigator.pop(context, true);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Take basket",
                    label: Row(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.list, color: Theme.of(context).primaryColor),
                        Text("Description"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
