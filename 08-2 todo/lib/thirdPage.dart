import 'package:flutter/material.dart';

class ThirdDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //라우터로 전달받은 값 가져오기
    final String args = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Container(
        child: Center(
            child: Text(
          args,
          style: TextStyle(fontSize: 30),
        )
            // child: ElevatedButton(
            //   child: Text('첫 번째 페이지로 이동하기'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            ),
      ),
    );
  }
}
