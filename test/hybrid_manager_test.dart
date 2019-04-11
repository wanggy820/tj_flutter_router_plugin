import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hybrid_manager/hybrid_manager.dart';

void main() {
  const MethodChannel channel = MethodChannel('hybrid_manager');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
//    expect(await HybridManagerPlugin.platformVersion, '42');
  });
}
