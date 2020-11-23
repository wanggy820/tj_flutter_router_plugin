import 'hybrid_manager.dart';

class TJHTTPResquest {

  static void sendRequestWithURL(String url, Map params,
      TJHttpResponse response) {
    HybridManagerPlugin.hybridManagerPlugin.sendRequestWithURL(
        url, params, response);
  }
}