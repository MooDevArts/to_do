import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  Map<String?, dynamic> tasks = {};

  final Query reference = FirebaseDatabase.instance
      .ref("tasks")
      .orderByChild('createdAt');
  final DatabaseReference ref = FirebaseDatabase.instance.ref("tasks");
  final DatabaseReference rootRef = FirebaseDatabase.instance.ref();
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final AudioPlayer _audioPlayer = AudioPlayer();

  TaskProvider() {
    startListening();
  }

  void startListening() {
    DatabaseReference userTaskRef = rootRef
        .child('users')
        .child(currentUserId!)
        .child('tasks');
    userTaskRef.onValue.listen((DatabaseEvent event) {
      // cast it onto tasks
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<String?, dynamic> orderedTasks = {};
        for (final childSnapshot in snapshot.children) {
          if (childSnapshot.key != "_placeholder") {
            orderedTasks[childSnapshot.key] = childSnapshot.value;
          }
        }
        tasks = orderedTasks;
        notifyListeners();
      }
    });
  }

  void addTask({
    required String? taskName,
    required String? taskDescription,
  }) async {
    if (currentUserId != null) {
      DatabaseReference userTaskRef = rootRef
          .child('users')
          .child(currentUserId!)
          .child('tasks');
      Map<String, dynamic> data = {
        'name': taskName,
        'description': taskDescription,
        'createdAt': ServerValue.timestamp,
      };
      await userTaskRef.push().set(data);
      await _audioPlayer.play(AssetSource('sounds/money-pickup-2-89563.mp3'));
    } else {
      print('User not logged in, cannot add task');
    }
  }

  void deleteTask({required String? taskId}) async {
    if (taskId != null) {
      DatabaseReference userTaskRef = rootRef
          .child('users')
          .child(currentUserId!)
          .child('tasks');
      await userTaskRef.child(taskId).remove();
      await _audioPlayer.play(AssetSource('sounds/paper-bin-toss-1-83125.mp3'));
      notifyListeners();
    }
  }
}
