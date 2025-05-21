import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/global/constants.dart';
import 'package:to_do/pages/different_page.dart';
import 'package:to_do/pages/task_detail.dart';
import 'package:to_do/providers/task_provider.dart';
import 'widgets/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => TaskProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To Do',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: "Josefin_Sans",
        ),
        home: const MyHomePage(title: 'Tasks'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasksMap = taskProvider.tasks;
    // print(tasksMap);
    final taskList = tasksMap.values.toList();
    // print(taskList);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DifferentPage(),
                  ), // Replace DifferentPage with your actual page widget
                );
                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: successColor,
                      content: Text(
                        "Task Added",
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:
            taskList.isEmpty
                ? Center(child: Text("No Tasks yet"))
                : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      final task =
                          taskList[index]
                              as Map<
                                Object?,
                                Object?
                              >?; // First, handle potential null list elements
                      final taskName = (task?['name'] as String?) ?? 'No Name';
                      final taskDescription =
                          (task?['description'] as String?) ?? 'No Description';
                      final taskId = tasksMap.keys.elementAt(index);
                      return Column(
                        children: [
                          InkWell(
                            child: Task(
                              title: taskName == "" ? "No name" : taskName,
                            ),
                            onTap: () async {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TaskDetail(
                                        name: taskName,
                                        description: taskDescription,
                                        id: taskId,
                                      ),
                                ),
                              );
                              if (result == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: successColor,
                                    content: Text(
                                      "Task Deleted",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
