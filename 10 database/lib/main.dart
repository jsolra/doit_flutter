import 'package:database/addTodo.dart';
import 'package:database/clearList.dart';
import 'package:database/todo.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: AddTodoApp(database),
      initialRoute: '/',
      routes: {
        '/': (context) => DatabaseApp(database),
        '/add': (context) => AddTodoApp(database),
        '/clear': (context) => ClearListApp(database)
      },
    );
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title TEXT, content TEXT, active INTEGER)",
        );
      },
      version: 1,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // body: DatabaseApp(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

class DatabaseApp extends StatefulWidget {
  final Future<Database> db;
  DatabaseApp(this.db);
  // DatabaseApp({Key? key}) : super(key: key);

  @override
  _DatabaseAppState createState() => _DatabaseAppState();
}

class _DatabaseAppState extends State<DatabaseApp> {
  Future<List<Todo>>? todoList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Database Example'), actions: <Widget>[
        TextButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed('/clear');
            setState(() {
              todoList = getTodos();
            });
          },
          child: Text(
            '완료한 일',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
      body: Container(
        child: Center(
          //FutureBuilder: 서버 등에서 데이터를 받거나, 파일의 데이터를 가져올 때 사용
          child: FutureBuilder(
            future: todoList,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  {
                    if (snapshot.hasData) {
                      return (ListView.builder(
                        itemCount: (snapshot.data as List<Todo>).length,
                        itemBuilder: (context, index) {
                          Todo todo = (snapshot.data as List<Todo>)[index];
                          return ListTile(
                            title: Text(
                              todo.title!,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Container(
                              child: Column(
                                children: <Widget>[
                                  Text(todo.content!),
                                  Text(
                                      '체크 : ${todo.active == 1 ? 'true' : 'false'}'),
                                  Container(
                                    height: 1,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                            //내용 수정, 체크 변경
                            onTap: () async {
                              TextEditingController controller =
                                  new TextEditingController();

                              Todo result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('${todo.id} : ${todo.title}'),
                                      content: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.text,
                                      ),
                                      // content: Text('Todo를 체크하시겠습니까?'),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                todo.active == 1
                                                    ? todo.active = 0
                                                    : todo.active = 1;
                                                todo.content =
                                                    controller.value.text == ""
                                                        ? todo.content
                                                        : controller.value.text;
                                              });
                                              Navigator.of(context).pop(todo);
                                            },
                                            child: Text('예')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(todo);
                                            },
                                            child: Text('아니요')),
                                      ],
                                    );
                                  });
                              _updateTodo(result);
                            },
                            onLongPress: () async {
                              Todo result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('${todo.id} : ${todo.title}'),
                                      content:
                                          Text('${todo.content}를 삭제하시겠습니까?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(todo);
                                          },
                                          child: Text('예'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(todo);
                                          },
                                          child: Text('아니요'),
                                        ),
                                      ],
                                    );
                                  });
                              _deleteTodo(result);
                            },
                          );
                          /*
                          return Card(
                            child: Column(
                              children: <Widget>[
                                Text(todo.title!),
                                Text(todo.content!),
                                Text('${todo.active == 1 ? 'true' : 'false'}'),
                              ],
                            ),
                          );
                           */
                        },
                      ));
                    } else {
                      return Text('No data');
                    }
                  }

                  return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              final todo = await Navigator.of(context).pushNamed('/add');
              if (todo != null) {
                _insertToto(todo as Todo);
              }
            },
            child: Icon(Icons.add),
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              _allUpdate();
            },
            child: Icon(Icons.update),
            heroTag: null,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _allUpdate() async {
    final Database database = await widget.db;
    await database.rawUpdate('update todos set active=1 where active=0');
    setState(() {
      todoList = getTodos();
    });
  }

  void _updateTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    setState(() {
      todoList = getTodos();
    });
  }

  void _deleteTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.delete('todos', where: 'id=?', whereArgs: [todo.id]);
    setState(() {
      todoList = getTodos();
    });
  }

  void _insertToto(Todo todo) async {
    final Database database = await widget.db;
    await database.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    setState(() {
      todoList = getTodos();
    });
  }

  Future<List<Todo>> getTodos() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query('todos');

    return List.generate(maps.length, (i) {
      int active = maps[i]['active'] == 1 ? 1 : 0;
      return Todo(
          title: maps[i]['title'].toString(),
          content: maps[i]['content'].toString(),
          active: active,
          id: maps[i]['id']);
    });
  }
}
