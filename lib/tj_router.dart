import 'dart:ui' as ui;
import 'tj_flutter_router_plugin.dart';

class TJRouter {

  static openURL({String url, TJCompletion complete}) {
    TJFlutterRouterPlugin.plugin
        .openURL(url: url, complete: complete);
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
