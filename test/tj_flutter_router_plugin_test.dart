import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tj_flutter_router_plugin/tj_flutter_router_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('tj_flutter_router_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });


}
