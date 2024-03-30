import 'package:flutter/material.dart';
import 'package:to_do/models/todo_model.dart';
import 'package:to_do/services/todo_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My To Do',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<TodoModel>>(
          stream: ToDoService().listTodo(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator(
                color: Colors.black,
              );
            }
            List<TodoModel>? todo = snapshot.data;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: todo!.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(todo[index].uid),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) async {
                    await ToDoService().deleteTodo(todo[index].uid);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: todo[index].isCompleted,
                          onChanged: (value) async {
                            await ToDoService()
                                .updateTodo(todo[index].uid, value!);
                          },
                        ),
                        Text(
                          '${todo[index].title.substring(0, 1).toUpperCase()}${todo[index].title.substring(1)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            // return ListView(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   children: [

            //   ],
            // );
          }),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController todoController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add To Do'),
          content: TextField(
            controller: todoController,
            decoration: const InputDecoration(hintText: 'Enter your to do'),
            autofocus: true,
            onSubmitted: (value) {},
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (todoController.text.isNotEmpty) {
                  await ToDoService().createTodo(todoController.text.trim());
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                todoController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
