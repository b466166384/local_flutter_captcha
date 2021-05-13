import 'package:flutter/material.dart';
import 'captchaDailog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niupi_captcha',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage()
    );
  }





}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() {
    return _HomePage();
  }
}


class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      body:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text("滑块拼图验证"),
                padding: EdgeInsets.all(10.0),
                onPressed: () => popDialog(context),
              )
            ],
          )
        ],
      )
      ,
    );
  }
  popDialog(BuildContext context) {
    return showDialog(context: context,barrierDismissible: false,builder: (context){
      return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              child:
                  Container(
                    /*decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    margin: EdgeInsets.symmetric(horizontal: 10),*/
                    height: 310,
                    child: Center(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                                InkWell(
                                  child:  Padding(
                                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                                      child:Icon(
                                        Icons.highlight_off,
                                        size: 24,
                                      )
                                  ),
                                  onTap: () => {
                                   Navigator.of(context).pop()
                                  },
                                ),
                          ),
                          /*Container(
                            color: Colors.grey,
                            height: 1,
                          ),*/
                          captchaDailog(),
                        ],
                      ),
                    ),
                  )

            );

    });
  }

}