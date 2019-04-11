import 'hybrid_manager.dart';

class WCXRouter {
  static Future<Map> getMainEntryParams() async {
    return HybridManagerPlugin.hybridManagerPlugin.getMainEntryParams();
  }

  static openNativeWithURL({String url, Map params, bool animated}) {
    HybridManagerPlugin.hybridManagerPlugin
        .openNativeWithURL(url: url, params: params, animated: animated);
  }

  static openFlutterWithURL({String url, Map params, bool animated}) {
    HybridManagerPlugin.hybridManagerPlugin
        .openFlutterWithURL(url: url, params: params, animated: animated);
  }

  static pop({bool animated}) {
    HybridManagerPlugin.hybridManagerPlugin.pop(animated: animated);
  }
}
