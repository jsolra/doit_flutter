import 'package:database/todo.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class AddTodoApp extends StatefulWidget {
  final Future<Database> db;
  AddTodoApp(this.db);
  // AddTodoApp({Key? key}) : super(key: key);

  @override
  _AddTodoAppState createState() => _AddTodoAppState();
}

class _AddTodoAppState extends State<AddTodoApp> {
  TextEditingController? titleController;
  TextEditingController? contentController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = new TextEditingController();
    contentController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo add'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'title'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: 'todo',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Todo todo = Todo(
                      title: titleController!.value.text,
                      content: contentController!.value.text,
                      active: 0);
                  Navigator.of(context).pop(todo);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
