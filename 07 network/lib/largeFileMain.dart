import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LargeFileMain extends StatefulWidget {
  // LargeFileMain({Key? key}) : super(key: key);

  @override
  _LargeFileMainState createState() => _LargeFileMainState();
}

class _LargeFileMainState extends State<LargeFileMain> {
  //Url 고정
  // final imgUrl =
  //     'https://images.pexels.com/photos/240040/pexels-photo-240040.jpeg'
  //     '?auto=compress';

  TextEditingController? _editingController;
  bool downloading = false;
  var progressString = "";
  String file = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController = new TextEditingController(
        text: 'https://images.pexels.com/photos/240040/pexels-photo-240040.jpeg'
            '?auto=compress');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          //Url 고정
          // title: Text('Large File Example'),
          title: TextField(
            controller: _editingController,
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: 'url을 입력하세요'),
          ),
        ),
        body: Center(
            child: downloading
                ? Container(
                    height: 120.0,
                    width: 200.0,
                    child: Card(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Downloading File: $progressString',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                : FutureBuilder(
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          print('none');
                          return Text('No Data');
                        case ConnectionState.waiting:
                          print('waiting');
                          return CircularProgressIndicator();
                        case ConnectionState.active:
                          print('active');
                          return CircularProgressIndicator();

                        case ConnectionState.done:
                          print('done');
                          if (snapshot.hasData) return snapshot.data as Widget;
                      }
                      print('end progress');
                      return Text('No Data');
                    },
                    future: downloadWidget(file),
                  )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            downloadFile();
          },
          child: Icon(Icons.file_download),
        ),
      ),
    );
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();

      // await dio.download(imgUrl, '${dir.path}/myimage.jpg',
      await dio
          .download(_editingController!.value.text, '${dir.path}/myimage.jpg',
              onReceiveProgress: (rec, total) {
        file = '${dir.path}/myimage.jpg';
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) +
              '%' +
              '\n' +
              (rec.toString()) +
              ' | ' +
              (total.toString());
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = 'Completed';
    });
    print(progressString);
  }

  Future<Widget> downloadWidget(String filePath) async {
    File file = File(filePath);
    bool exist = await file.exists();

    //evict(): 캐시 초기화
    new FileImage(file).evict();

    if (exist) {
      return Center(
        child: Column(
          children: <Widget>[Image.file(File(filePath))],
        ),
      );
    } else {
      return Text('No Data');
    }
  }
}
