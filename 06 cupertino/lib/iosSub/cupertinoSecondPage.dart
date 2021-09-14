import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tabbar_listview/animalItem.dart';

class CupertinoSecondPage extends StatefulWidget {
  final List<Animal> animalList;
  CupertinoSecondPage({Key? key, required this.animalList}) : super(key: key);

  @override
  _CupertinoSecondPageState createState() => _CupertinoSecondPageState();
}

class _CupertinoSecondPageState extends State<CupertinoSecondPage> {
  TextEditingController? _textController;
  int _kindChoice = 0;
  bool _flyExist = false;
  String? _imagePath;
  Map<int, Widget> segmentWidgets = {
    0: SizedBox(
      child: Text(
        '양서류',
        textAlign: TextAlign.center,
      ),
      width: 80,
    ),
    1: SizedBox(
      child: Text(
        '포유류',
        textAlign: TextAlign.center,
      ),
      width: 80,
    ),
    2: SizedBox(
      child: Text(
        '파충류',
        textAlign: TextAlign.center,
      ),
      width: 80,
    )
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('동물추가'),
      ),
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                //Cupertino 상단 네비게이션 바 영역 기본적으로 차지하는 이유가 무엇인지?
                padding: EdgeInsets.all(10),
                child: CupertinoTextField(
                  controller: _textController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              CupertinoSegmentedControl(
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  children: segmentWidgets,
                  groupValue: _kindChoice,
                  onValueChanged: (int value) {
                    setState(() {
                      _kindChoice = value;
                    });
                  }),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('날개가 존재합니까?'),
                    CupertinoSwitch(
                        value: _flyExist,
                        onChanged: (value) {
                          setState(() {
                            _flyExist = value;
                          });
                        }),
                  ]),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      child: Image.asset(
                        'repo/images/cow.png',
                        width: 80,
                      ),
                      onTap: () {
                        _imagePath = 'repo/images/cow.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset(
                        'repo/images/pig.png',
                        width: 80,
                      ),
                      onTap: () {
                        _imagePath = 'repo/images/pig.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset(
                        'repo/images/bee.png',
                        width: 80,
                      ),
                      onTap: () {
                        _imagePath = 'repo/images/bee.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset(
                        'repo/images/cat.png',
                        width: 80,
                      ),
                      onTap: () {
                        _imagePath = 'repo/images/cat.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset(
                        'repo/images/dog.png',
                        width: 80,
                      ),
                      onTap: () {
                        _imagePath = 'repo/images/dog.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset(
                        'repo/images/fox.png',
                        width: 80,
                      ),
                      onTap: () {
                        _imagePath = 'repo/images/fox.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset(
                        'repo/images/monkey.png',
                        width: 80,
                      ),
                      onTap: () {
                        _imagePath = 'repo/images/monkey.png';
                      },
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                  child: Text('동물 추가하기'),
                  onPressed: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('Cupertino'),
                            content: Text(
                              '이 동물은 ${_textController?.value.text} 입니다.'
                              '또 이 동물의 종류는 ${getKind(_kindChoice)}입니다. \n이 동물을 추가하시겠습니까?',
                            ),
                            actions: <CupertinoButton>[
                              CupertinoButton(
                                  child: Text('예'),
                                  onPressed: () {
                                    widget.animalList.add(Animal(
                                        animalName: _textController?.value.text,
                                        kind: getKind(_kindChoice),
                                        imagePath: _imagePath,
                                        flyExist: _flyExist));
                                    Navigator.of(context).pop();
                                  }),
                              CupertinoButton(
                                  child: Text('아니오'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  getKind(int radioValue) {
    switch (radioValue) {
      case 0:
        return "양서류";
      case 1:
        return "파충류";
      case 2:
        return "포유류";
    }
  }
}
