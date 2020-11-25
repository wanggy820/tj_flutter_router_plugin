import 'dart:ui' as ui;
import 'tj_flutter_router_plugin.dart';

class TJRouter {

  static void openURL(String url, {TJCompletion completion}) {
     TJFlutterRouterPlugin.plugin.openURL(url, completion: completion);
  }

  static pop() {
    TJFlutterRouterPlugin.plugin.pop();
  }

  static void completion(dynamic result) {
    String router = ui.window.defaultRouteName;
    print(router);
    return TJFlutterRouterPlugin.plugin.completion(router, result);
  }
}
