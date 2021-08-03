import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'VC1.dart';
import 'VC2.dart';


void main() {
  String router = ui.window.defaultRouteName;
  Uri uri = Uri.parse(router);
  print("原生数据---：" + uri.path + ",query:" + uri.queryParameters.toString());//根据url.path 跳转不同页面
  switch (uri.path) {
    case "/page1":
      runApp(VC1(uri.queryParameters["title"]));
      break;

    default :
      runApp(VC2(uri.queryParameters["title"]));

      break;
  }

}


