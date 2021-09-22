import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';

class ClearListApp extends StatefulWidget {
  // ClearListApp({Key? key}) : super(key: key);

  Future<Database> database;
  ClearListApp(this.database);

  @override
  _ClearListAppState createState() => _ClearListAppState();
}

class _ClearListAppState extends State<ClearListApp> {
  Future<List<Todo>>? clearList;

  @override
  void initState() {
    super.initState();
    clearList = getClearList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('완료한 일'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
              future: clearList,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return CircularProgressIndicator();
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.active:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: (snapshot.data as List<Todo>).length,
                        itemBuilder: (BuildContext context, int index) {
                          Todo todo = (snapshot.data as List<Todo>)[index];
                          return ListTile(
                            title: Text(
                              todo.title!,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Container(
                              child: Column(
                                children: <Widget>[
                                  Text(todo.content!),
                                  Container(
                                    height: 1,
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Text('No data');
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('완료한 일 삭제'),
                  content: Text('완료한 일을 모두 삭제할까요?'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('예')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('아니요')),
                  ],
                );
              });
          if (result == true) {
            _removeAllTodos();
          }
        },
        child: Icon(Icons.remove),
      ),
    );
  }

  void _removeAllTodos() async {
    final Database database = await widget.database;
    database.rawDelete('delete from todos where active=1');
    setState(() {
      clearList = getClearList();
    });
  }

  Future<List<Todo>> getClearList() async {
    final Database database = await widget.database;
    List<Map<String, dynamic>> maps = await database
        .rawQuery('select title, content, id from todos where active=1');

    return List.generate(maps.length, (i) {
      return Todo(
        title: maps[i]['title'].toString(),
        content: maps[i]['content'].toString(),
        id: maps[i]['id'],
      );
    });
  }
}
