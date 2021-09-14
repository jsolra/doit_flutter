import 'package:flutter/material.dart';

class SecondDetail extends StatefulWidget {
  // SecondDetail({Key? key}) : super(key: key);

  @override
  _SecondDetailState createState() => _SecondDetailState();
}

class _SecondDetailState extends State<SecondDetail> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
              ),
              ElevatedButton(
                child: Text('저장하기'),
                onPressed: () {
                  Navigator.of(context).pop(controller.value.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
