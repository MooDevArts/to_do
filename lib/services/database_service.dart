import 'package:firebase_database/firebase_database.dart';

class DatabaseService{
 final FirebaseDatabase instance = FirebaseDatabase.instance;

 Future<void> create({
  required String path,
  required Map<String, String> data
 }) async {
  final DatabaseReference reference = instance.ref(path);
  await reference.set(data);
 }

 Future<void> update({
  required String path,
  required Map<String, String> data
 }) async {
  final DatabaseReference ref = instance.ref(path);
  await ref.update(data);
 }

Future<void> delete({
  required String path,
  }) async {
    final DatabaseReference reference = instance.ref(path);
    await reference.remove();
  }

}