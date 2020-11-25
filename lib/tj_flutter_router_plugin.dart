
import 'package:flutter/services.dart';


typedef TJCompletion(dynamic result);

class TJFlutterRouterPlugin {
  static const MethodChannel _channel = const MethodChannel('tj_flutter_router_plugin');
  static TJFlutterRouterPlugin plugin = new TJFlutterRouterPlugin._internal();
  static Map<String, TJCompletion> _completionCanche = new Map();


  TJFlutterRouterPlugin._internal() {
    //原生调用flutter
    _channel.setMethodCallHandler((MethodCall methodCall) {
      String method = methodCall.method;
      Map arguments = methodCall.arguments;
      if (method == "completion") {
        TJCompletion completion = _completionCanche[arguments["url"]];
        if (completion != null) {
          dynamic result = arguments["result"];
          completion(result);
        }
      }
    });
  }

  void openURL(String url, {TJCompletion completion}) {
    _channel.invokeMethod("openURL", url);
    _completionCanche[url] = completion;
  }

  pop() {
    _channel.invokeMethod("pop");
  }

  Future<Map> sendRequestWithURL(String url, Map params) async {
    final Map result = await _channel.invokeMethod("sendRequestWithURL", {
      "url": url ?? "",
      "params": (params ?? {}),
    });
    return result;
  }

  void completion(String url, dynamic result) {
    _channel.invokeMethod("completion", {
      "url": url ?? "",
      "result":result
    });
  }
}