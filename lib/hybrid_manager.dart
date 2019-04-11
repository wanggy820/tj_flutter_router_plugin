import 'dart:async';

import 'package:flutter/services.dart';

typedef TJHttpResponse(String response, String error);
class HybridManagerPlugin {
  MethodChannel _channel;
  static HybridManagerPlugin hybridManagerPlugin = new HybridManagerPlugin._internal();
  Map<String, TJHttpResponse> requestMap = new Map();

  HybridManagerPlugin._internal() {
    //原生调用flutter
    _channel = new MethodChannel('hybrid_manager');
    _channel.setMethodCallHandler((MethodCall methodCall) {
      String method = methodCall.method;
      Map arguments = methodCall.arguments;
      if (method == "sendRequestWithURL") {
        String url = arguments["url"];
        String error = arguments["error"];
        TJHttpResponse request = requestMap[url];
        request(arguments["response"], error);
        requestMap.remove(url);
      }
    });
  }

  openNativeWithURL({String url, Map params, bool animated}) {
    _channel.invokeMethod("openNativeWithURL", {
      "url": url ?? "",
      "params": (params ?? {}),
      "animated": animated ?? true
    });
  }

  openFlutterWithURL({String url, Map params, bool animated}) {
    _channel.invokeMethod("openFlutterWithURL", {
      "url": url ?? "",
      "params": (params ?? {}),
      "animated": animated ?? true
    });
  }

  pop({bool animated = true}) {
    _channel.invokeMethod("pop", animated);
  }

  Future<Map> getMainEntryParams() async {
    dynamic info = await _channel.invokeMethod("getMainEntryParams");
    return new Future.sync(() => info as Map);
  }

  void sendRequestWithURL(String url, Map params,
      void onData(String response, String error)) {
    _channel.invokeMethod("sendRequestWithURL", {
      "url": url ?? "",
      "params": (params ?? {}),
    });
    requestMap[url] = onData;
  }

}
