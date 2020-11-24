
import 'package:flutter/services.dart';

typedef TJHttpResponse(String response, bool success, String error);
typedef TJCompletion(dynamic result);
class TJFlutterRouterPlugin {
  static const MethodChannel _channel = const MethodChannel('tj_flutter_router_plugin');
  static TJFlutterRouterPlugin plugin = new TJFlutterRouterPlugin._internal();
  Map<String, TJHttpResponse> requestMap = new Map();
  Map<String, Function(dynamic result)> completionMap = new Map();

  TJFlutterRouterPlugin._internal() {
    //原生调用flutter
    _channel.setMethodCallHandler((MethodCall methodCall) {
      String method = methodCall.method;
      Map arguments = methodCall.arguments;
      if (method == "sendRequestWithURL") {//网络请求回调
        String url = arguments["url"];
        String error = arguments["error"];
        bool success = arguments["success"];
        TJHttpResponse request = requestMap[url];
        request(arguments["response"], success, error);
        requestMap.remove(url);
      } else if (method == "completion") {
        String url = arguments["url"];
        dynamic result = arguments["result"];
        completionMap[url](result);
      }
    });
  }

  openURL({String url, TJCompletion complete}) {
    _channel.invokeMethod("openURL", {
      "url": url ?? ""
    });
    completionMap[url] = complete;
  }

  pop() {
    _channel.invokeMethod("pop");
  }


  void sendRequestWithURL(String url, Map params,
      void onData(String response, bool success, String error)) {
    _channel.invokeMethod("sendRequestWithURL", {
      "url": url ?? "",
      "params": (params ?? {}),
    });
    requestMap[url] = onData;
  }

  void completion(String url, dynamic result) {
    _channel.invokeMethod("completion", {
      "url": url ?? "",
      "result":result
    });
  }
}