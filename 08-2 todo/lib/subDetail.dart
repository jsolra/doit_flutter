import 'package:flutter/material.dart';

class SubDetail extends StatefulWidget {
  // SubDetail({Key? key}) : super(key: key);

  @override
  _SubDetailState createState() => _SubDetailState();
}

class _SubDetailState extends State<SubDetail> {
  List<String> todoList = new List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoList.add('당근 사오기');
    todoList.add('공부하기');
    todoList.add('약 사오기');
    todoList.add('청소하기');
    todoList.add('밥하기');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Detail Example'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              child: Text(
                todoList[index],
                style: TextStyle(fontSize: 30),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/third', arguments: todoList[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNavigation(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNavigation(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed('/second');
    //할일 추가 창에서 아무것도 추가하지 않은 경우 오류 발생하여 오류 수정
    /*
     A non-null String must be provided to a Text widget.
     'package:flutter/src/widgets/text.dart':
     Failed assertion: line 378 pos 10: 'data != null'

    */
    if (result != null) {
      setState(() {
        todoList.add(result as String);
      });
    }
  }
}
