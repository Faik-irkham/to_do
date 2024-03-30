import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/models/todo_model.dart';

class ToDoService {
  CollectionReference toDo = FirebaseFirestore.instance.collection('todo');
  Stream<List<TodoModel>> listTodo() {
    return toDo
        .orderBy('Timestamp', descending: true)
        .snapshots()
        .map(todoFromData);
  }

  Future createTodo(String title) async {
    return await toDo.add({
      'title': title,
      'isCompleted': false,
      'Timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future updateTodo(uid, bool newComplete) async {
    await toDo.doc(uid).update({'isCompleted': newComplete});
  }

  Future deleteTodo(uid) async {
    await toDo.doc(uid).delete();
  }

  List<TodoModel> todoFromData(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      Map<String, dynamic>? data = e.data() as Map<String, dynamic>?;
      return TodoModel(
        uid: e.id,
        title: data?['title'] ?? '',
        isCompleted: data?['isCompleted'] ?? true,
      );
    }).toList();
  }
}
