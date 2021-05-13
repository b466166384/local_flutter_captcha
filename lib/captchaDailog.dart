import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/ImageClipper.dart';

import 'dart:ui' as ui;

class captchaDailog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _captchaDailogState();
  }
}

class _captchaDailogState extends State<captchaDailog> {
  //拼图X轴移动的距离
  var _value = 0.0;

  //图片原始高度
  var _originalHeight;

  //图片原始宽度
  var _originalWidth;

  //设置的图片高度
  var _picHeight = 230.0;

  //设置的图片宽度
  var _picWidth = 400.0;

  //抠图的X轴位置
  var _clipX = 150.0;

  //抠图的y轴位置
  var _clipY = 100.0;

  //正方形拼图的大小
  var _size = 60.0;

  //图片集合
  final List<String> _picList = [
    "images/slider1.jpg",
    "images/slider2.jpg",
    "images/slider3.jpg",
    "images/slider4.jpg",
    "images/slider6.jpg",
    "images/slider8.jpg"
  ];

  //显示的图片
  String _picStr;

  ImageClipper clipper;
  Random _Random = new Random();

  //是否刷新
  bool _refresh = false;

  //是否首次加载
  bool _isFirst = true;

  //是否验证成功
  bool _isSuccess = false;
  bool _isShowBottom = false;

  //print(num);
   double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    _picWidth = screenWidth-50;
    print(_picWidth.toString()+"------screenWidth"+screenWidth.toString());
    // TODO: implement build
    if (_refresh || _isFirst) {
      _isFirst = false;
      _refresh = false;
      //随机验证图片
      int num = _Random.nextInt(_picList.length);
      _picStr = _picList[num];
    }
    clip();
    return Container(
       /* decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white),*/
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: _picWidth,
                  height: _picHeight,
                  child: Stack(
                    children: [
                          //背景图片
                          Image.asset(
                            _picStr,
                            width: _picWidth,
                            height: _picHeight,
                            fit: BoxFit.fill,
                          ),
                      //抠图位置
                      Positioned(
                        top: _clipY,
                        left: _clipX,
                        height: _size,
                        width: _size,
                        child: Container(
                          color: Colors.white,
                          width: _size,
                          height: _size,
                        ),
                      ),
                      //拼图位置
                      Positioned(
                        top: _clipY,
                        left: _value,
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: CustomPaint(
                              painter: clipper,
                              size: Size(_size, _size),
                            )),
                      ),
                      //刷新图标
                      Positioned(
                        top: 10,
                        left: _picWidth - 40,
                        height: 40,
                        width: 40,
                        child: InkWell(
                          onTap: () => refreshPic(),
                          child: Image.asset(
                            "images/iconRefresh.png",
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                      //验证成功
                      Positioned(
                        bottom: 0,
                        child: bottomToast(),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: _picWidth,
                  child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          trackHeight: 35,
                          //滑块样式
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 20.0,
                              disabledThumbRadius: 3.0),
//                        //未激活部分轨道颜色
                          inactiveTrackColor: Color(0xffBBBBBB),
                          inactiveTickMarkColor: Color(0xffBBBBBB),
//                        //激活部分轨道颜色
                          activeTrackColor: Color(0xffFF9800),
                          activeTickMarkColor: Color(0xffFF9800),
                          thumbColor: Colors.green),
                      child: Slider(
                        value: _value,
                        max: _picWidth - _size,
                        min: 0,
                        //分量的个数，这里分100份
                        divisions:
                            int.parse(_picWidth.toString().split(".")[0]),
                        //拖动改变回调
                        onChanged: (val) {
                          setState(() {
                            if (val.roundToDouble() >= _picWidth - _size) {
                            } else {
                              _value = val.roundToDouble();
                            }
                          });

                        },
                        //滑动开始回调
                        onChangeStart: (val){
                          setState(() {
                            _isShowBottom = false;
                            _isSuccess = false;
                          });
                        },
                        //滑动结束回调
                        onChangeEnd: (val) {
                          print(_value.toString());
                          if (_value >= _clipX - 10 && _value <= _clipX + 10) {
                            print("成功");
                            setState(() {
                              _isShowBottom = true;
                              _isSuccess = true;
                            });
                          } else {
                            print("失败");
                            setState(() {
                              _isShowBottom = true;
                              _isSuccess = false;
                              _value = 0.0;
                            });
                          }
                        },
                      )),
                ),
              ],
            )
          ],
        ),
      );
  }

  refreshPic() {
    int num = new Random().nextInt(_picList.length);
    _refresh = true;
    setState(() {
      _picStr = _picList[num];
      _clipX = randomCoordinateX();
      _clipY = randomCoordinateY();
      _value = 0.0;
      _isShowBottom = false;
      _isSuccess  = false;
    });
  }

  //拼图图片缓存生成
  Future _loadImge() async {
    ImageStream imageStream = AssetImage(_picStr).resolve(ImageConfiguration());
    Completer completer = Completer();
    void imageListener(ImageInfo info, bool synchronousCall) {
      ui.Image image = info.image;
      _originalHeight = image.height;
      _originalWidth = image.width;
      completer.complete(image);
      imageStream.removeListener(ImageStreamListener(imageListener));
    }

    imageStream.addListener(ImageStreamListener(imageListener));
    return completer.future;
  }

  //裁剪拼图图片
  clip() async {
    ui.Image uiImage;
    _loadImge().then((image) {
      uiImage = image;
    }).whenComplete(() {
      clipper = ImageClipper(uiImage,
          left: _clipX / (_picWidth / _originalWidth) + 1,
          top: _clipY / (_picHeight / _originalHeight) + 1,
          right: _clipX / (_picWidth / _originalWidth) + _size,
          bottom: _clipY / (_picHeight / _originalHeight) + _size);
      setState(() {});
    });
  }

  //随机抠图X轴位置
  double randomCoordinateX() {
    int num = _Random.nextInt(doubleParseInt(_picWidth - _size));
    if (num <= _size) {
      num = num + (screenWidth/3).floor();
    }
    return double.parse(num.toString());
  }

  //随机抠图Y轴位置
  double randomCoordinateY() {
    int num = _Random.nextInt(doubleParseInt(_picHeight - _size));
    if (num <= 60) {
      num = num + 50;
    }
    return double.parse(num.toString());
  }

  //double 转int
  int doubleParseInt(double d) {
    print(d.toString() + "-----" + d.floor().toString());
    return d.floor();
  }

  //底部提示语
  bottomToast() {
    if (_isShowBottom) {
      if (_isSuccess) {
        return Container(
          width: _picWidth,
          height: 30,
          color: Colors.black,
          child: Text(
            "验证成功",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        );
      } else {
        return Container(
          width: _picWidth,
          height: 30,
          color: Colors.black,
          child: Text(
            "验证失败",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        );
      }
    } else {
      return Container();
    }
  }

  static void popDialog(BuildContext context, Widget widget) {}
}
