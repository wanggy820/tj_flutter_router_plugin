import 'hybrid_manager.dart';
import 'dart:ui' as ui;

class TJRouter {

  static openURL({String url, Completion complete}) {
    HybridManagerPlugin.hybridManagerPlugin
        .openURL(url: url, complete: complete);
  }

  static pop() {
    HybridManagerPlugin.hybridManagerPlugin.pop();
  }

  static void completion(dynamic result) {
    String router = ui.window.defaultRouteName;
    print(router);
    return HybridManagerPlugin.hybridManagerPlugin.completion(router, result);
  }
}
