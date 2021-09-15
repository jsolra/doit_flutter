import 'package:flutter/material.dart';
import 'package:sharedpreferences/largeFileMain.dart';

class LogoChanger extends StatefulWidget {
  // LogoChanger({Key? key}) : super(key: key);

  @override
  _LogoChangerState createState() => _LogoChangerState();
}

class _LogoChangerState extends State<LogoChanger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로고바꾸기'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LargeFileMain()));
              },
              child: Text(
                '로고 바꾸기',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(),
    );
  }
}
