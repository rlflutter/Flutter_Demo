import 'package:flutter/material.dart';

// =>是dart语言单行函数或方法的简写
void main() => runApp(new MyApp());

// 继承了 StatelessWidget，这将会使应用本身也成为一个widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      //Scaffold 是 Material library 中提供的一个widget,
      // 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性.
      // widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget来显示自己
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        // body的widget树中包含了一个Center widget, Center widget又包含一个 Text 子widget
        body: new Center(
          child: new Text('Hello World'),
        ),
      ),
    );
  }
}