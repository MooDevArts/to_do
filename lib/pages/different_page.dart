import 'package:flutter/material.dart';
import 'package:to_do/global/constants.dart';

class DifferentPage extends StatelessWidget {
  const DifferentPage({super.key});

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
                  minLines: 1,
                  maxLines: null,
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
