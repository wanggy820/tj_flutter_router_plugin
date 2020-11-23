import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:hybrid_manager_example/VC2.dart';
import 'package:hybrid_manager_example/VC1.dart';

void main() {
  String router = ui.window.defaultRouteName;
  Uri uri = Uri.parse(router);
  print("原生数据---：" + uri.path + ",query:" + uri.queryParameters.toString());//根据url.path 跳转不同页面
  switch (uri.queryParameters["page"]) {
    case "vc1":
      runApp(VC1(uri.queryParameters["title"]));
      break;

    default :
      runApp(VC2(uri.queryParameters["title"]));

      break;
  }

}


