import 'hybrid_manager.dart';

class WCXHTTPResquest {

  static void sendRequestWithURL(String url, Map params,
      TJHttpResponse response) {
    HybridManagerPlugin.hybridManagerPlugin.sendRequestWithURL(
        url, params, response);
  }
}