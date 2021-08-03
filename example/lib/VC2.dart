import 'package:flutter/material.dart';
import "package:tj_flutter_router_plugin/tj_router_manager.dart";

class VC2 extends StatelessWidget {
  // This widget is the root of your application.
  final String title;
  VC2(this.title);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: MyHomePage(title: this.title == null ?  "default title" : this.title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment(-1, -1),
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.only(right: 60),
                    icon: Image(height:44,width: 44,image: AssetImage('lib/images/back_icon.png')),
                    color: Colors.black,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      print("点击返回图标");
                      TJRouter.pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.title,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                )),
            Expanded(
              child: Text(""),
              flex: 1,
            )
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                TJRouter.openURL("flutter://tojoy/page1?page=vc1&key=value&title=我的title1", completion: (dynamic result){
                  print("flutter?page=vc1收到回调：" + result.toString());
                });
                TJRouter.completion("跳转到flutter页面vc1");
              },
              child: Text("跳转到flutter页面vc1"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: (){
                TJRouter.openURL("flutter://tojoy/page2?page=vc2&key=value&title=我的title2", completion: (dynamic result){
                  print("flutter?page=vc2收到回调：" + result);
                });
              },
              child: Text("跳转到flutter页面vc2"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: (){
                TJRouter.openURL("native://tojoy/vc1?key=value&title=我的title", completion: (dynamic result){
                  print("tojoy://native/vc1收到回调：" + result);
                });
              },
              child: Text("跳转到native页面vc1"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: (){
                TJRouter.openURL("native://tojoy/vc2?key=value&title=我的title");
              },
              child: Text("跳转到native页面vc2"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: (){
                TJRouter.openURL("https://www.baidu.com");
              },
              child: Text("跳转到h5页面"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: () async {
                Map result = await TJHTTPResquest.sendRequestWithURL("http://www.baidu.com", {"key":"value"});
                print("网络请求:response"+result.toString());
              },
              child: Text("网络请求"),
              color: Colors.red,
            ),
            RaisedButton(
              onPressed: (){
                TJRouter.pop();
              },
              child: Text("pop"),
              color: Colors.red,
            ),
          ],
        ),
      ),

    );


  }
}