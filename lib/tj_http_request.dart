import 'package:tj_flutter_router_plugin/tj_flutter_router_plugin.dart';

class TJHTTPResquest {

  static void sendRequestWithURL(String url, Map params,
      TJHttpResponse response) {
    TJFlutterRouterPlugin.plugin.sendRequestWithURL(
        url, params, response);
  }
}