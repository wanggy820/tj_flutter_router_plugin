import 'package:tj_flutter_router_plugin/tj_flutter_router_plugin.dart';

class TJHTTPResquest {

  static Future<Map> sendRequestWithURL(String url, Map params) async {
    return TJFlutterRouterPlugin.plugin.sendRequestWithURL(
        url, params);
  }
}